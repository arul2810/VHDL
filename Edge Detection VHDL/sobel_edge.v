/* sobel_edge.v 

--------------------------------------------------------------------------------------------------------------------

Module Name : Sobel Edge Verilog Module

Module Description : Module used to calculate sobel edge and sobel threshold for a given input image.

Module Author : Arul Prakash Samathuvamani, LT24 Module provided by University of Leeds - Author - Thomas Carpenter

Date: 13/5/2021

-------------------------------------------------------------------------------------------------------------------- 

Changelog :

Threshold Lookup .mif added here

State wise counter removed and added into edge and threshold module seperately

Changed from pushbutton to slide switch - 18/5

*/

// ----------------------------------------------------------------------------------------------------------------

// Declaration of module sobel_edge

module sobel_edge #(

	/* Parameters for the module
	
	IMAGE_WIDTH - Width of input image - Defaults 100
	IMAGE_HEIGHT - Height of input image - Defaults to 100
	*/
	
	parameter IMAGE_WIDTH = 100,
	parameter IMAGE_HEIGHT = 100
	
) (

/* Input Pins Description:

	Pin Name                |  Description
	                        |
	clock                   |  Clock signal
	globalReset             |  globalReset signal for LT24 Display -> Refer LT24Display module for more info
	slide_button [0]        |  Input signal for Slide Switch 0
	slide_button [1]        |  Input signal for Slide Switch 1
	slide_button [2]        |  Input signal for Slide Switch 2
	key_button1             |  Input signal for Push Button 1
	key_button2             |  Input signal for Push Button 2
	*/
	
	input clock,
	
	input globalReset,
	
	input [2:0] slide_button, // input from slide button
	
	input [6:0] thres_switch,

	// Output Pins Declaration
	
	// Output Pins to seven_segment.v
	
	output reg [1:0] disp_out, // Informs seven_segment.v of which state the system is currently in
	
	output reg [20:0] threshold, // If in edge threshold mode, passes to seven segment the input for current threshold values.
	
	// LT24 Display Output Pins -> Based on verilog file written by Thomas Carpenter
	
	output resetApp,
	
	output LT24Wr_n,
	
	output LT24RD_n,
	
	output LT24CS_n,
	
	output LT24RS,
	
	output LT24Reset_n,
	
	output [15:0] LT24Data,
	
	output LT24LCDOn,
	
	// Output Pins to 7-segment Display
	
	output [6:0] seg1, // output to 7-segment1
	 
	output [6:0] seg2, // output to 7-segment2
	
	output [6:0] seg3, // output to 7-segment3
	
	output [6:0] seg4, // output to 7-segment4
	
	output [6:0] seg5, // output to 7-segment5
	
	output [6:0] seg6, // output to 7-segment6
	
	// Debug used in test bench
	
	output reg debug1,
	
	output reg debug2,
	
	output reg debug3,
	
	output reg debug4

);

// ---------------------------------------------------------------------------------------------


// Declaration of local variables used in the module

reg [7:0] xAddr;  // x co-ordinate for LT24 Display
reg [8:0] yAddr;  // y co-ordinate for LT24 Display


// xAddr and yAddr is also used to calculate the memory address for images.


// ---------------------------------------------------------------------------------------------


// LT24 Display parameters -> to satisfy needs of LT24Display Verilog file by Thomas Carpenter


reg [15:0] pixelData;
wire pixelReady;
reg pixelWrite;


//----------------------------------------------------------------------------------------------


// Declaration of registers for input image, loaded using .mif Quartus file

(*ram_init_file = "data.mif"*) // Input 100x100 image -> default
reg [ 7 : 0 ] input_image [ ( ( IMAGE_WIDTH ) * ( IMAGE_HEIGHT) - 1 ) : 0 ];

(*ram_init_file = "mod2.mif"*) // Input 100x320 Leeds Logo Image 
reg [ 7:0 ] logo [ 31999 : 0 ] ; 

// reg [ 7:0 ] edge_image [ ( ( IMAGE_WIDTH ) * ( IMAGE_HEIGHT ) -1 ) : 0 ]; Used for debugging purposes

// -------------------------------------------------------------------------------------------



// Image buffer -> used to convert 16bit Grayscale to RGB565 Format

reg [7:0] image_buffer; // Temp variable used for conversion
//reg [31:0] address; // address register used for debugging purposes -> currently not used
//reg [7:0] pixel_buffer [299:0]; // alternate pixel fethching method -> Will not work, DO NOT USE


// --------------------------------------------------------------------------------------------

// Parameter values used for LCD Display


localparam LCD_WIDTH = 240;
localparam LCD_HEIGHT = 320;

// --------------------------------------------------------------------------------------------

// Parameter values used to denote the size of University of Leeds logo at the start

localparam LOGO_HEIGHT = 320;
localparam LOGO_WIDTH = 100;

// --------------------------------------------------------------------------------------------

// X Count andn Y Count values

wire [7:0] xCount;
wire [8:0] yCount;
wire yCntEnable = pixelReady && (xCount == (LCD_WIDTH-1));

// --------------------------------------------------------------------------------------------

// Declaration of states corresponsing to the status of slide switch


localparam STATE1  = 3'b000;   // STATE1 -> Display Leeds Logo
localparam STATE2  = 3'b001;  // STATE2 -> Display Grayscale Image
localparam STATE3  = 3'b010; // STATE3 -> Display Sobel Edge Image
localparam STATE4  = 3'b100; // STATE4 -> Display Sobel Edge Threshold of Image


// Declaration of part to run on positive edge of clock

localparam LOGO  = 2'b00;  // Display Leeds Logo
localparam GRAY  = 2'b01;  // Display Gray Scale image
localparam EDGE  = 2'b10;  // Display Sobel edge image
localparam THRES = 2'b11; // Display Sobel Edge Threshold of Image


reg [2:0] STATE = 2'b00; // Declare state of the system, used to select which part to run


// Declare calculation states -> used to run a specific part during every clock

reg [3:0] SOBEL_STATE = 4'b0000;
reg [3:0] THRES_STATE = 4'b0000;

// Declaration of states in Sobel Edge Calculation

localparam SOBEL_INITIAL = 4'b0000; // Used to set xAddr and yAddr values to zero
localparam SOBEL_STATE1  = 4'b0001; // Used to check on what action to be done -> depends on coordinates

// Parameters used to fetch 8- pixel information
/*  P1 P2 P3
    P4 P5 P6
	 P7 P8 P8 
	 
	 P5 is the current pixel in calculation -> corresponding states are used to fetch corresponding pixel data
	*/
	
localparam SOBEL_ADDRESS1 = 4'b0010; // Fetch Pixel1
localparam SOBEL_ADDRESS2 = 4'b0011; // Fetch Pixel2
localparam SOBEL_ADDRESS3 = 4'b0100; // Fetch Pixel3
localparam SOBEL_ADDRESS4 = 4'b0101; // Fetch Pixel4
localparam SOBEL_ADDRESS5 = 4'b0110; // Fetch pixel6
localparam SOBEL_ADDRESS6 = 4'b0111; // Fetch Pixel7
localparam SOBEL_ADDRESS7 = 4'b1000; // Fetch Pixel8
localparam SOBEL_ADDRESS8 = 4'b1001; // Fetch Pixel9

// States used for Values calculation 

localparam SOBEL_STATE2 = 4'b1010;
localparam SOBEL_STATE3 = 4'b1011;
localparam SOBEL_STATE4 = 4'b1100;
localparam SOBEL_STATE5 = 4'b1101;


reg threshold_enable;

//---------------------------------------------------------------------------------------------

// Temporary registers used for calculations


reg [8:0] sobel_temp1;
reg [8:0] sobel_temp2;
reg [8:0] sobel_temp3;
reg [8:0] sobel_temp4;

// Corresponding pixel data during each cycle of fetch is stored here
reg [7:0] pixel1;
reg [7:0] pixel2;
reg [7:0] pixel3;
reg [7:0] pixel4;
//reg [7:0] pixel5;
reg [7:0] pixel6;
reg [7:0] pixel7;
reg [7:0] pixel8;
reg [7:0] pixel9;

reg [7:0] current_threshold = 8'd50; 

// Seven Segment threshold display lookup registers -> not used with slide switch method of selection- just used for presentation

(*ram_init_file = "seg_lookup.mif"*)
reg [20:0] lookup [251:0];

//---------------------------------------------------------------------------------------------

// Declaration of upcounter module

upcounter #(
    .WIDTH    (           9),
    .MAX_VALUE(LCD_HEIGHT-1)
) yCounter (
    .clock     (clock     ),
    .reset     (resetApp  ),
    .enable    (yCntEnable),
    .countValue(yCount    )
);


upcounter #(
    .WIDTH    (          8),
    .MAX_VALUE(LCD_WIDTH-1)
) xCounter (
    .clock     (clock     ),
    .reset     (resetApp  ),
    .enable    (pixelReady),
    .countValue(xCount    )
);


// Declaration of seven segment display module

seven_segment ( 
	
	.clock ( clock),
	.thres ( threshold ),
	.state ( disp_out ),
	.seg1 ( seg1 ),
	.seg2 ( seg2 ),
	.seg3 ( seg3 ),
	.seg4 ( seg4 ),
	.seg5 ( seg5 ),
	.seg6 ( seg6 )
	//.debug1 ( debug1 ),
	//.debug2 ( debug2 ),
	//.debug3 ( debug3 ),
	//.debug4 ( debug4 )
	
);

// Declaration of LT24Display module

LT24Display #(
    .WIDTH       (LCD_WIDTH  ),
    .HEIGHT      (LCD_HEIGHT ),
    .CLOCK_FREQ  (50000000   )
) Display (
    //Clock and Reset In
    .clock       (clock      ),
    .globalReset (globalReset),
    //Reset for User Logic
    .resetApp    (resetApp   ),
    //Pixel Interface
    .xAddr       (xAddr      ),
    .yAddr       (yAddr      ),
    .pixelData   (pixelData  ),
    .pixelWrite  (pixelWrite ),
    .pixelReady  (pixelReady ),
    //Use pixel addressing mode
    .pixelRawMode(1'b0       ),
    //Unused Command Interface
    .cmdData     (8'b0       ),
    .cmdWrite    (1'b0       ),
    .cmdDone     (1'b0       ),
    .cmdReady    (           ),
    //Display Connections
    .LT24Wr_n    (LT24Wr_n   ),
    .LT24Rd_n    (LT24RD_n   ),
    .LT24CS_n    (LT24CS_n   ),
    .LT24RS      (LT24RS     ),
    .LT24Reset_n (LT24Reset_n),
    .LT24Data    (LT24Data   ),
    .LT24LCDOn   (LT24LCDOn  )
);


//------------------------------------------------------------------------------------------------


// Procedural block used to change the state of the system

always @ ( * ) begin

	case ( slide_button )
	
		STATE1 : begin
		
			STATE            <= 2'b00; // set to logo display state
			disp_out         <= 2'b00; // set display to logo state
			threshold_enable <= 1'b0; // Disable threshold selecting module
			// Debug Wires Declaration
			debug1 <= 1'b1;
			debug2 <= 1'b0;
			debug3 <= 1'b0;
			debug4 <= 1'b0;
			
			
		end
		
		STATE2 : begin
		
			STATE            <= 2'b01; // set to gray scale display state
			disp_out         <= 2'b01; // set display gray
			threshold_enable <= 1'b0; // Disable Threshold selecting module
			// Debug Declartion
			debug1 <= 1'b0;
			debug2 <= 1'b1;
			debug3 <= 1'b0;
			debug4 <= 1'b0;
			
		end
		
		STATE3 : begin
		
			STATE            <= 2'b10; // set to sobel edge display state
			disp_out         <= 2'b10; // set display to edge
			threshold_enable <= 1'b0; // Disable threshold selecting module
			// Debug Declaration
			debug1 <= 1'b0;
			debug2 <= 1'b0;
			debug3 <= 1'b1;
			debug4 <= 1'b0;
			
		end
		
		STATE4 : begin
			
			STATE            <= 2'b10; // set to sobel edge threshold display state
			disp_out         <= 2'b11; // set display to thres
			threshold_enable <= 1'b1; // enable threshold selecting module
			// Debug Declaration
			debug1 <= 1'b0;
			debug2 <= 1'b0;
			debug3 <= 1'b0;
			debug4 <= 1'b1;
			
		end
		
		default : begin
		
			STATE            <= 2'b00; // by default, is set to display logo
			disp_out         <= 2'b00; // set to logo state
			threshold_enable <= 1'b0; // disable threshold selecting module
			// Debug Declaration
			debug1 <= 1'b1;
			debug2 <= 1'b0;
			debug3 <= 1'b0;
			debug4 <= 1'b0;
			
		end
	
	endcase
	
end

//--------------------------------------------------------------------------------------------------


// Procedural block to update threshold values

/* Has bugs and needs to be fixed -> would be added in future release 

always @ ( * ) begin

	if ( threshold_enable ) begin // Runs only if threshold select module is enabled

		if ( ~button2 ) begin // If Key1 is pressed
		
			current_threshold = current_threshold + 10; // Increment threshold value by 10
			threshold = lookup [ current_threshold ]; // Use the lookup table to get input to be fed to seven segment display
			
		end
		
		else if ( ~button3 ) begin // If key2 is pressed
		
			current_threshold = current_threshold -10 ; // Increment threshold value by 10
			threshold = lookup [ current_threshold ]; // Use the lookup table to get input to be fed into seven segment display
			
		end
	end
	
end

*/

// ------------------------------------------------------------------------------------------------


// LT24 Pixel Write

always @ ( posedge clock or posedge resetApp ) begin


	// When pixelwrite is set to 1, it means that LT24 display is ready to get the new pixel data

	if ( resetApp ) begin
	
		pixelWrite <= 1'b0;
		
	end else begin
	
		pixelWrite <= 1'b1;
		
	end
	
end

// -------------------------------------------------------------------------------------------------

// Threshold Selecting Module

/* Default -> 50

	Switch 3 -> Threshold of 100
	
	Switch 4 -> Threshold of 120
	
	Switch 5 -> Threshold of 140
	
	Switch 6 -> Threshold of 160
	
	Switch 7 -> Threshold of 180
	
	Switch 8 -> Threshold of 200
	
	Switch 9 -> Threshold of 220


*/

always @ (*) begin

	case ( thres_switch ) 
	
	7'b0000001 : begin // Switch 3 is on
	
		current_threshold <= 8'd100; // Set threshold to 100
		threshold         <= 21'b000011001111110111111; // set the display to 100 -> Use lookup.mif in future versions
		
	end
		
	7'b0000010 : begin // when switch 4 is on
	
		current_threshold <= 8'd120; // set threshold to 120 
		threshold         <= 21'b000011010110110111111; // set the display to 120 
	 
	end 
	
	7'b0000100 : begin // when switch 5 is on
	
		current_threshold <= 8'd140; // set threshold to 140
		threshold         <= 21'b000011011001100111111; // set the display to 140
		
	end 
	
	7'b0001000 : begin // when switch 6 is on
	
		current_threshold <= 8'd160; // set threshold to 160
		threshold         <= 21'b000011011111010111111; // set the display to 160
	
	end
	
	7'b0010000 : begin // when switch 7 is on
	
		current_threshold <= 8'd180; // set threshold to 180
		threshold         <= 21'b000011011111110111111; // set the display to 180
		
	end
	
	7'b0100000 : begin // when switch 8 is on
	
		current_threshold <= 8'd200; // set the threshold to 200 
		threshold         <= 21'b101101101111110111111; // set the display to 200
		
	end
	
	7'b1000000 : begin // when switch 9 is on
	
		current_threshold <= 8'd220; // set the threshold to 220
		threshold         <= 21'b101101110110110111111; // set the display to 220
	end
	
	default : begin
	
		current_threshold <= 8'd50; // set the threshold to 50
		threshold         <= 21'b000000011011010111111; // set the display to 50
		
	end
	endcase
end

// --------------------------------------------------------------------------------------------------

// LT24 Display Module - Displays the corresponding pixel data according to the state

/* Information regarding the states

	LOGO   - Display Leeds Logo - Initial Boot Stage
	GRAY   - Display Grayscale image on LT24
	SOBEL  - Display Sobel Edge image
	THRES  - Display Sobel Edge Threshold image
	
*/

always @ ( posedge clock or posedge resetApp ) begin

	if ( resetApp ) begin
		
		// LT24 Display is reset
		
		pixelData = 16'b0;
		xAddr     = 8'b0;
		yAddr     = 9'b0;
		
	end
	
	else if ( pixelReady ) begin
	
		// Enter case statement
		
		case ( STATE ) 
		
			LOGO : begin // This state sets the display to the image of University of Leeds
			
				xAddr = xCount; // set counter value to value of address 
            yAddr = yCount;


			  
			  if ( xAddr < LOGO_WIDTH ) begin // if coordinates is less than width and height of image, continue
				if ( yAddr < LOGO_HEIGHT ) begin
									
						image_buffer          = logo[ ( yAddr * 100 ) + xAddr ] >> 2 ; // get the corresponding pixel data and convert to 5 bits
						pixelData [ 15:11 ]   = image_buffer [5:1];          // assing bits according to RGB to get grayscale image., bits 1-5 contain actual pixel data, LSB contains zero
						pixelData [ 4:0 ]       = image_buffer [5:1];
						pixelData [ 10:5 ]    = image_buffer [5:0];
							
				end	
			end
		  
		  else begin
			
				pixelData = 16'b1; // set the screen to black on areas other than image
		 
		  end
		  
		  end
		  
		 GRAY : begin // This sets the display to input gray scale image
		 
			xAddr = xCount; // set counter values to value of address
			yAddr = yCount;
			
			if ( xAddr < IMAGE_WIDTH ) begin // if coordinates are less than width and height of image, continue
				if ( yAddr < IMAGE_HEIGHT ) begin
				
					
					image_buffer          = input_image[ ( yAddr * IMAGE_HEIGHT ) + xAddr ] >> 2 ; // get the corresponding pixel data and convert to 5 bits
					pixelData [ 15 : 11 ] = image_buffer [5:1]; // assing bits according to RGB to get grayscale image., bits 1-5 contain actual pixel data, LSB contains zero
					pixelData [ 10 : 5 ]  = image_buffer[5:0];
					pixelData [4:0]       = image_buffer [5:1];
					
				end
			end
			
			else begin
			
				pixelData = 16'b1; // set the screen to black on areas other than image
				
			end
			end
			
			EDGE : begin // sets the display input to display edge calculated image
			
				case ( SOBEL_STATE )
				
					SOBEL_INITIAL : begin // initial state, set all values to zero
					
						xAddr = 0;
						yAddr = 0;
						SOBEL_STATE = 4'b0001;
						
					end
					
					SOBEL_STATE1 : begin // sobel state1 -> find which data to fetch
					
						if ( xAddr == 0 || xAddr == ( IMAGE_WIDTH - 1 ) ) begin // if corner pixel, set image_buffer as white and go to last state
						
							image_buffer = 8'b1;
							SOBEL_STATE  = 4'b1101;
						
						 
						end
						
						else if ( yAddr == 0 || yAddr == ( IMAGE_HEIGHT - 1 ) ) begin // if corner pixel, set image_buffer as white and go to last state
						
							image_buffer = 8'b1;
							SOBEL_STATE  = 4'b1101; 
							
						end
						
						else if ( xAddr > IMAGE_WIDTH || yAddr > IMAGE_HEIGHT ) begin // if coordinates out of the image, blacken the area
						
							image_buffer = 8'b0;
							SOBEL_STATE  = 4'b1101;
						end
						
						else begin
						
							SOBEL_STATE = 4'b0010; // for all other pixels, calculate the edge using kernel 
							
						end
						
					end
					/*
					
					Pixel1 Pixel2 Pixel3
					Pixel4 Curr_P Pixel5
					Pixel6 Pixel7 Pixel8
					
					Curr_p -> current pixel
					*/
					
					SOBEL_ADDRESS1 : begin
						
						pixel1      = input_image [ ( ( yAddr - 1 ) * IMAGE_HEIGHT ) + ( xAddr - 1 ) ]; // get pixel 1 -> one col, one row before
						SOBEL_STATE = 4'b0011;
						
					end
					
					SOBEL_ADDRESS2 : begin
					
						pixel2      = input_image [ ( ( yAddr -1 ) * IMAGE_HEIGHT ) + ( xAddr ) ]; // get pixel2 
						SOBEL_STATE = 4'b0100;
						
					end
					
					SOBEL_ADDRESS3 : begin
					
						pixel3      = input_image [ ( ( yAddr - 1 ) * IMAGE_HEIGHT ) + ( xAddr + 1 ) ]; // get pixel3
						SOBEL_STATE = 4'b0101;
					end
					
					SOBEL_ADDRESS4 : begin
					
						pixel4      = input_image [ ( yAddr * IMAGE_HEIGHT ) + ( xAddr - 1 ) ]; // get pixel4
						SOBEL_STATE = 4'b0110;
					
					end
					
					SOBEL_ADDRESS5 : begin
					
						pixel6      = input_image [ ( yAddr * IMAGE_HEIGHT ) + ( xAddr + 1 ) ]; // get pixel6
						SOBEL_STATE = 4'b0111;
						
					end
					
					SOBEL_ADDRESS6 : begin
					
						pixel7      = input_image [ ( ( yAddr + 1 ) * IMAGE_HEIGHT ) + ( xAddr - 1 ) ]; // get pixel7
						SOBEL_STATE = 4'b1000;
						
					end
					
					SOBEL_ADDRESS7 : begin
					
						pixel8      = input_image [ ( ( yAddr + 1 ) * IMAGE_HEIGHT ) + ( xAddr ) ]; // get pixel8
						SOBEL_STATE = 4'b1001;
						
					end
					
					SOBEL_ADDRESS8 : begin
					
						pixel9      = input_image [ ( ( yAddr + 1 ) * IMAGE_HEIGHT ) + ( xAddr + 1 ) ]; // get pixel9
						SOBEL_STATE = 4'b1010;
						
					end
					
					SOBEL_STATE2 : begin
					
						// Calculating pixel by multiplying with Kernel
						
						// P1 + 2P2 + P3 , P7 + 2P8 + P9 , P3 + 2P6 + P9, P1+ 2P4+P7
						
						/* Convolution kernel is 
						
							mx = -1 0 1  my = -1 -2 -1
							     -2 0 2        0  0  0
								  -1 0 1        1  2  1
								  
								  */
					
						sobel_temp1 = ( pixel1 + ( 2 * pixel2 ) + pixel3 ); 
						sobel_temp2 = ( pixel7 + ( 2 * pixel8 ) + pixel9 ); 
						
						sobel_temp3 = ( pixel3 + ( 2 * pixel6 ) + pixel9 );
						sobel_temp4 = ( pixel1 + ( 2 * pixel4 ) + pixel7 );
						
						if ( sobel_temp1 [8] ) begin // if the calculated value is greater than 255, set to 255
							
							sobel_temp1 = 9'd255;
						end
						
						if ( sobel_temp2 [8] ) begin // if the calculated value is greater than 255, set to 255
							
							sobel_temp2 = 9'd255;
							
						end
						
						if ( sobel_temp3 [8] ) begin // if the calculated value is greater than 255, set to 255
							
							sobel_temp3 = 9'd255;
						end
						
						if ( sobel_temp4 [8] ) begin // if the calculated value is greater than 255, set to 255
						
							sobel_temp4 = 9'd255;
							
						end
						
						SOBEL_STATE = 4'b1011; // proceed to next state 
						
					end
					
					SOBEL_STATE3 : begin
					
						// Calculate Fx and Fy 
						
						sobel_temp1 = sobel_temp1 - sobel_temp2;
						sobel_temp2 = sobel_temp3 - sobel_temp4;
						
						if(sobel_temp1 [8] ) begin // if negative value, set to zero
							sobel_temp1 = 9'd0;
						end
						
						if ( sobel_temp2[8] ) begin // if negative value, set to zero
							sobel_temp2 = 9'd0;
						end
						
						SOBEL_STATE = 4'b1100; // proceed to next state
						
					end
					
					SOBEL_STATE4 : begin
					
						// Edge = |fx| + |fy| 
						
						sobel_temp1 = sobel_temp1 + sobel_temp2;
						
						if ( sobel_temp1[8] ) begin // if greater than 255 set to 255 
						
							sobel_temp1 =  9'd255;
							
						end
						
						if ( threshold_enable ) begin
							
							if ( sobel_temp1 < current_threshold ) begin
							
								sobel_temp1 = 9'b0;
							end
						end
						
						image_buffer = sobel_temp1; // if greater than 255 set to 255
						
						SOBEL_STATE = 4'b1101; // proceed to next state
						
					end
					
					SOBEL_STATE5 : begin
					
						image_buffer          = image_buffer << 2; // get the corresponding pixel data and convert to 5 bits
						pixelData [ 15 : 11 ] = image_buffer [5:1]; // assing bits according to RGB to get grayscale image., bits 1-5 contain actual pixel data, LSB contains zero
						pixelData [ 10 : 5 ]  = image_buffer[5:0];
						pixelData [4:0]       = image_buffer [5:1];
						
						if ( xAddr < ( LCD_WIDTH - 1 ) ) begin // increment xAddr 
						
							xAddr = xAddr +1;
							
						end
						
						else begin
						
							xAddr = 0;
							
							if ( yAddr < ( LCD_HEIGHT -1 ) ) begin // increment yAddr
								yAddr = yAddr + 1;
							end
							else begin
								yAddr = 0;
								
							end
							
						end
						
						SOBEL_STATE = 4'b0001; // go to state1
						
						end
					endcase
					end
				
			
			//THRES : begin
			
			// THRES part added into sobel edge state
			
			//end
			
				
		
		endcase
		
	end
end

endmodule

			
			