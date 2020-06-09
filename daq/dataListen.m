% Anser EMT, the worlds first open-source electromagnetic tracking system.
% Copyright (c) 2017, Alex Jaeger, Kilian O'Donoghue
% All rights reserved.
% This code is licensed under the BSD 3-Clause License.

function dataListen(src, event)
% dataListen.m
% This function is called as an event handle whenever the DAQ acquires the desired number of samples.
% The event handle is set up in fDAQSetup.m

% Global variable sessionData is declared in order to bring the variable into function
global sessionData


% Assign new data from the acquisition event global variable sessionData
% This data is now accessible through the use of fDAQAcquire.m
sessionData = event.Data;

end