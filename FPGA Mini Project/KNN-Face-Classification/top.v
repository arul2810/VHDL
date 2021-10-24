
module top (

	input clock,
	
	input globalReset,
	
	input href,
	
	input [7:0] camera_data

) ;

wire pll_clock;

PLL PLLClock (


	.refclk ( clock ),
	.rst ( globalReset ),
	.outclk_0 ( pll_clock )
	
);


OV7670Capture Camera(

	//.p_clk ( pll_clock),
	.clock ( clock ),
	.reset ( globalReset ),
	.href ( href ),
	.input_bits ( camera_data )
	
);

endmodule