/* seven_segment.v 

--------------------------------------------------------------------------------------------------------------------

Module Name : Seven Segment Display Verilog Module

Module Description : Module to control seven segment display

Module Author : Arul Prakash Samathuvamani

Date: 16/5/2021

-------------------------------------------------------------------------------------------------------------------- 

Changelog :

Threshold value lookup table removed and added to main module


*/


module seven_segment (

	// Declaration of input pins
	
	input clock,
	
	input [1:0] state, // says what to display
	
	input [20:0] thres, // says what number to display
	
	output [6:0] seg1, // output to 7-segment1
	 
	output [6:0] seg2, // output to 7-segment2
	
	output [6:0] seg3, // output to 7-segment3
	
	output [6:0] seg4, // output to 7-segment4
	
	output [6:0] seg5, // output to 7-segment5
	
	output [6:0] seg6, // output to 7-segment6
	
	output debug1,
	
	output  debug2,
	
	output  debug3,
	
	output  debug4
	
);

// --------------------------------------------------------------------------------------------------------------


// Definition of states to the module

	localparam BASE = 2'b00;
	localparam GRAY =  2'b01;
	localparam SOBEL = 2'b10;
	localparam THRES = 2'b11;
	

	
	reg [6:0] data6;
	reg [6:0] data5;
	reg [6:0] data4;
	reg [6:0] data3;
	reg [6:0] data2;
	reg [6:0] data1;
	
	reg debug_data1;
	reg debug_data2;
	reg debug_data3;
	reg debug_data4;
	
	assign seg6 = data6;
	assign seg5 = data5;
	assign seg4 = data4;
	assign seg3 = data3;
	assign seg2 = data2;
	assign seg1 = data1;
	assign debug1 = debug_data1;
	assign debug2 = debug_data2;
	assign debug3 = debug_data3;
	assign debug4 = debug_data4;
	
	reg [20:0] buffer;
	
	always @ ( * ) begin
	
		case ( state ) 
		
			BASE : begin
			
				data6 = ~(7'b1110100); // displays "h"
				data5 = ~(7'b1111011); // displays "e"
				data4 = ~(7'b0110000); // displays "l"
				data3 = ~(7'b0110000); // displays "l"
				data2 = ~(7'b0111111); // displays "0"
				data1 = ~(7'b0000000);
				debug_data1 = 1'b1;
				debug_data2 = 1'b0;
				debug_data3 = 1'b0;
				debug_data4 = 1'b0;
				
			end
			
			GRAY : begin
			
				data6 = ~(7'b1101111); // displays "g"
				data5 = ~(7'b0110001); // displays "r"
				data4 = ~(7'b1110111); // displays "a"
				data3 = ~(7'b1101110); // displays "y"
				data2 = ~(7'b0000000);
				data1 = ~(7'b0000000);
				debug_data1 = 1'b0;
				debug_data2 = 1'b1;
				debug_data3 = 1'b0;
				debug_data4 = 1'b0;
				
				
			end
			
			SOBEL : begin
			
				data6 = ~(7'b1111011); // displays "e"
				data5 = ~(7'b1011110); // displays "d"
				data4 = ~(7'b1101111);// displays "g"
				data3 = ~(7'b1111011); // displays "e"
				data2 = ~(7'b0000000);
				data1 = ~(7'b0000000);
				debug_data1 = 1'b0;
				debug_data2 = 1'b0;
				debug_data3 = 1'b1;
				debug_data4 = 1'b0;
				
			end
			
			THRES : begin
			
				data6 = ~(7'b1111000); // displays "t"
				data5 = ~(7'b1110100); // displays "h"
				data4 = ~(7'b0110001); // displays "r"
				debug_data1 = 1'b0;
				debug_data2 = 1'b0;
				debug_data3 = 1'b0;
				debug_data4 = 1'b1;
				
				buffer = ~ ( thres );
				data3 = buffer [20:14] ;
				data2 = buffer [13:7];
				data1 = buffer [6:0];
				
			end
			
			default  : begin
			
							
				data6 = ~(7'b1101111); // displays "g"
				data5 = ~(7'b0110001); // displays "r"
				data4 = ~(7'b1110111); // displays "a"
				data3 = ~(7'b1101110); // displays "y"
				data2 = ~(7'b0000000);
				data1 = ~(7'b0000000);
				debug_data1 = 1'b0;
				debug_data2 = 1'b1;
				debug_data3 = 1'b0;
				debug_data4 = 1'b0;
			end
		
		endcase
	end
	
 endmodule 