% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function [out]= objectiveCoilSquareCalc3DWithGain(currentPandO, sys, fluxReal)
% objectiveCoilSquareCalc3D.m
% Objective function to calculate the difference between the modelled and measured magnetic flux values due to a single pcb emitter coil.
% This is the 'Cost' function for the LM algorithm. Each iteration of LMA executes this function 8 times, once for each coil.

% currentPandO = The current position and orientation vector. This vector is the variable parameter of the objective function.
% sys          = The system object
% fluxReal     = A scaler indicating the sensed magnetic flux the sensor. 

% out          = The difference between the sensed and calculated fluxes due to a single coil


% Extract the position and orientation for readability
x = currentPandO(1);
y = currentPandO(2);
z = currentPandO(3);
theta = currentPandO(4);
phi = currentPandO(5);
gain= currentPandO(6);

% Calculate the magnetic field intensity at [x,y,z] due to an emitter coil whose copper tracks are traced by [xcoil, ycoil, zcoil]

%scale_temp=1.000; %1.003 seemed to help
% l_scale=1.000;
% spacing_scale=1.000;
% thickness_scale=1;
% centre_point_scale=1.000;
%[x_matrix,y_matrix,z_matrix] = coil_regenerate('7x7',l_scale,spacing_scale,thickness_scale,centre_point_scale);
%current_scalar=1;
%[Hx,Hy,Hz]= spiralCoilFieldCalcMatrix(1*current_scalar,x_matrix,y_matrix,z_matrix,x,y,z); 

%[Hx,Hy,Hz]= spiralCoilFieldCalcMatrix(1,scale_temp*sys.xcoil,scale_temp*sys.ycoil,scale_temp*sys.zcoil,x,y,z); 
[Hx,Hy,Hz]= spiralCoilFieldCalcMatrix(1,sys.xcoil,sys.ycoil,sys.zcoil,x,y,z); 


% Calculate the net magnetic flux cutting the tracking sensor coil.
fluxModel=gain*(sys.BScaleActive)'.*(Hx.*sin(theta).*cos(phi)+Hy.*sin(theta).*sin(phi)+Hz.*cos(theta));


% Return the difference between the calculated magnetic flux and the sensed magnetic flux due to a single emitter coil
out = fluxModel - fluxReal;