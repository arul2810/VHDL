// Verilog Test Bench Module

// Test Bench Description:

/*


Auto verification test bench that runs all the tests necessary to determine if
the response from the module is satisfactory and as per requirement.

After running the test bench, if Success at end -> Test bench ran successfully.

If not, for check individual module errors.

Author: Arul Prakash Samathuvamani


*/

//---------------------------------------------------------------------------------

`timescale 1 ns/100 ps


// Module Declaration

module sobel_edge_tb;


// Test Bench input pins declaration

reg clock; // clock for the module


reg [2:0] slide_button; // input to simulate slide button

wire [6:0] thres_switch; // input to simulate slide button

// Output to seven segment displays

wire [6:0] seg1; 

wire [6:0] seg2;

wire [6:0] seg3;

wire [6:0] seg4;

wire [6:0] seg5;

wire [6:0] seg6;

wire [1:0] disp_out;

// State Debug Output

wire debug1;

wire debug2;

wire debug3;

wire debug4;

wire pixelReady;

// DUT Declaration

sobel_edge sobel_edge_dut (


	.clock(clock),
	.slide_button ( slide_button),
	.thres_switch ( thres_switch),
	.seg1 ( seg1),
	.seg2( seg2),
	.seg3( seg3),
	.seg4(seg4),
	.seg5(seg5),
	.seg6( seg6),
	.disp_out (disp_out),
	.debug1( debug1),
	.debug2 ( debug2),
	.debug3 ( debug3),
	.debug4( debug4)
	
);

// Start Simulation

integer error = 0;

initial begin

	$display ( "Simulation Started" );
	
	// Set and reset clock
	
		clock = 1'b0;
	
		#10; // Delay 10 seconds
		
		clock = 1'b1;  // set clock as high
		
		#10;
		
		clock = 1'b0;
		
		
		$display ("Checking if the states are working as per expectation");
		
		slide_button = 3'b000; // set slide button off
		
		#10;
		
		clock = 1'b1;
		
		if ( debug1 ) begin // check is state transistion works
				
				$display (" State1 Working as per expectation" );
				
		end
		else begin
		
			error = 1;
			$display (" Error in State1 ");
			
		end
		
		if ( seg6 == ~(7'b1110100) ) begin // check if display works as per expectation
		
			$display ( " Display working as per expectation");
		end
		else begin
		
			$display (" Error in State2 Display");
			error =1 ;
		end
		
		#10;
		
			// Set and reset clock
	
		clock = 1'b0;
	
		slide_button = 3'b001; // Turn on first slide button
		
		#10;		// wait
		
		//set clock
		
		clock = 1'b1;
		
		
		if ( debug2 ) begin // check if state transition is successful
		
			$display(" State2 Working as per expectation");
			
		end
		
		else begin //else
		
			$display( " Error in State2 ");
			error = 1;
			
		end
		
		if ( seg6 == ~(7'b1101111) ) begin // check if display works
		
			$display(" Display for State2 Working as per expectation");
		
		end
		
		else begin
		
			$display (" Display in state 2 has an error ");
			error = 1;
			
		end
		
		#10;
		
		clock = 1'b0;
		
		// Check for state 3 transition
		
		slide_button = 3'b010; // turn on second slide button
		
		#10;
		
		clock = 1'b1;
		
		if ( debug3 ) begin // check if state transition is successful
		
			$display (" State 3 working as per expectation" );
			
		end
		else begin
		
			$display ( " Error in state 3 transition");
			error = 1;
			
		end
		
		if ( seg6 == ~(7'b1111011) ) begin // check if display is set correctly
		
			$display ( " State3 display works as per expectation");
			
		end
		else begin
		
			$display (" State3 transition display error");
			error = 1;
			
		end
		
		#10;
		
		clock = 1'b0;
		
		// check for state 4 transition
		
		slide_button = 3'b100; // turn on 3rd slide button
		
		#10;
		
		clock = 1'b1;
		
		if (debug4 ) begin // check if state transition is successful
			
			$display ( " State 4 transition works");
			
		end
		
		else begin
		
			$display (" State 4 transition error");
			error = 1;
			
		end
		
		if ( seg6 == ~(7'b1111000) ) begin // check if display is set correctly
			
			$display ( " State 4 display works as per expectation ");
			
		end
		else begin
			
			$display (" State4 display transition works ");
			error = 1;
			
		end
		
		#10;
		
		clock = 1'b0;
		
		slide_button = 3'b110; // check if defaulting
		
		clock =  1'b1;
		
		#10;
		
		if (debug1 ) begin // defauulting?
		
			$display ( " Abnormal state defaulting" );
			
		end
		
		else begin
		
			$display ( " Error !! " );
			error = 1;
		end
		
		#10;
		
		clock = 1'b0;
		
		
		if ( !error ) begin
		
			$display ( " No errors in state transition ");
			
		end
		
		else begin
		
			$display ( " Errors present in state transition");
			
		end
		
end

endmodule
		

