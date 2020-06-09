% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% Run a real-time wave plot of a single sensor.
% Use this script as a starting point for visually inspecting the field
% strengths of the tracking system.

SYSTEM = '7x7';
DAQ = 'nidaq621Xoem';
BOARDID = 'Dev1';
SAMPLESIZE = 5000;
MODELTYPE = 'exact';

% Sensor channel the DAQ to inspect. This does NOT directly corresponding to the sensor
% channel. Look at the DAQ pin mapping for
sensorsToTrack = [1];

% Refresh rate of the position acquisition (Hz)
refreshRate = 20;

sys = fSysSetup(sensorsToTrack,SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);

% Get access to the global data structure used by the DAQ
global sessionData;

figure;
FS=stoploop();
pause(1);
while (~FS.Stop())
    
    % Display the waveform of the acquired data
    sys=fSysDAQUpdate(sys);
    plot(1:SAMPLESIZE, sessionData(:,2));
    %periodogram(sessionData(:, 1))
    % Scale the axes of the plots to the desired range.
    pause(1/refreshRate);
end
stop(sys.NIDAQ);