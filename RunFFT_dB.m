% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% Run a real-time fast-fourier tranform a single sensor.
% Use this script as a starting point for visually inspecting the field
% strengths of the tracking system.
close all
clear

global Fs

SYSTEM = '7x7';
DAQ = 'nidaq621Xoem';
BOARDID = 'Dev1';
SAMPLESIZE = 50000;
MODELTYPE = 'exact';

% Channel the DAQ to inspect. This does NOT directly corresponding to the sensor
% channelLook at the DAQ pin mapping
sensorsToTrack = [1];

% Refresh rate of the position acquisition (Hz)
refreshRate = 20;
%Fs=400000/(length(sensorsToTrack)+1);
Fs=100000;
sys = fSysSetup(sensorsToTrack,SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);

% Get access to the global data structure used by the DAQ
global sessionData;

sessionData=zeros(SAMPLESIZE,(length(sensorsToTrack)+1));
f_bin=Fs/SAMPLESIZE;
figure;
smoothing=1;
FS=stoploop();
pause(1);
while (~FS.Stop())
    
    % Perform an FFT of the analog-in channels. The index is incremented by
    % +1 in order to select the appropriate column in the structure. The
    % 1st column is the current reference signal for the transmitter coils.
    % This reference current signal can be viewed in the FFT by selecting
    % the first column of sessionData (i.e. '1')
    ft = fft(sessionData(:, 2));
    %plot((1:(length(ft)/2))./(length(ft)/2)*Fs*.5, 20*log10(abs(ft(1:(length(ft)/2)))/length(ft)));
    %loglog((1:(length(ft)/2))./(length(ft)/2)*Fs*.5, smooth((abs(ft(1:(length(ft)/2)))/length(ft)./sqrt(f_bin)),smoothing)); %noise density
    %semilogy((1:(length(ft)/2))./(length(ft)/2)*Fs*.5, smooth((abs(ft(1:(length(ft)/2)))/length(ft)),smoothing)); %noise density
    plot((1:(length(ft)/2))./(length(ft)/2)*Fs*.5, smooth(20*log10(abs(ft(1:(length(ft)/2)))/length(ft)),smoothing)); %noise density

    hold on
    %ft2 = fft(sessionData(:, 3));
    ft3 = fft(sessionData(:, 1));
    %loglog((1:(length(ft2)/2))./(length(ft2)/2)*Fs*.5, smooth((abs(ft2(1:(length(ft2)/2)))/length(ft2)./sqrt(f_bin)),smoothing),'r'); %noise density
    %semilogy((1:(length(ft2)/2))./(length(ft2)/2)*Fs*.5, smooth((abs(ft2(1:(length(ft2)/2)))/length(ft2)),smoothing),'r'); %noise density
    %semilogy((1:(length(ft3)/2))./(length(ft3)/2)*Fs*.5, smooth((abs(ft3(1:(length(ft3)/2)))/length(ft3)),smoothing),'g'); %noise density
    %plot((1:(length(ft)/2))./(length(ft)/2)*Fs*.5, smooth(20*log10(abs(ft2(1:(length(ft)/2)))/length(ft)),smoothing),'r'); %noise density
    %plot((1:(length(ft)/2))./(length(ft)/2)*Fs*.5, smooth(20*log10(abs(ft3(1:(length(ft)/2)))/length(ft)),smoothing),'g'); %noise density

    
    %loglog((1:(length(ft3)/2))./(length(ft3)/2)*Fs*.5, smooth((abs(ft3(1:(length(ft3)/2)))/length(ft3)./sqrt(f_bin)),smoothing),'g'); %noise density

    hold off
    %periodogram(sessionData(:, 2))
    % Scale the axes of the plots to the desired range.
    ylim([-120,-0]) 
    %ylim([1e-9,1e1]) 
    xlim([10,Fs/2])
    ylabel('V/sqrt(Hz)')
    pause(1/refreshRate);
    %clf
end
stop(sys.NIDAQ);