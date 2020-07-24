function sys = fCalibrateTransmitCoilFinderPositionErrorOnly(sys)
% fCalibrate.m
% Performes a system calibration based on a set of predefined test points. A vector of scaling factors (One for each emitter coil) is generated.

% sys = The system object

% sys = The system object with updated internal calibration scaling factors

% The number of emitter coils in the system
numCoils = 8;
% Angle of orientation of the sensor during calibration. In spherical
% coordinates this corresponds to pi radians, since the sensor is facing
% down towards the tracking board. 
sensorZorientation = pi;

% Load the magnetic field strengths sensed by the tracking coil at each testpoint.
loader = load(strcat('data/BStore', num2str(sys.SensorNo)));
sys.BStoreActive = loader.BStore;


[~,~,~,~,~,~,~,~,x_offset,y_offset] = fCoilCalSpec(sys.SYSTEM);

% Define least squares algorithm parameters for the LMA solver
options = optimset('TolFun',1e-3,'TolX',1e-6,'MaxFunEvals',20000,'MaxIter',40,'Display','iter','UseParallel',true); 

% Initialise a vector to store the z-offset values calculated by the solver for each emitter coil. 
%zOffsetAllCoils = [0,0,0,0,0,0,0,0];
coil_flat_angle=[pi/2 pi/4 pi/2 pi/4 pi/4 pi/2 pi/4 pi/2];

lowerLimit=repmat([-.25 -.25 -.25 -5*pi -5*pi -5*pi -100 ],8,1);
upperLimit=repmat([.25 .25 .25 5*pi 5*pi 5*pi 100 ],8,1); 
% Iterate the solver over each emitter coil to generate a z-offset and magnetic field scaling value for that coil.
%figure
%hold on
%axis equal
%for coilNo = 1:numCoils

    % Define initial estimate of parameters for the solver
    %lowerLimit(4)=coil_flat_angle(coilNo);
    %upperLimit(4)=coil_flat_angle(coilNo);
    %lowerLimit(5)=0;
    %upperLimit(5)=0;
    %lowerLimit(6)=0;
    %upperLimit(6)=0;

    paraEst=[x_offset' y_offset' zeros(8,1) coil_flat_angle' zeros(8,1) zeros(8,1) ones(8,1)];

	% Extract the field strengths at each testpoints due to coil 'coilNo'
	%calFieldCoil=sys.BStoreActive(coilNo, :);

	% Create new function handle for the emitter coil 'coilNo'.
	% 'params' is specified as the variable parameter vector for the function. i.e. the algorithm will vary this vector for the minimisation process.
	% calFieldCoil is a vector of the field strengths due to coil 'coilNo' sensed at each of the testpoints
    f = @(params)objectiveTransmitCoilFinderPositionErrorOnly(params,  sys);
    
    % Initialise the solver.
	%[fittedParams, resnorm] = lsqnonlin(f, paraEst,lowerLimit,upperLimit,options)
     %[fittedParams, resnorm] = fminunc(f, paraEst,options);
     [fittedParams, resnorm] = fmincon(f, paraEst,[],[],[],[],lowerLimit,upperLimit,[],options);
     
     
     sys.fittedParams=fittedParams;
    %[fittedParams, resnorm] = lsqnonlin(f, paraEst,lowerLimit,upperLimit,options)
    %fittedParamsStore(coilNo,:)=fittedParams;
	% The first entry of 'fittedParams' is the calculated z-offset
	%zOffsetAllCoils(coilNo) = fittedParams(3); %store results
    
    % The second entry of 'fittedParams' is magnetic field scaling factor
    %sys.BScaleActive(coilNo) = fittedParams(7);
    
    
%     [~,~,~,coil_length,track_width,track_spacing,pcb_thickness,coil_turns,~,~] = fCoilCalSpec(sys.SYSTEM);
%     [x_points,y_points,z_points] = fGenerateCoil(coil_length, track_width, track_spacing, pcb_thickness, pi/2, coil_turns, sys.modelType);
%     
%     P_out = fCoilRotateAndTranslate([x_points; y_points; z_points], [0 0 0], fittedParams(4:6), fittedParams(1:3));
%     x_points=P_out(1,:);
%     y_points=P_out(2,:);
%     z_points=P_out(3,:);
%     
%     x_points_store(coilNo,:)=x_points';
%     y_points_store(coilNo,:)=y_points';
%     z_points_store(coilNo,:)=z_points';
    
    %plot3(x_points,y_points,z_points);
%end
%plot3(x_points_store,y_points_store,z_points_store);
%plot3(sys.xcoil',sys.ycoil',sys.zcoil');
% fittedParamsStore
% fittedParamsStore(:,1)-  x_offset';
% fittedParamsStore(:,2)-  y_offset';

%x_error=mean(fittedParamsStore(:,1)-  x_offset')
%y_error=mean(fittedParamsStore(:,2)-  y_offset')

% Gets the mean z-offset from the coils.
%sys.zOffsetActive = mean(zOffsetAllCoils);

% Save calibration values to file CalibrationX.mat where X is the selected sensor.
%zOffset = sys.zOffsetActive

%sys.BScaleActive = sys.BScaleActive * sign(cos(sensorZorientation));
%BScale = sys.BScaleActive
%save(strcat('data/Calibration', num2str(sys.SensorNo)), 'zOffset', 'BScale');

%sys.xcoil=x_points_store;
%sys.ycoil=y_points_store;
%sys.zcoil=z_points_store;


% Save the system object.
%sys = fSysSave(sys);

end