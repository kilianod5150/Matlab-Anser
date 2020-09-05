load ('grid_7x7_duplo_3_axis.mat');

close all

B_Mag=sqrt(BSave(:,1,:).^2+BSave(:,2,:).^2+BSave(:,3,:).^2);
B_Mag=reshape( B_Mag, [8 49]);

    % Spacing of test points on the Duplo board
    x=(-3:1:3)*(31.75e-3);
    x=[x x x x x x x];
    y=[ones(1,7)*95.25*1e-3 ones(1,7)*63.5*1e-3  ones(1,7)*31.75*1e-3 ones(1,7)*0  ones(1,7)*-31.75*1e-3 ones(1,7)*-63.5*1e-3 ones(1,7)*-95.25*1e-3 ];
    z=0*x;
    


figure
    
scatter3(x,y,z)
for i=1:8;
figure
scatter3(x,y,B_Mag(i,:))
end
