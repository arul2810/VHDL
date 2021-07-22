/* threshold_select.v 

--------------------------------------------------------------------------------------------------------------------

Module Name : Threshold Select Verilog Module

Module Description : Select the threshold value and display in 7 Segment Display. 

Module Author : Arul Prakash Samathuvamani

Date: 16/5/2021

-------------------------------------------------------------------------------------------------------------------- 

Changelog :




*/


module threshold_select (

	// module input parameters
	
	input clock, // input clock
	
	//input enable, // input module enable signal, if 1 -> module is enabled
	
	input button2, // input to increment threshold -> key2
	
	input button3, // input to decrement threshold -> key3
	
	output reg [7:0] threshold // module output-> selected threshold value
	
);

// ----------------------------------------------------------------------------------------------------------------------

// Parameters used in the module


reg [7:0] current_threshold = 8'd100; // register to store the current register value

//reg [7:0] threshold;

seven_segment (

	.thres ( current_threshold )
	
);


always @ ( * ) begin

	//if ( enable ) begin

		if ( !button2 ) begin
		
			current_threshold = current_threshold + 10;
			threshold = current_threshold;
			
		end
		
		else if ( !button3 ) begin
		
			current_threshold = current_threshold -10 ;
			threshold = current_threshold;
			
		end
	//end
	
end

endmodule
	