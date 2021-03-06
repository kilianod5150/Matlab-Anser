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

sensorToCheck = [4];

% Select the desired sensor channel. This will also ensure the appropriate calibration
% parameters are saved after calibration.
sys = fSysSetup(sensorToCheck,SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);
sys = fSysSensor(sys, sensorToCheck);

% Acquire the testpoints necessary for testing. 
sys = fGetCalField(sys);


% Check the calibration error (Result in millimeters)
%rmsErrorBz = fCheck(sys);
[rmsErrorBz,xError_out,yError_out,zError_out,Percentile_90th_Error] = fCheck_remove_mean(sys);
%[rmsErrorBz] = objectiveScale_B_Field_minimise_error(input,sys)
    Scale_B_Field_minimise_error = @(input)objectiveScale_B_Field_minimise_error(input,sys);
    options = optimset('TolFun',1e-6,'TolX',1e-8,'MaxFunEvals',500,'MaxIter',500,'Display','iter');
%x = fminunc(fun,x0)
    % Initialise the solver.
  	%[fittedParams, resnorm] = fminunc(Scale_B_Field_minimise_error, [1 1 1 1 1 1 1 1],options); 
	%
    [fittedParams, resnorm] = lsqnonlin(Scale_B_Field_minimise_error, [1 1 1 1 1 1 1 1],[],[],options); 
    
