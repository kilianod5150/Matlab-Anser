% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% Run the system for a single sensor.
% Use this script as a reference program for writing EMT applications.

SYSTEM = '7x7';
DAQ = 'nidaq621Xoem';
BOARDID = 'Dev1';
SAMPLESIZE = 5000;
MODELTYPE = 'exact';

global Fs
Fs=100e3;

% Place the sensor channels to use in this vector. Add further channels to
% this vector if more sensors are required
sensorsToTrack = [1];

% Aquisition refresh rate in Hertz
refreshRate = 1;

% Call the setup function for the system.
sys = fSysSetup(sensorsToTrack, SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);
global sessionData;
% Give DAQ some time to start.
pause(0.5);
smoothing=1;

%get initial position
sys = fSysDAQUpdate(sys);
sys = fGetSensorPosition(sys, sensorsToTrack(1));
%ignore first point
for i=1:10;
sys = fSysDAQUpdate(sys);
sys = fGetSensorPosition(sys, sensorsToTrack(1));
position0_store(i,:) = sys.positionVector;
end
position0=mean(position0_store);


FS = stoploop();
while (~FS.Stop())
    
   % Retrieve the latest information from the DAQ. This call retrieves data
   % from all sensors simultaneously and should be called ONLY ONCE per
   % acquisition iteration.
   sys = fSysDAQUpdate(sys);
   
   % Acquire the position for one sensor, the first in sensorsToTrack
   %sys = fGetSensorPosition(sys, sensorsToTrack(1));
   %sys1 = fGetSensorPositionWithGain(sys, sensorsToTrack(1));
   sys = fGetSensorPosition(sys, sensorsToTrack(1));
   
    position = sys.positionVector;
    disp(1000*position(1:3));
%    
      
%    position2 = sys2.positionVector;
%    disp(position2);
%    
   
   %disp(1000*sqrt((position(1)-position0(1))^2+(position(2)-position0(2))^2 +(position(3)-position0(3))^2 ));
   %disp(1000*[ (position(1)-position0(1)) (position(2)-position0(2)) (position(3)-position0(3))  ] );
  
   
   % disp(1000*sqrt(position(1)^2+position(2)^2+(position(3)-.081)^2));
   % Call again for a different sensor, where X is the number of the
   % sensor channel. This will overwrite the previous stored position in
   %  the sys.positionVector storage variable.
   % sys = fGetSensorPosition(sys, sensorsToTrack(X));
   
   
   ft = fft(sessionData(:, 2));

    plot((1:(length(ft)/2))./(length(ft)/2)*Fs*.5, smooth(20*log10(abs(ft(1:(length(ft)/2)))/length(ft)),smoothing)); %noise density


    hold off

    ylim([-120,-0]) 
    xlim([10,Fs/2])
    ylabel('V/sqrt(Hz)')
   
   
   % Required 1ms delay for DAQ
   pause(1/refreshRate);

end