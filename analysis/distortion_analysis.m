% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.
clc
clear
close all

SYSTEM = '7x7';
DAQ = 'nidaq621Xoem';
BOARDID = 'Dev1';
SAMPLESIZE = 5000;

MODELTYPE = 'exact';

% Select which sensor channel you will use for calibration.
% Each sensor must be calibrated seperatly due to gain variations
% in the system amplifier electronics.
% Sensor indices begin at '1'
Fs=100e3;

sensorToCheck = [1];
addpath(genpath(pwd))
fTitle();

% Select the desired sensor channel. This will also ensure the appropriate calibration
% parameters are saved after calibration.
%sys_clean = fSysSetup(sensorToCheck,SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);
load('sys.mat');
sys_clean=sys;
%sys_clean = fSysSensor(sys, sensorToCheck);
sys_distorted=sys_clean;

% Acquire the testpoints necessary for testing. 
%sys = fGetCalField(sys);
load('BStore1_clean.mat');
sys_clean.BStoreActive = BStore;

%load('BStore1_sheet_to_left.mat');
%load('BStore1_steel_bar_to_left.mat');
load('BStore1_sheet_below.mat');
%load('BStore1_sheet_below_directly.mat')
sys_distorted.BStoreActive = BStore;

% Check the calibration error (Result in millimeters)
%rmsErrorBz = fCheck(sys);
[rmsErrorBz_clean,~,~,~,rError_clean,~,solution_clean,resnorm_clean,residual_clean,firstorderopt_clean,iterations_clean,CI_R_m_clean] = fCheck_more_detailed(sys_clean);
[rmsErrorBz_distorted,~,~,~,rError_distorted,~,solution_distorted,resnorm_distorted,residual_distorted,firstorderopt_distorted,iterations_distorted,CI_R_m_distorted] = fCheck_more_detailed(sys_distorted);
large_error_index=rError_distorted>.003;

residual_percentage_clean=100*residual_clean./sys_clean.BStoreActive';
residual_percentage_clean_mean=mean(abs(residual_percentage_clean),2);

residual_percentage_distorted=100*residual_distorted./sys_distorted.BStoreActive';
residual_percentage_distorted_mean=mean(abs(residual_percentage_distorted),2);




% figure
% scatter3(sys_clean.xtestpoint',sys_clean.ytestpoint',resnorm_clean);
% hold on
% scatter3(sys_clean.xtestpoint',sys_clean.ytestpoint',resnorm_distorted,'r');
% scatter3(sys_clean.xtestpoint(large_error_index)',sys_clean.ytestpoint(large_error_index)',resnorm_distorted(large_error_index),'r','filled');
% 
% set(gca,'zscale','log')


figure
scatter3(firstorderopt_clean,residual_percentage_clean_mean,rError_clean)
hold on
scatter3(firstorderopt_distorted,residual_percentage_distorted_mean,rError_distorted,'r')
scatter3(firstorderopt_distorted(large_error_index),residual_percentage_distorted_mean(large_error_index),rError_distorted(large_error_index),'r','filled')

set(gca,'xscale','log')
set(gca,'yscale','log')

zlabel('error [m]')
xlabel('First order optimality');
ylabel('Percentage resnorm error')





%[rmsErrorBz_cleanWithGain] = fCheck_more_detailedWithGain(sys_clean);
%[rmsErrorBz_distortedWithGain] = fCheck_more_detailedWithGain(sys_distorted);

% figure
% scatter3(sys_clean.xtestpoint',sys_clean.ytestpoint',resnorm_clean);
% hold on
% scatter3(sys_clean.xtestpoint',sys_clean.ytestpoint',resnorm_distorted,'r');
% set(gca,'zscale','log')
% figure
% scatter3(sys_clean.xtestpoint',sys_clean.ytestpoint',rError_clean);
% hold on
% scatter3(sys_clean.xtestpoint',sys_clean.ytestpoint',rError_distorted,'r');
% 
figure
scatter3(sys_clean.xtestpoint',sys_clean.ytestpoint',resnorm_clean,50,resnorm_clean,'filled');
xlabel('x');
ylabel('y');
zlabel('Resnorm');
cb = colorbar();
hold on
for i=1:8;
plot3(sys_clean.xcoil(i,:),sys_clean.ycoil(i,:),0*sys_clean.xcoil(i,:));
end


figure
scatter3(sys_clean.xtestpoint',sys_clean.ytestpoint',CI_R_m_clean,50,CI_R_m_clean,'filled');
hold on
xlabel('x');
ylabel('y');
zlabel('CI');
cb = colorbar();
for i=1:8;
plot3(sys_clean.xcoil(i,:),sys_clean.ycoil(i,:),0*sys_clean.xcoil(i,:));
end

% 
% 
% figure
% scatter3(sys_clean.xtestpoint',sys_clean.ytestpoint',resnorm_clean./resnorm_distorted);
% 
% figure
% scatter(rError_clean,resnorm_clean)
% hold on
% scatter(rError_distorted,resnorm_distorted,'r')
% 
% set(gca,'yscale','log')
% 
% figure
% scatter(rError_clean,mean(abs(residual_clean./(sys_clean.BStoreActive)'),2))
% hold on
% scatter(rError_distorted,mean(abs(residual_distorted./(sys_distorted.BStoreActive)'),2),'r')
% 
% set(gca,'yscale','log')
% 
% figure
% scatter(rError_clean,(abs(resnorm_clean'./mean(abs(sys_clean.BStoreActive)',2))))
% hold on
% scatter(rError_distorted,(abs(resnorm_distorted'./mean(abs(sys_distorted.BStoreActive)',2))),'r')
% 
% set(gca,'yscale','log')
% 
% figure
% scatter3(firstorderopt_clean,(abs(resnorm_clean'./mean(abs(sys_clean.BStoreActive)',2))),rError_clean)
% hold on
% scatter3(firstorderopt_distorted,(abs(resnorm_distorted'./mean(abs(sys_distorted.BStoreActive)',2))),rError_distorted,'r')
% 
% set(gca,'xscale','log')
% set(gca,'yscale','log')
% 
% zlabel('error [m]')
% xlabel('First order optimality');
% ylabel('Normalised resnorm error')
% 
% % figure
% % scatter(rError_clean,min(abs(residual_clean')))
% % hold on
% % scatter(rError_distorted,min(abs(residual_distorted')),'r')
% 
% figure
% scatter3(min(abs(residual_clean')),(abs(resnorm_clean'./mean(abs(sys_clean.BStoreActive)',2))),rError_clean)
% hold on
% scatter3(min(abs(residual_distorted')),(abs(resnorm_distorted'./mean(abs(sys_distorted.BStoreActive)',2))),rError_distorted,'r')
% %scatter3(min(abs(residual_distorted')),(abs(resnorm_distorted'./mean(abs(sys_distorted.BStoreActive)',2))),rError_distorted,'r')
% 
% set(gca,'xscale','log')
% set(gca,'yscale','log')
% 
% zlabel('error [m]')
% xlabel('minimum residual diff');
% ylabel('Normalised resnorm error')
% 
% figure
% scatter3(CI_R_m_clean,(abs(resnorm_clean'./mean(abs(sys_clean.BStoreActive)',2))),rError_clean)
% hold on
% scatter3(CI_R_m_distorted,(abs(resnorm_distorted'./mean(abs(sys_distorted.BStoreActive)',2))),rError_distorted,'r')
% %scatter3(min(abs(residual_distorted')),(abs(resnorm_distorted'./mean(abs(sys_distorted.BStoreActive)',2))),rError_distorted,'r')
% 
% %set(gca,'xscale','log')
% set(gca,'yscale','log')
% zlabel('error [m]')
% xlabel('CI');
% ylabel('Normalised resnorm error')

% figure
% scatter(resnorm_clean,CI_R_m_clean);
% hold on
% scatter(resnorm_distorted,CI_R_m_distorted,'r');
% 
%  set(gca,'xscale','log')
% set(gca,'yscale','log')
