clc
clear 
close all




%Folder_Cell{1,1}='\interpolate_data_grid.fcsv';
%Folder_Cell{1,1}='\interpolate_data_grid_probe_calibrate.fcsv';
%Folder_Cell{1,1}='\steel_shield.fcsv';
Folder_Cell{1,1}='\finer_mesh_3axis.fcsv';
Folder_Cell{1,2}='\standard_data_grid.fcsv';


scaling_factor=1;
icp_max_iterations=250;
monte_carlo_iterations=100;

error_data_store=0;

[num_sets blah]=size(Folder_Cell);

x_tp1=[-2*(31.75e-3) -1*(31.75e-3) 0 1*(31.75e-3) 2*(31.75e-3)]';
x_tp1=[x_tp1; x_tp1; x_tp1; x_tp1; x_tp1];

x_tp2=[-1.5*(31.75e-3) -.5*(31.75e-3) .5*(31.75e-3) 1.5*(31.75e-3)]';
x_tp2=[x_tp2; x_tp2; x_tp2; x_tp2;];

x_tp=[x_tp1; x_tp2];

y_tp=[-2*(31.75e-3)*ones(5,1); -1*(31.75e-3)*ones(5,1); zeros(5,1); 1*(31.75e-3)*ones(5,1); 2*(31.75e-3)*ones(5,1); -1.5*(31.75e-3)*ones(4,1); -0.5*(31.75e-3)*ones(4,1); .5*(31.75e-3)*ones(4,1); 1.5*(31.75e-3)*ones(4,1)];
z_tp=0*y_tp;

data_duplo=1000*[x_tp y_tp z_tp];
% z_start=.10;
% z_end=0.292;
% x_start=-2*(31.75e-3);
% x_end=2*(31.75e-3);
% y_start=-2*(31.75e-3);
% y_end=2*(31.75e-3);
% 
% numpoints=5;
% 
% z=linspace(z_start,z_end,numpoints)-.005;
% x=linspace(x_start,x_end,numpoints);
% y=linspace(y_start,y_end,numpoints)+.0038;
% 
% [xx,yy,zz]=ndgrid(x,y,z);
% 
% xxx=reshape(xx,[1 numpoints^3]);
% yyy=reshape(yy,[1 numpoints^3]);
% zzz=reshape(zz,[1 numpoints^3]);
% 
% data_duplo

figure
plot3(x_tp,y_tp,z_tp);
hold on
scatter3(x_tp,y_tp,z_tp);

for i=1:2;

clear data_out data_mag_shift data_mag data_opt


 [data_mag] = read_CSV_or_FCSV(strcat(cd,Folder_Cell{1,i}));
 data_opt=data_duplo;

%calculate centroid


%[data_out,minimum_error(i)] = global_icp(data_opt,data_mag,icp_max_iterations,monte_carlo_iterations,scaling_factor);
[tform,movingReg,minimum_error(i)] = pcregistericp(pointCloud(data_opt),pointCloud(data_mag),'MaxIterations',icp_max_iterations,'InitialTransform',affine3d([eye(3) [0;0;0]; 0 0 0 1]) );
ptCloudOut = pctransform(pointCloud(data_opt),tform);
best_transform=tform.T;

data_out=ptCloudOut.Location;





out_centroid=mean(data_out);
mag_centroid=mean(data_mag);
data_out=data_out-repmat(out_centroid,length(data_out),1);
data_mag2=data_mag-repmat(mag_centroid,length(data_mag),1);

data_mag2;
error_vector=data_mag2-data_out;
error_vector_rms=vecnorm(error_vector');
error_check(i)=mean(error_vector_rms);
percentile_90th(i) = prctile(error_vector_rms,90);
percentile_95th(i) = prctile(error_vector_rms,95);

figure
scatter3(data_mag(:,1)-mean(data_mag(:,1)),data_mag(:,2)-mean(data_mag(:,2)),data_mag(:,3)-mean(data_mag(:,3)))
hold on
scatter3(data_out(:,1),data_out(:,2),data_out(:,3),'r')
xlabel('x [mm]');
ylabel('y [mm]');
zlabel('z [mm]');
title('Point to Point Accuracy Tests') 
axis equal
legend('Magnetic','Duplo')


end


