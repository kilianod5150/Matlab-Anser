% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function [Bdiff]=objectiveTransmitCoilFinder(parameters, calFieldCoil, coilIndex, sys)
% objectiveScalingOffsetZ.m
% Objective function for the calibration procedure for the coil finder
% routine.

% parameters   = The vector of variable parameters [zoffset, Bscale] for the LMA algorithm.
    % zoffset indicates the most recent estimation of the error between ideal and actual sensor position
    % Bscale is the most recent estimation of the calibration scaling factor required to fit the realworld magnetic field with the model.
% calFieldCoil = The vector of magnetic field strengths of size 'numCalPoints'. Each strength value in this vector represents the field strength at an individual testpoint due to a single emitter coil of index 'coilIndex'.
% coilIndex    = The index of the coil currently being analysed
% sys          = The system object

% Bdiff        = A vector of length 'numCalPoints'. Contains the magnetic field strength differences in the z-direction between the model and sensed fields, due to a single emitter coil 'coilIndex'.


% Extract the variable parameters for readability
translation_matrix=parameters(1:3)';
angle_matrix=parameters(4:6)';
Bscale=parameters(7);
theta_sensor=parameters(8);
phi_sensor=parameters(9);


% The number of calibration points using the Duplo board
numCalPoints = length(sys.xtestpoint);


% Extract the [x,y,z] positions for readability
x = sys.xtestpoint;
y = sys.ytestpoint;
z = sys.ztestpoint; 

[~,~,~,coil_length,track_width,track_spacing,pcb_thickness,coil_turns,~,~] = fCoilCalSpec(sys.SYSTEM);
[x_points,y_points,z_points] = fGenerateCoil(coil_length, track_width, track_spacing, pcb_thickness, pi/2, coil_turns, sys.modelType);

P_out = fCoilRotateAndTranslate([x_points; y_points; z_points], [0 0 0], angle_matrix, translation_matrix);
x_points=P_out(1,:);
y_points=P_out(2,:);
z_points=P_out(3,:);

% Calculate magnetic field at each testpoint with the mathematical current-filament model due a single emitter coil (coilIndex).
for i = 1:numCalPoints
    %[Hx(i,:),Hy(i,:),Hz(i,:)]= spiralCoilFieldCalcMatrix(1,sys.xcoil(coilIndex,:),sys.ycoil(coilIndex,:),sys.zcoil(coilIndex,:),x(i),y(i),z(i));
    [Hx(i,:),Hy(i,:),Hz(i,:)]= spiralCoilFieldCalcMatrix(1,x_points,y_points,z_points,x(i),y(i),z(i));

end


% Scale the result with the most recent estimate of the calibration scaling factor.
Hz_scaled = Hz * Bscale; 
Flux_scaled=Bscale*(Hx.*sin(theta_sensor).*cos(phi_sensor)+Hy.*sin(theta_sensor).*sin(phi_sensor)+Hz.*cos(theta_sensor));

% Vectorise each component.
%BVectorised = Hz_scaled;
BVectorised = Flux_scaled;


% Returns the difference between the sensed and modelled flux in the z-direction at each test point, due toa single PCB emitter coil..
Bdiff = (calFieldCoil - BVectorised');
