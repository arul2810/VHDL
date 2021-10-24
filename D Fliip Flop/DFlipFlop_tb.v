
`timescale 1 ns/100 ps


// Test bench module Declaration

module DFlipFlop_tb;

// Test Bench genereated Input Signals Declaration

reg d;
reg clock;
reg reset;


// DUT output signals

wire q;

// Instance for device under testing

DFlipFlop flipflop_dut(

	.d (d),
	.clock(clock),
	.reset(reset),
	.q(q)
);

//Test Bench Logic

initial begin

	$display ( " Simulation Started at %d ", $time);
	
	$monitor ( " d: %d , q : %d ", d , q );
	
	// Initialise d and clock and reset
	
	d = 1'b1;
	reset = 1'b0;
	clock = 1'b1;

	#10
	d = 1'b0;
	#10
	d = 1'b1;
	#10
	reset = 1'b1;
	
	
end

endmodule


 