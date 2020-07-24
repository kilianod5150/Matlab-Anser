function [rmsErrorBz,xError_out,yError_out,zError_out,rError,Percentile_90th_Error,solution,resnorm,residual,firstorderopt,iterations] = fCheck_more_detailed(sys)
% fCheck.m
% Evaluated the quality of the system calibration by providing an error metric in millimeters
% Function uses the calibration vector to resolve each of the testpoint positions
% The resolved points are then compared to the predefined testpoints used in the calibration algorithm.
% An ideal perfect calibration will yield no error, implying the calibration vector perfectly fits the model.
% Realistically an error will always be present due to positional uncertainty, manufacturing tolerances and noise during the calibration procedure.

% sys        = The system object

% rmsErrorBz = The RMS error in the z-direction between the analytic testpoint location and the LMA resolved test point locations.



% Define position algorithm parameters.
%options = optimset('TolFun',1e-17,'TolX',1e-8,'MaxFunEvals',500,'MaxIter',500,'Display','final');
options = optimset('TolFun',1e-17,'TolX',1e-8,'MaxFunEvals',500,'MaxIter',500,'Display','iter');


% Generate a matrix of 5-DOF solution vectors. One vector for each resolved testpoint
solution = zeros(length(sys.ztestpoint),6);


% Iterate over the field strengths detected at each testpoint and solve for the position
for i =1:length(sys.ztestpoint) 
    

    % Set the initial position for the solver to the analytically predefined testpoint positions. Theta and Phi are initialised to zero, as the sensor is placed axially in the test block.
    x0 = [sys.xtestpoint(i),sys.ytestpoint(i), sys.ztestpoint(i), pi, 0 1];
    % Extract the field strength values sensed at a particular testpoint
    fluxReal = sys.BStoreActive(:,i);
	        
	
    % Create new function handle for each testpoint to the magnetic field objective objective function.
    % 'currentP&O' is the solution vector we declare as the solver's variable parameter.
    % 'sys' is the system object.
    % 'fluxReal' contains the field strength measurements for the current testpoint.
    objectiveCoil3D = @(currentPandO)objectiveCoilSquareCalc3DWithGain(currentPandO, sys, fluxReal);
    
    
    % Run the algorithm depending on the setup configuration.

    %solution(i,:)= lsqnonlin(objectiveCoil3D,x0,[-.25 -.25 0 -pi -2*pi],[.25 .25 0.5 pi 2*pi],options);  
    [solution(i,:),resnorm(i),residual(i,:),~,output]= lsqnonlin(objectiveCoil3D,x0,[-.25 -.25 0 -5*pi -5*pi .9],[.25 .25 0.5 5*pi 5*pi 1.1],options);  
    firstorderopt(i)=output.firstorderopt;
    iterations(i)=output.iterations;
end


% Determine position error between the analystical test points and the resolved solutions in [x,y,z] 
xError=(sys.xtestpoint' - solution(:,1));
yError=(sys.ytestpoint' - solution(:,2));
zError=(sys.ztestpoint' - solution(:,3));

xError_out=xError;
yError_out=yError;
zError_out=zError;

xError=xError-mean(xError);
yError=yError-mean(yError);
zError=zError-mean(zError);

% Calculate the  RMS error in millimeters.
rError = sqrt(xError.^2+yError.^2+zError.^2); 
Percentile_90th_Error=1000*prctile(rError,90);
rmsErrorBz = 1000*mean(rError);

figure
scatter3(solution(:,1),solution(:,2),solution(:,3));
hold on
scatter3(sys.xtestpoint',sys.ytestpoint',sys.ztestpoint'-mean(zError_out));

xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')

end