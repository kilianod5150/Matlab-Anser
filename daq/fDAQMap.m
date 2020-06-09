% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function channelMap = fDAQMap(DAQType)
% FDAQMAP Maps the sensor indices to physical DAQ channels. The pinout of
% DAQ cards differ depending on the manfacturer. Pinout details are readily
% found in the device datasheets and user manuals. Pinouts for the
% National Instruments NI6212/6216 incl. OEM have been already included.


% Use a map structure to link channel indices to physical DAQ channels.
map = containers.Map('KeyType','double','ValueType','double');

if strcmp(DAQType, 'nidaq621X') == 1
    map(0) = 0;
    map(1) = 1;
    map(2) = 4;
    % Add additional sensor
elseif strcmp(DAQType, 'nidaq621Xoem') == 1
    % NI-6212 OEM DAQ channels for Anser sytem
    map(0) = 4; % This is the current sense channel
    map(1) = 0;
    map(2) = 8;
    map(3) = 1;
    map(4) = 9;
    map(5) = 2;
    map(6) = 10;
    map(7) = 11; 
    map(8) = 3;
    %map(9) = 8;
    map(10) = 12;
    map(11) = 13;
    map(12) = 5;
    map(13) = 14;
    map(14) = 6;
    map(15) = 15;
    map(16) = 7;
elseif strcmp(DAQType, 'mccdaq') == 1
    % MCCDAQ channels mappings go here
    map(0) = 4; % This is the current sense channel
    map(1) = 11;
    map(2) = 3;
    map(3) = 10;
    map(4) = 2;
    map(5) = 9;
    map(6) = 1;
    map(7) = 0;
    map(8) = 8; 
    % Channel 9 not exist
    map(10) = 12;
    map(11) = 13;
    map(12) = 5;
    map(13) = 6;
    map(14) = 14;
    map(15) = 15;
    map(16) = 8;
else
    error('DAQType not supported');

end

% Return a channel mapping object. When accessed using a channel index, the
% map will return the corresponding hardware analog input channel ID
channelMap = map;
end

