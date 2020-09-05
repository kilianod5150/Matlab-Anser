function [Hx,Hy,Hz]= interpolateCoilFieldCalc(I,Px,Py,Pz,HxMap,HyMap,HzMap)
% spiralCoilFieldCalcMatrix.m
% uses a gridded interpolant to determine the magnetic fields at a point in
% space

% I       = The filament current
% P       = x,y,z coordinates of observation point at which to sense the magnetic field

% Output
% [Hx,Hy,Hz] = Magnetic field intensity vector experienced at observation point P


Hx=zeros(8,1);
Hy=zeros(8,1);
Hz=zeros(8,1);

for i=1:8
Hx(i,1) = HxMap{i}(Px,Py,Pz);
Hy(i,1) = HyMap{i}(Px,Py,Pz);
Hz(i,1) = HzMap{i}(Px,Py,Pz);
end

%scle by current if needed
Hx=Hx*I;
Hy=Hy*I;
Hz=Hz*I;

end
