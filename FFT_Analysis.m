function [frequency, magnitude] = FFT_Analysis(input,Fs,plot_y_or_n,plot_string)
%FFT_ANALYSIS Summary of this function goes here
%   Detailed explanation goes here


T = 1/Fs;             % Sampling period
L = length(input);             % Length of signal

Y = fft(input);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

frequency = (Fs*(0:(L/2))/L)';
magnitude=P1;

if strcmp(plot_y_or_n,'y')
    figure
    %loglog(frequency,P1)
    semilogy(frequency,P1)
    title(plot_string)
    xlabel('f (Hz)')
    ylabel('Signal Voltage (volts)')
    
end




end

