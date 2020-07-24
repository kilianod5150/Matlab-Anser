function [P_out] = fCoilRotateAndTranslate(P_in, Origin, Rotation_angles, Translation_offsets)
%COIL_ROTATE_AND_TRANSLATE Summary of this function goes here
%   Function to rotate and shift coil designs in space
%P_in is a 3xN vector of points
%Origin is the center point of the coil
% Rotation angles are 3 rotation angles as defined by Euler angles
% definition using the geometrical definition
% (https://en.wikipedia.org/wiki/Euler_angles) 
%where phi  is the angle between the x axis and the N axis (x-convention) 
%theta is the angle between the z axis and the Z axis.
%psi is the angle between the N axis and the X axis (x-convention).
%Translation_offsets is a vector of x,y,z offsets

P_in(1,:)=P_in(1,:)-Origin(1);
P_in(2,:)=P_in(2,:)-Origin(2);
P_in(3,:)=P_in(3,:)-Origin(3);

R_phi=rotz(rad2deg(Rotation_angles(1)));
R_theta=roty(rad2deg(Rotation_angles(2)));
R_psi=rotz(rad2deg(Rotation_angles(3)));

R=R_phi*R_theta*R_psi;
T=[R [Translation_offsets(1)+Origin(1); Translation_offsets(2)+Origin(2);  Translation_offsets(3)+Origin(3)]; [0 0 0 1]];

P_temp=T*[P_in; ones(1,length(P_in))];
P_out=P_temp(1:3,:);

end

