# Matlab-Anser

**Matlab-Anser** is the Matlab library and interface for the open-source [Anser](https://github.com/StephenHinds/AnserEMT-Homepage/) electromagnetic tracking system.

## Users

#### Manual
A quickstart guide for the Anser EMT system is available [here](https://github.com/StephenHinds/AnserEMT-Homepage/).

#### Drivers
The application requires the latest version of **NI DAQmx** (available for [Windows](http://www.ni.com/download/ni-daqmx-17.6/7169/en/)). Please refer to the user manual for installation.


## Developers

### System Initialisation
- Launch Matlab and navigate to the project directory.
- Open `RunSetup.m` script. Ensure the NI DAQmx driver is recognised in windows device manager and the **DevX** identifier is correct. 
- Run `RunSetup.m`. After a brief pause you should see some messages followed by the 'System initialised'. The tracking system is now ready for use.

<p align="center">
    <img  width="40%"src="readme/img/devX.jpg">
</p>


### System Calibration

- Connect the lead of the sensor calibration probe to one of the eight ports on the base station.
- Run `RunCalibration.m`. Again, ensure the **DevX** identifier is correct.
- Select the sensor channel to calibrate. (**Note:** each port on the base station as two channels)
- Fully insert the sensor calibration probe into the field generator at *Point 1*.
- Follow the on-screen instructions.
- The printed error (mm) gives an idea of the quality of the calibration. An error of ~0.5-1.2mm is acceptable.
- The calibration data is automatically saved to the 'sys' structure and saved to the '/data' folder. Sensors connected to this channel can now be tracked by the system 

### Sensor Tracking

- Run `RunSensorBasic.m` to track the sensor and view positions.
- Choose the appropriate sensor channel and ensure the **DevX** identifier and is correct.
- The system will initialise and print the sensor positions to the console.
- Click the OK button on the on-screen prompt to stop tracking.
- Use this file as a reference for writing EMT applications.

## Cite this project
- https://doi.org/10.1007/s11548-017-1568-7
- https://doi.org/10.1007/978-3-030-00937-3_20

## References

[0] https://uk.mathworks.com/matlabcentral/answers/96960-does-matlab-pass-parameters-using-call-by-value-or-call-by-reference


## Aside: a note on the code structure

The system utilises a code structure based on the passing and returning of
a single structure called 'sys'. This large structure contains all the parameters
necessary for system operation.

The structure is passed as an arguement and returned as a value in many functions. This is performed in order to avoid the use of global variables. Matlab traditionally passes function arguments by value, and not by reference as in other languages. This would normally mean a large structure like 'sys' would introduce unnecessary memory copies as the structure is passed back and forth between functions. This is **not** the case in Matlab, as the interpreter intelligently checks and only performs copies of structure members if they are changed within a function [0]. Little to no performance penalties are incurred.

[0] https://uk.mathworks.com/matlabcentral/answers/96960-does-matlab-pass-parameters-using-call-by-value-or-call-by-reference


