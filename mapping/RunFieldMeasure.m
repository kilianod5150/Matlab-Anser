% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% For advanced users.
% Use this file to test the output of the demodulator

SYSTEM = '7x7';
DAQ = 'nidaq621Xoem';
BOARDID = 'Dev1';
SAMPLESIZE = 5000;
MODELTYPE = 'exact';


sensorsToTrack = [11 13 14];
B_temp_sorter=[2 1 3];
string_cell{1}='By';
string_cell{2}='Bx';
string_cell{3}='Bz';
%Bx=13, By=11, Bz=14;


% Aquisition refresh rate in Hertz
refreshRate = 1;

% Call the setup function for the system.
sys = fSysSetup(sensorsToTrack, SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);
FS = stoploop();




clear B_temp
%figure;
FS=stoploop();

while (~FS.Stop())
    
   for i=1:length(sensorsToTrack);
   sys = fSysSensor(sys,sensorsToTrack(i));
   sys = fSysDAQUpdate(sys);
   sys = fSysGetField(sys);
   %plot(1:8,(sys.BField));
   B_temp(:,i)=((sys.u0*sys.BField')./sys.BScaleActive)';
   %string_temp=strcat(string_cell{i},'=',num2str(B_temp(i)));
   %display(string_temp);
   %ylim([-5,5]);
   end
   BSave=[B_temp(:,B_temp_sorter(1)) B_temp(:,B_temp_sorter(2)) B_temp(:,B_temp_sorter(3))]
   B_mag=sqrt(B_temp(:,1).^2+B_temp(:,2).^2+B_temp(:,3).^2)
   pause(1/refreshRate);
end