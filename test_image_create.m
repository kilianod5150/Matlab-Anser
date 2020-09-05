
z_offset=.1;
% x_new=[sys.xcoil sys.xcoil sys.xcoil(:,1)]; 
% y_new=[sys.ycoil sys.ycoil sys.ycoil(:,1)]; 
% z_new=[sys.zcoil sys.zcoil-z_offset sys.zcoil(:,1)]; 

x_new=[sys.xcoil sys.xcoil sys.xcoil(:,1) sys.xcoil(:,end) ]; 
y_new=[sys.ycoil sys.ycoil sys.ycoil(:,1) sys.ycoil(:,end)]; 
z_new=[sys.zcoil sys.zcoil-z_offset sys.zcoil(:,1)-z_offset sys.zcoil(:,end)-z_offset]; 

figure
plot3(x_new(1,:),y_new(1,:),z_new(1,:))