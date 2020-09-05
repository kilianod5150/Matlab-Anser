% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% fSetup.m
% Declares all the tracking system parameters
% INPUT:
%       DAQchannels - Array of channel pairs to initiate on the DAQ device
%                       1st pair is the probe sensor
%                       2nd pair is the reference sensor
%                       More sensors may be added
%       DAQType     - Choose to use the new (64bit) or 'legacy' interface
%
% OUTPUT:
%       sys         - A structure containing the system settings (dimensions,
%                    constants, frequencies etc
function sys = fSysSetup(sensorsToTrack, systemType, DAQType, DAQString, DAQSample, ModelType)

% Adds adjacent directories to the workspace
addpath(genpath(pwd))
fTitle();


if (nargin ~= 6)
    error('fSysSetup takes five arguements');
end



%% Define sensor parameters
% Scaling vector for algortihm convergence. This vector is used to scales
% the measured field strenths such that they lie within the same order of
% magnitude as the model.
fieldGain = ones(1,8) * 1e6;
% Magnetic permeability of free space
u0 = 4*pi*1e-7;



%% Define exact dimensions of each coil and test point on the emitter plate.
% All test points are with respect to the emitter coils and are used for
% calibration. Dimension of Coils are also retrieved
%[x,y,z,coil_length,track_width,track_spacing,pcb_thickness,coil_turns,centre_x,centre_y,centre_z] = fCoilCalSpec(systemType);
[x,y,z,coil_length_a,coil_length_b,track_width,track_spacing,pcb_thickness,coil_turns,layer_count,centre_x,centre_y,centre_z,coil_theta,coil_phi,coil_psi] = fCoilCalSpec(systemType);


%% Define Coil Parameters (meters)
% Define side length of outer square
% Define width of each track
% Define spacing between tracks
% Define thickness of the emitter coil PCB
% Define total number of turns per coil
l_a=coil_length_a;
l_b=coil_length_b;
w=track_width;
s=track_spacing;
thickness=pcb_thickness;
Nturns=coil_turns;

% Define the positions of each centre point of each coil

x_centre_points = centre_x;
y_centre_points = centre_y;
z_centre_points = centre_z;

% Calculate generic points for both the vertical and angled coil positions
for i=1:8;
    if length(l_a)==1 %check if all coils are unique or is each one potentially different
        [x_points_cell{i}, y_points_cell{i}, z_points_cell{i}] = fGenerateCoil(l_a, l_b, layer_count, w, s, thickness, coil_theta(i), coil_phi(i), coil_psi(i), Nturns, ModelType);
    else
        [x_points_cell{i}, y_points_cell{i}, z_points_cell{i}] = fGenerateCoil(l_a(i), l_b(i), layer_count(i), w(i), s(i), thickness(i), coil_theta(i), coil_phi(i), coil_psi(i), Nturns(i), ModelType);
    end
    % Add the center position offsets to each coil
    x_points{i}=x_points_cell{i}+x_centre_points(i);
    y_points{i}=y_points_cell{i}+y_centre_points(i);
    z_points{i}=z_points_cell{i}+z_centre_points(i);
    num_points(i)=length(x_points{i});
end

for i=1:8; %add padding if necessary of the last point in the coil
    if num_points(i)<max(num_points);
            x_points{i}=[x_points{i} x_points{i}(end)*ones(1,max(num_points)-num_points(i))];
            y_points{i}=[y_points{i} y_points{i}(end)*ones(1,max(num_points)-num_points(i))];
            z_points{i}=[z_points{i} z_points{i}(end)*ones(1,max(num_points)-num_points(i))];
    end
end

%Now bundle each into a matrix with coil vertices organised into columns.
x_matrix=[x_points{1}; x_points{2}; x_points{3}; x_points{4}; x_points{5}; x_points{6}; x_points{7}; x_points{8}];
y_matrix=[y_points{1}; y_points{2}; y_points{3}; y_points{4}; y_points{5}; y_points{6}; y_points{7}; y_points{8}];
z_matrix=[z_points{1}; z_points{2}; z_points{3}; z_points{4}; z_points{5}; z_points{6}; z_points{7}; z_points{8}];


%% FOR NEW TRANSMITTERS
% d = load('points.mat');
% x_matrix=d.x_points_out;
% y_matrix=d.y_points_out;
% z_matrix=d.z_points_out;


%% Demodulator Parameters
% Specify the sampling frequency per sensor channel
Fs = 50e3;
Ts=1/Fs;
numSamples = DAQSample;

% Specify the number of time samples, must be the same as the length of X
t=0:Ts:(numSamples - 1) * Ts;

% Define the transmission frequencies of the emitter coil
% These will be used for demodulation
F=[2200 2300 2400 2500 2600 2700 2800 2900];
%F=[1920 2060 2160 2330 2490 2550 3010 3370];

% Define the demodulation matrix for the asynchronous demodulation scheme
E=[exp(2*pi*F(1)*t*1i); exp(2*pi*F(2)*t*1i);  exp(2*pi*F(3)*t*1i); exp(2*pi*F(4)*t*1i); exp(2*pi*F(5)*t*1i); exp(2*pi*F(6)*t*1i); exp(2*pi*F(7)*t*1i) ;exp(2*pi*F(8)*t*1i)]; %exponential matrix thing that handles the demodulation
E=E';

% Low pass FIR filter
% N, Order %must be the same as the length of t -1
% Fc, Cutoff Frequency
% flag, Sampling Flag
% SidelobeAtten, window parameter  attentation of the stopband
N  = length(t)-1;
Fc = 0.00005;
flag = 'scale';
SidelobeAtten = 200;

% Create the window vector for the design algorithm.
win = chebwin(N+1, SidelobeAtten);

% Calculate the coefficients using the FIR1 function.
% Extract the filter parameters
bf  = fir1(N, Fc, 'low', win, flag);
Hd = dfilt.dffir(bf);
f=Hd.Numerator;

% Repeats the filter coefficients, must have the same number of rows as there are DAQ input signals.
G=repmat(f,2,1);



%% NI DAQ Parameters
% Initialise the DAQ unit and calculate the phase offsets between channels
% due to the internal DAQ multiplexer
fprintf('DAQ initialising\n');
DAQ = 0;
if ~contains(systemType,'SIM')
    DAQ = fDAQSetup(Fs,sensorsToTrack, DAQType, DAQString, length(t));
end
DAQ_phase_offset = (2*pi*F/400000);% DAQ_phase_offset + -5e-5*F + 1.4591; % Adds filter phase effect
fprintf('DAQ initialised\n');
fprintf('DAQ Type %s\n', DAQType);



%% Position algorithm parameters
% Define parameters for position sensing algorithm
options = optimset('TolFun',1e-16,'TolX',1e-6,'MaxFunEvals',500,'MaxIter',40,'Display','off'); % sets parameters for position algorithm
options = optimoptions(@lsqnonlin,'UseParallel',false,'TolFun',1e-16,'TolX',1e-6,'MaxFunEvals',500,'MaxIter',40,'Display','off');
% Sets the threshold for the algorithm residual, if the residual is greater than this, the algorithm has failed
resThreshold=1e-15;

% Initial estimate of sensors position which is assumed to be at the centre
% of thetransmitter at the z-axis height of 15cm
xInit = 0;
yInit = 0;
thetaInit = 0;
phiInit = 0;

zInit = 0.15;


% Define initial estimate of sensor position
condInit = [xInit  yInit zInit  thetaInit phiInit];






%% Store all system settings in a structure
% This internal variables functions later in the code. The structure is
% used in order to prevent the matlab workspace getting clogged up.

sys.u0 = u0;
sys.fieldGain = fieldGain;

sys.xtestpoint = x;
sys.ytestpoint = y;
sys.ztestpoint = z;

sys.xcoil = x_matrix;
sys.ycoil = y_matrix;
sys.zcoil = z_matrix;

sys.Fs = Fs;
sys.DAQType = DAQType;
sys.modelType = ModelType;
sys.NIDAQ = DAQ;
sys.DAQPhase = DAQ_phase_offset;
sys.rawData = zeros(numSamples,length(sensorsToTrack));
sys.Sensors = sensorsToTrack;
sys.MaxSensors = 16;

sys.t = t;
sys.F = F;
sys.E = E;
sys.G = G;

sys.lqOptions = options;
sys.residualThresh = resThreshold;

% Default selection
sys.SensorNo = 1;

% Preallocate memory for the sensor data
sys.zOffsetActive = 0;
sys.BStoreActive = zeros(8, 49);
sys.BScaleActive = [0,0,0,0,0,0,0,0];

% Load field map if needed
fprintf('Loading field map\n');
load('mapping/fieldmap.mat');
sys.HxMap=HxMap;
sys.HyMap=HyMap;
sys.HzMap=HzMap;
fprintf('Field map loaded\n');

fprintf('Initialising sensors\n');

% Sets the initial position condition for all sensors
sys.estimateInit = repmat(condInit, [sys.MaxSensors, 1]);

% Load previously saved calibration data to the sys structure and save
if (exist('data/sys.mat', 'file') == 2)
    fprintf('Previous calibration data found\nLoading data file...\n')
    sysPrev = load('sys.mat');
    sysPrev = sysPrev.sys;
    for i=1:sys.MaxSensors
        sys.zOffset(i) = sysPrev.zOffset(i);
        sys.BStore(:,:,i) = sysPrev.BStore(:,:,i);
        sys.BScale(i,:) = sysPrev.BScale(i,:);
    end
else
    fprintf('No previous calibration data found\nGenerating strutures...\n')
    for i=1:sys.MaxSensors
        sys.zOffset(i) = 0;
        sys.BStore(:,:,i) = zeros(8, 49);
        sys.BScale(i,:) = [0,0,0,0,0,0,0,0];
    end
end

fprintf('PASS: System initialised with sensors: %s \n', sprintf('%d ', sys.Sensors));

end