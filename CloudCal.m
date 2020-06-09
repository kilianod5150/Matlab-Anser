function [scalers, resnorm, residual] = CloudCal(sys, measurements)
% Determine the number of acquired measurements as M.
M = length(measurements);
testPointsFlux = measurements;

x = ones(1,M)*0.1;
y = ones(1,M)*0.1;
z = ones(1,M)*0.15;
theta = ones(1,M)*pi;
phi = ones(1,M)*0;
scalings =ones(1,8) *0.5;
params_init = [x,y,z,theta,phi,scalings];


% Upperbounds parameter matrix for the solver.
x_up = ones(1,M)*0.3;
y_up = ones(1,M)*0.3;
z_up = ones(1,M)*0.3;
theta_up = ones(1,M)*pi  *10;
phi_up = ones(1,M)*2*pi *10;
scalings_up = ones(1,8) *2;
params_upper = [x_up,y_up,z_up,theta_up,phi_up,scalings_up];


% Lowerbounds parameter matrix for the solver.
x_low = -ones(1,M)*0.3;
y_low = -ones(1,M)*0.3;
z_low = -ones(1,M)*0;
theta_low = -ones(1,M)*pi *10;
phi_low = -ones(1,M)*2*pi *10;
scalings_low = -ones(1,8) * 0;

params_lower = [x_low, y_low ,z_low ,theta_low ,phi_low ,scalings_low];

% Set solver options using multicore. Set input constants using anonymous
% function creation.
disp('Learning to track sensor from data, please wait... ');
options = optimoptions(@lsqnonlin,'PlotFcn','optimplotx','TolFun',1e-32,'TolX',1e-12,'MaxFunEvals',70000,'MaxIter',4000,'Display','iter','UseParallel',true);
solverFuncObj = @(params)objectiveScalingCloud(params, testPointsFlux, sys, M);

% Initialise the solver.
tic  
[fittedParams, resnorm, residual] = lsqnonlin(solverFuncObj, params_init,params_lower,params_upper,options); 
toc
scalers = fittedParams(end-7:end);
end

