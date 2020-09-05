% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

% Run the system for a single sensor.
% Use this script as a reference program for writing EMT applications 
% with OpenIGTLink support.

global Fs;
SYSTEM = '7x7';
DAQ = 'nidaq621Xoem';
BOARDID = 'Dev1';
SAMPLESIZE = 5000;
MODELTYPE = 'exact';

Fs=100e3;
% Enable OpenIGTLink
IGTENABLE = 1;

% Settings for the tracking system
% List of sensors to initialise.
sensorsToTrack = [5];

% Aquisition refresh rate in Hertz
refreshRate = 1000;

% Enable flag for OpenIGTLink connection
transformName = 'ProbeToTracker';


% Initialise the tracking system with two sensor channels [1,2] using the
% National Instruments NI USB 6212DAQ
sys = fSysSetup(sensorsToTrack, SYSTEM, DAQ, BOARDID, SAMPLESIZE, MODELTYPE);
pause(0.5);


%% Enable OpenIGTLink connection
if(IGTENABLE == 1)
    slicerConnection = igtlConnect('127.0.0.1', 18944);
    transform.name = transformName;
end


%% Main loop.
% This loop is cancelled cleanly using the 3rd party stoploop function.
FS = stoploop();
while (~FS.Stop())

    % Update the tracking system with new sample data from the DAQ.
   % Calculate the position of a specific sensor in sensorsToTrack.
   % Change the initial condition of the solver to the resolved position
   % (this will reduce solving time on each iteration)
   % Print the position vector on the command line. The format of the
   % vector is [x,y,z,theta,phi]
   sys = fSysDAQUpdate(sys);
   sys = fGetSensorPosition(sys, sensorsToTrack(1));
   disp(sys.positionVector);
   
   % Prepare to transmit sensor position over network.
   if(IGTENABLE == 1)
     
      % Rigid registration matrix.  
      sys.registration = eye(4,4);    
   
      % Convert meters to millimeters. Required for many IGT packages
      sys.positionVector(1:3) = sys.positionVector(1:3) * 1000;
      % Convert from Spherical to Homogenous transformation matrix.
      sys.positionVectorMatrix = fSphericalToMatrix(sys.positionVector); 
      % Applies registration for the IGT coordinate system.      
      transform.matrix = sys.registration * sys.positionVectorMatrix;
      % Generate a timestamp for the data and sent the transform through
      % the OpenIGTLink connection.
      transform.timestamp = igtlTimestampNow();
      igtlSendTransform(slicerConnection, transform);

   end
   
   % This pause is required to allow the DAQ background DMA to work.
   % Otherwise transfer might freeze and data does not update
   pause(1/refreshRate);
   
end


%% Save and cleanup
FS.Clear(); 
clear FS;
% Cleanly disconnect from the OpenIGTLink server
if(IGTENABLE == 1)
    igtlDisconnect(slicerConnection);
end