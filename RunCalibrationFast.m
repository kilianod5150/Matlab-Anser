% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

SYSTEM = '7x7';
DAQ = 'nidaq621Xoem';
BOARDID = 'Dev1';
SAMPLESIZE = 5000;
MODELTYPE = 'exact';

% Select which sensor channel you will use for calibration.
% Each sensor must be calibrated seperatly due to gain variations
% in the system amplifier electronics.
% Sensor indices begin at '1'
sensorToCal = input('Enter the channel to calibrate: ');
refSensor = input('Enter channel of reference sensor: ');

% Select the desired sensor. This will also ensure the appropriate calibration
% parameters are saved after calibration.
sys = fSysSetup([sensorToCal,refSensor],SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);


% Acquire the testpoints necessary for calibration.
fprintf('\nConnect probe to reference channel, then press enter....\n');
pause;
sys = fSysSensor(sys, refSensor);

for i=1:8
    fprintf('Point %d....', i);
    pause;
    sys = fSysDAQUpdate(sys);
    sys = fSysGetField(sys);
    Bref(i) = sys.BField(i);
    fprintf('done\n');
end

fprintf('Connect probe to desired calibration channel, then press enter....\n');
pause;
sys = fSysSensor(sys, sensorToCal);

for i=1:8
    fprintf('Point %d....', i);
    pause;
    sys = fSysDAQUpdate(sys);
    sys = fSysGetField(sys);
    Bcal(i) = sys.BField(i);
    fprintf('done\n');
end

sys.BScaleActive = (Bcal.*sys.BScale(refSensor,:))./Bref;

sys=fSysSave(sys);
fprintf('Done....!\n');
% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.


% SYSTEM = 'Anser1';
% DAQ = 'mccdaq';
% BOARDID = 'Board0';
% SAMPLESIZE = 5000;

SYSTEM = '7x7';
DAQ = 'nidaq621Xoem';
BOARDID = 'Dev4';
SAMPLESIZE = 5000;
MODELTYPE = 'exact';

% Select which sensor channel you will use for calibration.
% Each sensor must be calibrated seperatly due to gain variations
% in the system amplifier electronics.
% Sensor indices begin at '1'
sensorToCal = input('Enter the channel to calibrate: ');
refSensor = input('Enter channel of reference sensor: ');

% Select the desired sensor. This will also ensure the appropriate calibration
% parameters are saved after calibration.
sys = fSysSetup([sensorToCal,refSensor],SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);


% Acquire the testpoints necessary for calibration.
fprintf('\nConnect probe to reference channel, then press enter....\n');
pause;
sys = fSysSensor(sys, refSensor);

for i=1:8
    fprintf('Point %d....', i);
    pause;
    sys = fSysDAQUpdate(sys);
    sys = fSysGetField(sys);
    Bref(i) = sys.BField(i);
    fprintf('done\n');
end

fprintf('Connect probe to desired calibration channel, then press enter....\n');
pause;
sys = fSysSensor(sys, sensorToCal);

for i=1:8
    fprintf('Point %d....', i);
    pause;
    sys = fSysDAQUpdate(sys);
    sys = fSysGetField(sys);
    Bcal(i) = sys.BField(i);
    fprintf('done\n');
end

sys.BScaleActive = (Bcal.*sys.BScale(refSensor,:))./Bref;

sys=fSysSave(sys);
fprintf('Done....!\n');
