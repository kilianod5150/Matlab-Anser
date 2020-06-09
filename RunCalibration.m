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
sensorToCal = input('Enter the channel to Calibrate: ');

% Select the desired sensor channel. This will also ensure the appropriate calibration
% parameters are saved after calibration.
sys = fSysSetup(sensorToCal,SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);
sys = fSysSensor(sys, sensorToCal);

% Acquire the testpoints necessary for calibration.
sys = fGetCalField(sys);

% Perform the calibration routine. Calibration parameters are saved to the
% sys structure
sys = fCalibrate(sys);

% Check the calibration error (Result in millimeters)
rmsErrorBz = fCheck(sys);

% Subtract the detected z-axis offset and attempt a 2nd calibration attempt
sys.ztestpoint = sys.ztestpoint - sys.zOffsetActive;
sys = fCalibrate(sys);

% Recheck the calibration error. It should be smaller than the 1st.
rmsErrorBz = fCheck(sys)

% Save calibration parameters to the system structure and save structure to
% file. This will ensure calibration information is retaint after the
% system is restarted or shutdown.
sys = fSysSave(sys);

