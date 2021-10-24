# ELEC5566M Written Assignment Repository - State Machine Based Digital Lock 

Description of Repository :

Digital Lock designed using Verilog HDL that locks and unlocks the system. User inputs a PIN which locks the system and if the same input is repeated, then the system is unlocked.

This module is designed for Written Assignment for ELEC5566M. 

Files in the Repository

 1 . DigitalLock.qpf - Quartus Project File 
 
 2. ip/DigitalLock.v - Top Level Entity for Digital Lock Verilog Project.
 
	Module DigitalLock is defined in this verilog file. This is also the top level entity for this project.
	
 3. simulation/DigitalLock_tb.v - Test Bench Verification File
	
	Module DigitalLock Test bench verification verilog file. The project has been configured, if RTL simulation is run inside 'UoL' simulation, then the test bench should verify the 
	working of the system automatically. 
	
Other files in this directory are automatically created by Quartus.

This project has been compiled using Quartus Lite 17.1