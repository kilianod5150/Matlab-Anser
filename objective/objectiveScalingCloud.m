function [residual] = objectiveScalingCloud(param, sensorFieldsMeas, sys, M)
%OBJECTIVESCALINGEIGHT Summary of this function goes here
%   Detailed explanation goes here

% Unpack variables

x = param(1:M);
y = param(M+1:2*M);
z = param(2*M+1:3*M);
theta = param(3*M+1:4*M);
phi = param(4*M+1:5*M);
scalings = param(5*M+1:end);

% Contribution from Coil 1 through 8 
% Rows index the position of measurement
% Columns index the coil contribution
% i (row). 10 test positions by default.
% x, y and z are variables
Vmodel=zeros(M,8);
for j=1:M
    
    [Hx(j,:),Hy(j,:),Hz(j,:)]=  spiralCoilFieldCalcMatrix(1,sys.xcoil,sys.ycoil,sys.zcoil,x(j),y(j),z(j));
    
    Vmodel(j,:) = (scalings).*(Hx(j,:).*sin(theta(j)).*cos(phi(j)) + Hy(j,:).*sin(theta(j)).*sin(phi(j)) + Hz(j,:).*cos(theta(j)));
end

residual_return = Vmodel(:) - sensorFieldsMeas(:);

residual = residual_return';

end

