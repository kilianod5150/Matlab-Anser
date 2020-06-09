% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% For advanced users.
% Use this file to test the output of the demodulator

SYSTEM = '7x7';
DAQ = 'nidaq621Xoem';
BOARDID = 'Dev1';
SAMPLESIZE = 50000;
MODELTYPE = 'exact';


sensorsToTrack = [1];

% Aquisition refresh rate in Hertz
refreshRate = 20;

% Call the setup function for the system.
sys = fSysSetup(sensorsToTrack, SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);
FS = stoploop();




Fs = 100e3;
Ts=1/Fs;
numSamples = SAMPLESIZE;

% Specify the number of time samples, must be the same as the length of X
t=0:Ts:(numSamples - 1) * Ts; 

% Low pass FIR filter
% N, Order %must be the same as the length of t -1
% Fc, Cutoff Frequency
% flag, Sampling Flag
% SidelobeAtten, window parameter  attentation of the stopband
N  = length(t)-1;     
Fc = 0.00005;    
flag = 'scale';  
SidelobeAtten = 200; 

% Create the window vector for the design algorithm.
win = chebwin(N+1, SidelobeAtten);

% Calculate the coefficients using the FIR1 function.
% Extract the filter parameters
bf  = fir1(N, Fc, 'low', win, flag);
Hd = dfilt.dffir(bf); 
f=Hd.Numerator;

% Repeats the filter cooefficnets, must have the same number of rows as there are DAQ input signals.
G=repmat(f,2,1); 

sys.G = G;
figure;
FS=stoploop();
sys = fSysSensor(sys,sensorsToTrack);
while (~FS.Stop())
   
   sys = fSysDAQUpdate(sys);
   sys = fSysGetField(sys);
   plot(1:8,(sys.BField));
   %semilogy(1:8,abs((sys.BField)));
   disp(sys.BField)
   ylim([-5,5]);
   pause(1/refreshRate);

end