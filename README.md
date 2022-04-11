# Stage_Owis_PS10

This repository is used as an interfacing class to conveniently control the OWIS PS10 stage controller through an object oriented MATLAB interface. The repository is tested on Windows 10 running MATLAB R2020b. It requires the OWISSoft code which can be downloaded from the company website after registering.

Before using, please 

*  adapt the paths which point to the dll and header file
*  adapt the pitch and steps per revolution to match your stage
*  adapt the COM port

Those properties cannot be read from the stage. Other then this I hope that the code is self-explaining and straight forward to use. Please let me know if you would need another feature implemented.

Try update from home PC