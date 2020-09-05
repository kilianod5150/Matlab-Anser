
close all
clc
clear Hx Hy Hz x y z xx yy zz xxx yyy zzz HxMap HyMap HzMap Hx_check Hy_check Hz_check

%load('grid_5x5x5_duplo_3_axis_new_order.mat');
%load('grid_5x5x5_duplo_3_axis_new_order_redux.mat');
%load('grid_5x5x5_duplo_3_axis_new_order_redux_shield.mat');
load('grid_5x5x5_duplo_3_axis_new_order_redux_shield_steel.mat');

u0=4*pi*1e-7;
z_start=.10;
z_end=0.292;
x_start=-2.5*(31.75e-3);
x_end=2.5*(31.75e-3);
y_start=-2.5*(31.75e-3);
y_end=2.5*(31.75e-3);

numpoints=5;

z=linspace(z_start,z_end,numpoints)+.0026;
x=linspace(x_start,x_end,numpoints)+.001;
y=linspace(y_start,y_end,numpoints)+.0106;

% x=fliplr(linspace(x_start,x_end,numpoints));
%y=fliplr(y);

%[xx,yy,zz]=meshgrid(x,y,z);
[xx,yy,zz]=ndgrid(x,y,z);



xxx=reshape(xx,[1 numpoints^3]);
yyy=reshape(yy,[1 numpoints^3]);
zzz=reshape(zz,[1 numpoints^3]);

figure
hold on
for i=1:8;
    plot3(sys.xcoil(i,:),sys.ycoil(i,:),sys.zcoil(i,:));
end
scatter3(xxx,yyy,zzz)
hold on
plot3(xxx,yyy,zzz,'r')
scatter3(xxx(1),yyy(1),zzz(1),'filled')
xlabel('x');
ylabel('y');
zlabel('z');

for i=1:numpoints^3
    %[Hx(:,i),Hy(:,i),Hz(:,i)]= spiralCoilFieldCalcMatrix(1,sys.xcoil,sys.ycoil,sys.zcoil,xxx(i),yyy(i),zzz(i));
    Hx(:,i)=BSave(:,1,i)/u0;
    Hy(:,i)=BSave(:,2,i)/u0;
    Hz(:,i)=BSave(:,3,i)/u0;
end

%Method='linear';
%Method='cubic';
Method='spline';
%method='nearest';
%method='natural';

%ExtrapolationMethod='nearest';
%ExtrapolationMethod='linear';
ExtrapolationMethod='cubic';

%P = [2 1 3];
%X = permute(xx, P);
%Y = permute(yy, P);
%Z = permute(zz, P);
%V = permute(reshape(Hx(1,:),[numpoints numpoints numpoints]), P);
%test=griddedInterpolant(X,Y,Z,V,Method,ExtrapolationMethod);

for i=1:8;
   %HxMap{i}=scatteredInterpolant(xxx',yyy',zzz',Hx(i,:)',Method,ExtrapolationMethod);
   %HyMap{i}=scatteredInterpolant(xxx',yyy',zzz',Hy(i,:)',Method,ExtrapolationMethod);
   %HzMap{i}=scatteredInterpolant(xxx',yyy',zzz',Hz(i,:)',Method,ExtrapolationMethod);
  % HxMap{i}=griddedInterpolant(X,Y,Z,permute(reshape(Hx(i,:),[numpoints numpoints numpoints]),P),Method,ExtrapolationMethod);
  % HyMap{i}=griddedInterpolant(X,Y,Z,permute(reshape(Hy(i,:),[numpoints numpoints numpoints]),P),Method,ExtrapolationMethod);
  %HzMap{i}=griddedInterpolant(X,Y,Z,permute(reshape(Hz(i,:),[numpoints numpoints numpoints]),P),Method,ExtrapolationMethod);
   HxMap{i}=griddedInterpolant(xx,yy,zz,reshape(Hx(i,:),[numpoints numpoints numpoints]),Method,ExtrapolationMethod);
   HyMap{i}=griddedInterpolant(xx,yy,zz,reshape(Hy(i,:),[numpoints numpoints numpoints]),Method,ExtrapolationMethod);
   HzMap{i}=griddedInterpolant(xx,yy,zz,reshape(Hz(i,:),[numpoints numpoints numpoints]),Method,ExtrapolationMethod);
end

save('mapping/fieldmap.mat','HxMap','HyMap','HzMap')

% Px=0;
% Py=0;
% Pz=.15;
% 
% tic
% Hx_vq=HxMap{1}(Px,Py,Pz);
% Hy_vq=HyMap{1}(Px,Py,Pz);
% Hz_vq=HzMap{1}(Px,Py,Pz);
% 
% toc

for i=1:length(Hx)
[Hx_check(:,i), Hy_check(:,i),Hz_check(:,i)]= spiralCoilFieldCalcMatrix( 1,sys.xcoil,sys.ycoil,sys.zcoil, xxx(i),yyy(i),zzz(i) );
end
% [Hx_vq Hy_vq Hz_vq]
% [Hx_check Hy_check Hz_check]
%range=1:25;
%range=26:50;
%range=51:75;
%range=76:100;
range=101:125;

coil=3;
figure
subplot(3,1,1)
scatter3(xxx(range),yyy(range),Hx_check(coil,range))
hold on
scatter3(xxx(range),yyy(range),Hx(coil,range),'r')
subplot(3,1,2)
scatter3(xxx(range),yyy(range),Hy_check(coil,range))
hold on
scatter3(xxx(range),yyy(range),Hy(coil,range),'r')
subplot(3,1,3)
scatter3(xxx(range),yyy(range),Hz_check(coil,range))
hold on
scatter3(xxx(range),yyy(range),Hz(coil,range),'r')



Hx_error=mean(Hx_check./Hx,2)
Hy_error=mean(Hy_check./Hy,2)
Hz_error=mean(Hz_check./Hz,2)

figure
subplot(3,1,1)
scatter3(xxx(range),yyy(range),Hx_check(coil,range))
hold on
scatter3(xxx(range),yyy(range),Hx(coil,range)*Hx_error(coil),'r')
subplot(3,1,2)
scatter3(xxx(range),yyy(range),Hy_check(coil,range))
hold on
scatter3(xxx(range),yyy(range),Hy(coil,range)*Hy_error(coil),'r')
subplot(3,1,3)
scatter3(xxx(range),yyy(range),Hz_check(coil,range))
hold on
scatter3(xxx(range),yyy(range),Hz(coil,range)*Hz_error(coil),'r')