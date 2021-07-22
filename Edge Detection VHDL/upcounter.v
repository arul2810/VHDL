/* upcounter.v

------------------------------------------------------------------------------------------------------------------------------

Module Name : Upcounter Verilog Module

Module Description : Increase the value of the input by 1 at everyu positive clock untill the clock value reaches max.

							If clock value reaches max, it is reset to zero.
							
Module Author : Arul Prakash Samathuvamani , Inspired from upcounter verilog file by Thomas Carpenter - University of Leeds

Date : 13/5/2021

Changelog:

Module is parameterized

*/

// --------------------------------------------------------------------------------------------------------------------------


// Module Declaration

module upcounter #(

	parameter WIDTH = 10, // Size of count valuek
	parameter INCREMENT = 1, // value to increment counter by
	parameter MAX_VALUE = ( 2**WIDTH ) -1 // maximum value to be calculated
	
) (

	/* Input Pins Declaration
	
	clock -> input clock
	reset -> reset signal
	enable -> if to enable upcounter
	
	*/
	
	input clock,
	
	input reset,
	
	input enable,
	
	output reg [ (WIDTH-1) : 0 ] countValue
	
);

// Up- Counter Module

always @ ( posedge clock ) begin

	if ( reset ) begin
	
		countValue <= { (WIDTH){1'b0}}; // set all the bits to zero
		
	end else if ( enable ) begin
	
		if ( countValue >= MAX_VALUE [WIDTH-1:0]) begin
		
			countValue <= { (WIDTH){1'B0}};
			
		end else begin
		
			countValue <= countValue + INCREMENT [WIDTH-1:0];
		end
	end
end

endmodule
