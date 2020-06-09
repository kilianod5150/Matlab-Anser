function [x_matrix,y_matrix,z_matrix] = coil_regenerate(systemType,l_scale,spacing_scale,thickness_scale,centre_point_scale)
%COIL_REGENERATE Summary of this function goes here
%   Detailed explanation goes here
[x,y,z,coil_length,track_width,track_spacing,pcb_thickness,coil_turns,centre_x,centre_y] = fCoilCalSpec(systemType);
ModelType='exact';
l=coil_length*l_scale; 
w=track_width*spacing_scale; 
s=track_spacing*spacing_scale; 
thickness=pcb_thickness*thickness_scale; 
Nturns=coil_turns;

% Calculate generic points for both the vertical and angled coil positions
[x_points_angled,y_points_angled,z_points_angled] = fGenerateCoil(l, w, s, thickness, pi/4, Nturns, ModelType);
[x_points_vert,y_points_vert,z_points_vert] = fGenerateCoil(l, w, s, thickness, pi/2, Nturns, ModelType);

%[x_points_angled,y_points_angled,z_points_angled]=spiralCoilDimensionCalc(Nturns,l,w,s,thickness,pi/4); %angled coils at 45 degrees
%[x_points_vert,y_points_vert,z_points_vert]=spiralCoilDimensionCalc(Nturns,l,w,s,thickness,pi/2); %coils that are square with the lego

% Define the positions of each centre point of each coil

x_centre_points = centre_x*centre_point_scale;
y_centre_points = centre_y*centre_point_scale;

% Add the center position offsets to each coil
x_points1=x_points_vert+x_centre_points(1);
x_points2=x_points_angled+x_centre_points(2);
x_points3=x_points_vert+x_centre_points(3);
x_points4=x_points_angled+x_centre_points(4);
x_points5=x_points_angled+x_centre_points(5);
x_points6=x_points_vert+x_centre_points(6);
x_points7=x_points_angled+x_centre_points(7);
x_points8=x_points_vert+x_centre_points(8);

y_points1=y_points_vert+y_centre_points(1);
y_points2=y_points_angled+y_centre_points(2);
y_points3=y_points_vert+y_centre_points(3);
y_points4=y_points_angled+y_centre_points(4);
y_points5=y_points_angled+y_centre_points(5);
y_points6=y_points_vert+y_centre_points(6);
y_points7=y_points_angled+y_centre_points(7);
y_points8=y_points_vert+y_centre_points(8);

z_points1=z_points_vert;
z_points2=z_points_angled;
z_points3=z_points_vert;
z_points4=z_points_angled;
z_points5=z_points_angled;
z_points6=z_points_vert;
z_points7=z_points_angled;
z_points8=z_points_vert;

%Now bundle each into a matrix with coil vertices organised into columns.
x_matrix=[x_points1; x_points2; x_points3; x_points4; x_points5; x_points6; x_points7; x_points8];
y_matrix=[y_points1; y_points2; y_points3; y_points4; y_points5; y_points6; y_points7; y_points8];
z_matrix=[z_points1; z_points2; z_points3; z_points4; z_points5; z_points6; z_points7; z_points8];
end

