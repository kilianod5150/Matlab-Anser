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

    options=sys.lqOptions;
    options.StepTolerance=1e-6;
    options.FunctionTolerance=1e-16;
    % Initialises the least squares solver.
     [solution,resnorm_store,residual,exitflag,output,~,jacobian]= lsqnonlin(objectiveCoil3D, sys.estimateInit(sys.SensorNo,:),lowerbound,upperbound,sys.lqOptions);
     %[solution,resnorm_store,residual,exitflag,output,~,jacobian]= lsqnonlin(objectiveCoil3D, sys.estimateInit(sys.SensorNo,:),lowerbound,upperbound,options);
    
    resnorm_percentage_mean= 100*mean(abs(residual./sys.BField));
   
    CI = nlparci(solution,residual,'jacobian',jacobian);
    %CI(:,2)-CI(:,1)
    CI_R_m=sqrt( (CI(1,2)-CI(1,1))^2+(CI(2,2)-CI(2,1))^2+(CI(3,2)-CI(3,1))^2 );
    display([1000*CI_R_m resnorm_percentage_mean]);
    %sum(residual.^2)
    % Check if the residual is small enough
    %display([resnorm_store mean(abs(residual)./(abs(sys.BField))) ] )
    %display(abs(sys.BField)');
    %display(abs(residual)');
    %display([mean(abs(residual)./(abs(sys.BField))) ] );
    %display(1000*sqrt(solution(1).^2+solution(2).^2+solution(3).^2));
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