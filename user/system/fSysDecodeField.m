% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function solution = fSysDecodeField(sys)
% fSysDecodeField.m
% Resolved the sensor position from the a set of 

% sys      = The system object

% solution = A 5-DOF vector containing the postion and orietation of the sensor.


% Create a function handle with the necessary data for the solver
% 'currentPandO' is specified as the variable parameter. This is a 5-DOF vector.
% 'sys' is the system object
% 'sys.BField' is the most recent set of demodulated magnetic field strengths.
if strcmpi(sys.modelType,'FAST') == 1
   sys.BScaleActive = sys.BScaleActive * 25.1515; % Constant from optimisation process
end

objectiveCoil3D = @(currentPandO)objectiveCoilSquareCalc3D(currentPandO, sys, sys.BField);
    
    % Set the boundry conditions for the solver.

    lowerbound = [-0.5, -0.5, 0, -pi, -3*pi];
    upperbound = [0.5, 0.5, 0.5, pi, 3*pi];

    % Initialises the least squares solver.
    [solution,resnorm_store]= lsqnonlin(objectiveCoil3D, sys.estimateInit(sys.SensorNo,:),lowerbound,upperbound,sys.lqOptions);
    % Check if the residual is small enough
    
    if solution(5) > 2*pi
        solution(5) = solution(5) - 2*pi;
    elseif solution(5) < -2*pi
            solution(5) = solution(5) + 2*pi;
    end
    
% TODO Create fitting quality feedback
%     if resnorm_store>sys.residualThresh; 
%         solution = sys.estimateInit(sys.SensorNo,:);
%         fprintf('Lost Tracking for sensor %d', sys.SensorNo);
%     end

    
end