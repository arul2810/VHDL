module OV7670Capture (


	input p_clk,
	
	input clock,
	
	input href,
	
	input reset,
	
	input [7:0] input_bits,
	
	output reg [15:0] output_data,
	
	output reg data_ready
	
);


// Declaration of the states


localparam STATE_1 = 1'b0;

localparam STATE_2 = 1'b1;

reg STATE = 1'b0;






// Display Initialisation

LT24Input Display(

	.clock ( clock ),
	
	.pixel ( output_data ),
	
	.reset ( reset ),
	
	.pixelReady ( data_ready )

);





// Working part of the module

always @ (posedge p_clk) begin

	case ( STATE ) 
	
	STATE_1 : begin
	
		if ( href ) begin
	
			data_ready <= 1'b0;
			output_data [15:8] <= input_bits [7:0];
			STATE <= 1'b1;
		
		end
	
	end
	
	STATE_2 : begin
	
		if ( href ) begin
	
		data_ready <= 1'b1;
		output_data [7:0] <= input_bits [7:0];
		STATE <= 1'b0;
		
		end
		
	end
	
	endcase
	
	end 
	
	
// End of Module

endmodule
