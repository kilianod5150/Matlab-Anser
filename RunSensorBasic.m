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
sensorsToTrack = [3];

% Aquisition refresh rate in Hertz
refreshRate = 1;

% Call the setup function for the system.
sys = fSysSetup(sensorsToTrack, SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);

% Give DAQ some time to start.
pause(0.5);

FS = stoploop();
while (~FS.Stop())
    
   % Retrieve the latest information from the DAQ. This call retrieves data
   % from all sensors simultaneously and should be called ONLY ONCE per
   % acquisition iteration.
   sys = fSysDAQUpdate(sys);
   
   % Acquire the position for one sensor, the first in sensorsToTrack
   sys = fGetSensorPosition(sys, sensorsToTrack(1));
   position = sys.positionVector;
   disp(position);
   %disp(1000*sqrt(position(1)^2+position(2)^2));
  % disp(1000*sqrt(position(1)^2+position(2)^2+(position(3)-.081)^2));
   % Call again for a different sensor, where X is the number of the
   % sensor channel. This will overwrite the previous stored position in
   %  the sys.positionVector storage variable.
   % sys = fGetSensorPosition(sys, sensorsToTrack(X));
   
   % Required 1ms delay for DAQ
   pause(1/refreshRate);

end