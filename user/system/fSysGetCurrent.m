% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function sys = fSysGetCurrent(sys)
% fSysGetField.m
% Demodulates acquired samples to produce a set of current strengths

% sys = The system object

% sys = The system object with updated magnetic current values.

% Number of emitter coils in system.
numCoils = 8;

% The reference coil current sample data
X(:,1) = sys.rawData(:,1);

% Transpose X for multiplication
X = X';
% Demodulate each frequency component using this matrix fir method.
Y=(X.*sys.G)*sys.E;
% Calculate the amplitude of each component, both current and magnetic field measurements are in here
MagY=2*abs(Y);






% Taking the sign of the phase difference and the magnetic field amplitude and a scaling factor, the magnetic field is determined 
CoilCurrent = MagY(1,:)';

% Store the magnetic strengths in the system object.
sys.CoilCurrent = CoilCurrent;
end