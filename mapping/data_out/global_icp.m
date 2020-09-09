function [data_out,minimum_error,best_transform] = global_icp(data_opt,data_mag,icp_max_iterations,monte_carlo_iterations,scaling_factor)
%GLOBAL_ICP Summary of this function goes here
%   Detailed explanation goes here
data_mag=scaling_factor*data_mag;


%calculate centroid
opt_centroid=mean(data_opt);
mag_centroid=mean(data_mag);

%subtract centroid
data_opt=data_opt-repmat(opt_centroid,length(data_opt),1);
data_mag=data_mag-repmat(mag_centroid,length(data_mag),1);

%correct data manually
TT=[0; 0; 0];
for iter=1:monte_carlo_iterations;
Rotation_angles=2*pi*rand(1,3);
R_phi=rotz(rad2deg(Rotation_angles(1)));
R_theta=roty(rad2deg(Rotation_angles(2)));
R_psi=rotz(rad2deg(Rotation_angles(3)));

TR=R_phi*R_theta*R_psi;
[tform{iter},movingReg,rsme(iter)] = pcregistericp(pointCloud(data_opt),pointCloud(data_mag),'MaxIterations',icp_max_iterations,'InitialTransform',affine3d([TR TT; 0 0 0 1]) );


end

minimum_error=min(rsme);
min_error_index=find(rsme==minimum_error);
min_error_index=min_error_index(1);
ptCloudOut = pctransform(pointCloud(data_opt),tform{min_error_index});
best_transform=tform{min_error_index}.T;

data_out=ptCloudOut.Location;
end

