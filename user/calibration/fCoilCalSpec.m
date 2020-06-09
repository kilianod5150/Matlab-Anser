function [x,y,z,l,w,s,th,N,centre_x,centre_y] = fCoilCalSpec(systemtype)
% FCOILCALSPEC
% Generates and provides the vertices of the TX coils, centroids and PCB
% dependant parameters.
 if (strcmpi(systemtype, 'DUPLO') == true)
    
    l = 70e-3;
    w = 0.5e-3;
    s = 0.25e-3;
    th = 1.6e-3;
    N = 25;
    
    % Specify no. of blocks used for the system calibration NOT including the sensor block
    % as this determines the z values of each testpoint. 
    calBlockNum = 5;
    % Sensor positioned halfway up one block
    calSensorPosition = 0.5;


    % Total height in terms of blocks. Dimensions in millimeters.
    calTowerBlocks  = calBlockNum + calSensorPosition;
    BlockHeight = 19.2;
     
    % Spacing of test points on the Duplo board
    x=(-3:1:3)*(31.75e-3); 
    x=[x x x x x x x];
    y=[ones(1,7)*95.25*1e-3 ones(1,7)*63.5*1e-3  ones(1,7)*31.75*1e-3 ones(1,7)*0  ones(1,7)*-31.75*1e-3 ones(1,7)*-63.5*1e-3 ones(1,7)*-95.25*1e-3 ];

    boardDepth = 15; % Millimeters
    z = (1e-3*(boardDepth + calTowerBlocks*BlockHeight)) * ones(1,49);
    
    centre_x = [-93.543 0 93.543 -68.55 68.55 -93.543 0 93.543]*1e-3;
    centre_y = [93.543 68.55 93.543 0 0 -93.543 -68.55 -93.543]*1e-3;
    
 elseif (strcmpi(systemtype, '9x9') == true)
    % Spacing of test points on the Anser board
    l = 70e-3;
    w = 0.5e-3;
    s = 0.25e-3;
    th = 1.6e-3;
    N = 25;
    
    spacing = (100/3) * 1e-3;
    probeHeight = 80e-3;
    x=(-4:1:4)*(spacing); 
    x=[x x x x x x x x x];
    y=[ones(1,9)*spacing*4 ones(1,9)*spacing*3  ones(1,9)*spacing*2 ones(1,9)*spacing*1 ones(1,9)*0 -ones(1,9)*spacing*1 -ones(1,9)*spacing*2 -ones(1,9)*spacing*3 -ones(1,9)*spacing*4];

    boardDepth = 4e-3; % Millimeters
    z = ((boardDepth + probeHeight)) * ones(1,81);
    
    centre_x = [-93.543 0 93.543 -68.55 68.55 -93.543 0 93.543]*1e-3;
    centre_y = [93.543 68.55 93.543 0 0 -93.543 -68.55 -93.543]*1e-3;
 
 elseif (strcmpi(systemtype, '7x7') == true)
    % Spacing of test points on the Anser board
    l = 70e-3;
    w = 0.5e-3;
    s = 0.25e-3;
    th = 1.6e-3;
    N = 25;
    
    spacing = (42.86) * 1e-3;
    probeHeight = 80e-3;
    x=(-3:1:3)*(spacing); 
    x=[x x x x x x x];
    y=[ones(1,7)*spacing*3  ones(1,7)*spacing*2 ones(1,7)*spacing*1 ones(1,7)*0 -ones(1,7)*spacing*1 -ones(1,7)*spacing*2 -ones(1,7)*spacing*3];

    boardDepth = 4e-3; % Millimeters
    z = ((boardDepth + probeHeight)) * ones(1,49);
    
    centre_x = [-93.543 0 93.543 -68.55 68.55 -93.543 0 93.543]*1e-3;
    centre_y = [93.543 68.55 93.543 0 0 -93.543 -68.55 -93.543]*1e-3;
    
 elseif (strcmpi(systemtype, '7x7_SIM') == true)
    % Spacing of test points on the Anser board
    l = 70e-3;
    w = 0.5e-3;
    s = 0.25e-3;
    th = 1.6e-3;
    N = 25;
    
    spacing = (42.86) * 1e-3;
    probeHeight = 80e-3;
    x=(-3:1:3)*(spacing); 
    x=[x x x x x x x];
    y=[ones(1,7)*spacing*3  ones(1,7)*spacing*2 ones(1,7)*spacing*1 ones(1,7)*0 -ones(1,7)*spacing*1 -ones(1,7)*spacing*2 -ones(1,7)*spacing*3];

    boardDepth = 4e-3; % Millimeters
    z = ((boardDepth + probeHeight)) * ones(1,49);
    
    centre_x = [-93.543 0 93.543 -68.55 68.55 -93.543 0 93.543]*1e-3;
    centre_y = [93.543 68.55 93.543 0 0 -93.543 -68.55 -93.543]*1e-3;
    
 elseif (strcmpi(systemtype, '7x7_42') == true)
    % Spacing of test points on the Anser board
    l = 98e-3;
    w = 0.5e-3;
    s = 0.25e-3;
    th = 2e-3;
    N = 25;
    
    spacing = (42.86) * 1e-3;
    probeHeight = 80e-3;
    x=(-3:1:3)*(spacing); 
    x=[x x x x x x x];
    y=[ones(1,7)*spacing*3  ones(1,7)*spacing*2 ones(1,7)*spacing*1 ones(1,7)*0 -ones(1,7)*spacing*1 -ones(1,7)*spacing*2 -ones(1,7)*spacing*3];

    boardDepth = 4e-3; % Millimeters
    z = ((boardDepth + probeHeight)) * ones(1,49);
    
    centre_x = [-130.96, 0, 130.96, -95.97, 95.97, -130.96, 0, 130.96]*1e-3;
    centre_y = [130.96, 95.97, 130.96, 0, 0, -130.96, -95.97, -130.96]*1e-3;
  elseif (strcmpi(systemtype, '7x7_42_SIM') == true)
    % Spacing of test points on the Anser board
    l = 98e-3;
    w = 0.5e-3;
    s = 0.25e-3;
    th = 2e-3;
    N = 25;
    
    spacing = (42.86) * 1e-3;
    probeHeight = 80e-3;
    x=(-3:1:3)*(spacing); 
    x=[x x x x x x x];
    y=[ones(1,7)*spacing*3  ones(1,7)*spacing*2 ones(1,7)*spacing*1 ones(1,7)*0 -ones(1,7)*spacing*1 -ones(1,7)*spacing*2 -ones(1,7)*spacing*3];

    boardDepth = 4e-3; % Millimeters
    z = ((boardDepth + probeHeight)) * ones(1,49);
    
    centre_x = [-130.96, 0, 130.96, -95.97, 95.97, -130.96, 0, 130.96]*1e-3;
    centre_y = [130.96, 95.97, 130.96, 0, 0, -130.96, -95.97, -130.96]*1e-3;
 end
 
end