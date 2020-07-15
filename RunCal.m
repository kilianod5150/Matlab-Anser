% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

SYSTEM = '7x7';      % (1) SET SYSTEM TYPE FOR CALIBRATION
DAQ = 'nidaq621Xoem';
BOARDID = 'Dev1';
SAMPLESIZE = 5000;
MODELTYPE = 'exact';

clear measurements
global Fs
Fs=100e3;
% USER INPUT CALIBRATION SETTINGS
sensorsToTrack = input('Enter the channel to calibrate: ');   % (2) THE INDEX OF THE SENSOR TO TRACK
measurementCount = input('Enter the # of measurements to acquire: ');;  % (3) THE NUMBER OF MEASUREMENTS USED FOR CALIBRATION

% Call the setup function for the system.
sys = fSysSetup(sensorsToTrack, SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);
sys=fSysSensor(sys,sys.Sensors(1));

input('Place instrument pointing downwards above coil 1, then press Enter ')

sys = fSysDAQUpdate(sys);
sys = fSysGetField(sys);


if (sys.BField(1) < 0)
   calsign = -1;
else
   calsign = 1;
end

input('Press Enter and wave instrument around FG')
pause(1)

% Iterate and collect magnetic field measurements.
for i = 1:measurementCount
   
   fprintf('%d\n', i)
   pause(0.5);
   sys=fSysDAQUpdate(sys);
   sys = fSysGetField(sys);
   measurements(i,:) = sys.BField;
    
end

% Call the calibration script
[scalers, resnorm, residual] = CloudCal(sys, measurements);

% print results
disp('Calibration Scalars:')
disp(calsign * scalers);
disp('Fit Error (Sum of):');
disp(resnorm);

if resnorm < 1e-3
    savechoice = input('Calibration is good, do you want to save? (y/n) ','s');
else
    savechoice = input('Calibration fit is bad, do you want to save? (y/n) ) ','s');
end

if upper(savechoice == 'y')
    % Assign the calibration to the active sensor and apply sign.
    sys.BScaleActive = calsign * scalers;
    sys = fSysSave(sys);
    disp('...Saved');
else
    disp('...calibration discarded');
end