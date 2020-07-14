% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function [Hx,Hy,Hz]= spiralCoilFieldCalcMatrixSimple(I,x_points,y_points,z_points,Px,Py,Pz)
% spiralCoilFieldCalcMatrix.m
% Calculates the magnetic field due a straight current filament at an arbitary orientation relative to an origin
% Based on "Accurate magnetic field intensity calculations for contactless energy transfer coils" - Sonntag, Spree, et al, 2007 (doi: )


% I       = The filament current
% a_start = x,y,z coordinates of start of filament
% a_end   = x,y,z coordinates of end of filament
% P       = x,y,z coordinates of obseration point at which to sense the magnetic field

% Output
% [Hx,Hy,Hz] = Magnetic field intensity vector experienced at observation point P

% Mathematical formulae from which the code is derived can found from the cited paper above

num_p=length(x_points);

bx=x_points(:,2:num_p)-Px;
by=y_points(:,2:num_p)-Py;
bz=z_points(:,2:num_p)-Pz;

cx=x_points(:,1:(num_p-1))-Px;
cy=y_points(:,1:(num_p-1))-Py;
cz=z_points(:,1:(num_p-1))-Pz;

c_cross_a_x=-ay.*cz;
c_cross_a_y=ax.*cz;
c_cross_a_z=cx.*ay-cy.*ax;

scalar_2nd_bit=(((ax.*cx+ay.*cy)./(realsqrt(cx.^2+cy.^2+cz.^2)))-((ax.*bx+ay.*by)./(realsqrt(bx.^2+by.^2+bz.^2))))./(c_cross_a_x.^2+c_cross_a_y.^2+c_cross_a_z.^2);

Hx_dum=I*c_cross_a_x.*scalar_2nd_bit;
Hy_dum=I*c_cross_a_y.*scalar_2nd_bit;
Hz_dum=I*c_cross_a_z.*scalar_2nd_bit;

Hx=sum(Hx_dum,2);
Hy=sum(Hy_dum,2);
Hz=sum(Hz_dum,2);


