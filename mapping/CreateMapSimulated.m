
close all
clc
clear Hx Hy Hz x y z xx yy zz xxx yyy zzz HxMap HyMap HzMap
% z_start=.15;
% z_end=0.35;
% x_start=-.10;
% x_end=0.10;
% y_start=-.10;
% y_end=0.10;

z_start=.10;
z_end=0.292;
x_start=-2.5*(31.75e-3);
x_end=2.5*(31.75e-3);
y_start=-2.5*(31.75e-3);
y_end=2.5*(31.75e-3);

numpoints=5;

z=linspace(z_start,z_end,numpoints);
x=linspace(x_start,x_end,numpoints);
y=linspace(y_start,y_end,numpoints);

[xx,yy,zz]=meshgrid(x,y,z);

xxx=reshape(xx,[1 numpoints^3]);
yyy=reshape(yy,[1 numpoints^3]);
zzz=reshape(zz,[1 numpoints^3]);

figure
hold on
for i=1:8;
    plot3(sys.xcoil(i,:),sys.ycoil(i,:),sys.zcoil(i,:));
end
scatter3(xxx,yyy,zzz)


for i=1:numpoints^3
    [Hx(:,i),Hy(:,i),Hz(:,i)]= spiralCoilFieldCalcMatrix(1,sys.xcoil,sys.ycoil,sys.zcoil,xxx(i),yyy(i),zzz(i));
end

%Method='linear';
%Method='cubic';
Method='spline';
%method='nearest';
%method='natural';

%ExtrapolationMethod='nearest';
%ExtrapolationMethod='linear';
ExtrapolationMethod='cubic';

P = [2 1 3];
X = permute(xx, P);
Y = permute(yy, P);
Z = permute(zz, P);
%V = permute(reshape(Hx(1,:),[numpoints numpoints numpoints]), P);
%test=griddedInterpolant(X,Y,Z,V,Method,ExtrapolationMethod);

for i=1:8;
   %HxMap{i}=scatteredInterpolant(xxx',yyy',zzz',Hx(i,:)',Method,ExtrapolationMethod);
   %HyMap{i}=scatteredInterpolant(xxx',yyy',zzz',Hy(i,:)',Method,ExtrapolationMethod);
   %HzMap{i}=scatteredInterpolant(xxx',yyy',zzz',Hz(i,:)',Method,ExtrapolationMethod);
   HxMap{i}=griddedInterpolant(X,Y,Z,permute(reshape(Hx(i,:),[numpoints numpoints numpoints]),P),Method,ExtrapolationMethod);
   HyMap{i}=griddedInterpolant(X,Y,Z,permute(reshape(Hy(i,:),[numpoints numpoints numpoints]),P),Method,ExtrapolationMethod);
   HzMap{i}=griddedInterpolant(X,Y,Z,permute(reshape(Hz(i,:),[numpoints numpoints numpoints]),P),Method,ExtrapolationMethod);
end

save('mapping/fieldmap.mat','HxMap','HyMap','HzMap')

Px=0;
Py=0;
Pz=.15;

tic
Hx_vq=HxMap{1}(Px,Py,Pz);
Hy_vq=HyMap{1}(Px,Py,Pz);
Hz_vq=HzMap{1}(Px,Py,Pz);

toc

[Hx_check, Hy_check,Hz_check]= spiralCoilFieldCalcMatrix(1,sys.xcoil(1,:),sys.ycoil(1,:),sys.zcoil(1,:),Px,Py,Pz);

[Hx_vq Hy_vq Hz_vq]
[Hx_check Hy_check Hz_check]
