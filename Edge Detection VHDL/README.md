# ELEC5566M - Mini Project - Arul Prakash Samathuvamani

# Sobel Edge Detector

Description of Repository:

Edge Detection using Sobel Operator has been designed using Verilog HDL. Performs Edge Detection on Input Image

This module is designed for ELEC5566M Mini Project

## Major Files in Repository:

1. Main_Module/sobel_edge.qpf - Sobel Edge Quartus Project File 

2. Main_Module/sobel_edge.v   - Sobel Edge Detector Verilog HDL File

#### Dependencies:

*Main_Module/LT24Display.v   - LT24 Display Control Verilog Module by Thomas Carpenter* <br>
*Main_Module/upCounter.v     - Upcounter for Verilog HDL* <br>
*Main_Module/seven_segment.v - Seven Segment Control Verilog HDL* <br>
*Main_Module/data.mif        - Input Image Memory Initialisation File* <br>
*Main_Module/mif2.mif        - Leeds Logo Memory Initialisation File* <br>

3. Main_Module/sobel_edge_tb.v    - Sobel Edge Detector Test Bench File

4. Main_Module/pin_assingment.tcl - Assigns input and output pins on DE1 SoC

Individual Components testing Modules as explained in Technical Report is inside "Individual_Test_Modules"

Each Individual Component is created as seperate Quartus Projects

1. Individual_Test_Modules/Arithmetic_test       - Performs basic Verilog adder testing.
3. Individual_Test_Modules/co_ordinate_test      - Checks if X and Y co-ordinates for image increment as expected.
4. Individual_Test_Modules/Image_display_test    - Checks if image is properly displayed on LT24 display.
5. Individual_Test_Modules/main_calculation_test - Checks if verilog arithmetic of Sobel Operator is correct
6. Individual_Test_Modules/MATLAB                - Contains all the MATLAB code for the project and MIF files created.
