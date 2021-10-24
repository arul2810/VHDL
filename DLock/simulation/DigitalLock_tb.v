/* State Machine Based Digital Lock - Test Bench
* ---------------------
* By: Arul Prakash Samathuvamani
* For: University of Leeds - ELEC5566M Assingment 2
* 
*
* Date : 13th of March 2021
*
* Module Description:
* ------------------
* Test Bench file for Digital Lock 
* 
*/

 `timescale 1 ns/100 ps
 
 
 // Initialising Test Bench Module
 
 module DigitalLock_tb;
 
 // Test Bench generated Signals
 
 reg clock;
 reg reset;
 

 reg [3:0]key;
 
 // DUT Output Signal
 
 wire z;
 
 wire error;

 wire [6:0]display_out;
 
 // wires to check if the register display_out stores correct value
 
 wire [6:0]display_zero ; 
 assign display_zero = 7'b0110000;
 
 wire [6:0]display_one ;

 assign display_one = 7'b1011011;
 
 wire[6:0]error_disp;
 assign error_disp = 7'b1111001;
 
 wire [6:0]lock_disp;
 assign lock_disp = 7'b0111000;
 
 wire [6:0]unlock_disp;
 assign unlock_disp = 7'b0111110; 
 
 wire [6:0]wrong_pin;
 assign wrong_pin = 7'b1110011;
 
 wire [6:0]time_out;
 assign time_out = 7'b0111111;

 integer display_flag = 0;
 integer bug_flag = 0;
	

 // Initialising DUT for digital lock 
 
 DigitalLock digitalLock_dut (
 
	.clock(clock),
	.key(key),
	.reset(reset),
	.z(z),
	.error(error),
	.display_out(display_out)
	
);

// Logic for test bench

integer k = 0;

initial begin

	$display(" Simulation Started " ); // Simulation started message 
	
	$monitor(" output changed z = %d" , z ); // Monitor to check if the system is in locked or unlocked state
	
	// Initially the system is reset and all the key presses is initialled to LOW state
	clock <= 1'b1;
	reset = 1'b1;
	key[0] = 1'b0;
	key[1] = 1'b0;
	key[2] = 1'b0;
	key[3] = 1'b0;
	
	#10;
	
	// after 10ns , the system reset is turned off
	
	reset = 1'b0;
	
	clock = 1'b0;
	
	#10;
	
	/* For simulation purposes, the clock is turned on and off for 10ns 
		
	*/
	
	
	$display("");
	$display("");
	$display("Testing Locking System");
	$display("");
	$display("");
	
	
	for ( k = 0 ; k <  6 ; k = k + 1) begin // to check if the system locks correctly 
	
		if ( k % 2 == 0 ) begin // at even clock cycle key[0] is pressed
		
			
			clock <= 1'b1;
			key[0] <= 1'b1; // key[0] is pressed
			
			
			
			
			#10;
			clock <= 1'b0;
			if ( display_out == display_zero ) begin // to check if the display fuction works as expected , same is done in remaining clock cycles
				
				$display ( " The display shows value as expected " ); 
			
			end
			
			else begin // if display module has some errors in it 
			
				$display (" Error in display, fix it ! ");
				display_flag = 1; // flag is set to 1, if flag has 1, it shows that display module has failed.
				
			end
			
			key[0] <= 1'b0;
			#10;
			
			
		end
		else begin // at odd clock cycles, key[1] is pressed
		
			
			clock <= 1'b1;
			key[1] <= 1'b1;
						
			#10;
			clock <= 1'b0;
			
			if ( display_out == display_one ) begin // checking if the display works as expected.
				
				$display ( " The display shows value as expected " );
			
			end
			
			else begin // else, and error is given out and displyed in console.
			
				if ( k != 5) begin // else part works only in the last loop
					$display (" Error in display, fix it !");
					display_flag = 1; // Display bug flag is set.
				end
				
			end
			
			key[1] <= 1'b0;
			#10;
			

		end
	end
	
	// Waiting for certain clock signals 
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	// Sequence of key input is repeated again
	
		for ( k = 0 ; k <  6 ; k = k + 1) begin // to check if the system locks correctly 
	
		if ( k % 2 == 0 ) begin // at even clock cycle key[0] is pressed
		
			
			clock <= 1'b1;
			key[0] <= 1'b1; // key[0] is pressed
			
			
			
			
			#10;
			clock <= 1'b0;
			if ( display_out == display_zero ) begin // to check if the display fuction works as expected , same is done in remaining clock cycles
				
				$display ( " The display shows value as expected " ); 
			
			end
			
			else begin // if display module has some errors in it 
			
				$display (" Error in display, fix it ! ");
				display_flag = 1; // flag is set to 1, if flag has 1, it shows that display module has failed.
				
			end
			
			key[0] <= 1'b0;
			#10;
			
			
		end
		else begin // at odd clock cycles, key[1] is pressed
		
			
			clock <= 1'b1;
			key[1] <= 1'b1;
						
			#10;
			clock <= 1'b0;
			
			if ( display_out == display_one ) begin
				
				$display ( " The display shows value as expected " );
			
			end
			
			else begin
			
				if ( k != 11) begin
					$display (" Error in display, fix it !");
					display_flag = 1;
				end
				
			end
			
			key[1] <= 1'b0;
			#10;
			

		end
	end
	
	// waiting for certain clock cycles
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
		
	if ( z ) begin // To check if the system is in locked state
	
		$display ( " The system is locked as designed ! " ) ; // If locked, sucess message is displayed
		
		if ( lock_disp == display_out ) begin
		
			$display ( " Lock Value displayed correctly ");
		
		end
		
		else begin // Else error message is displayed and display bug flag is set.
		
			$display ( " Error in displaying lock value " );
			display_flag = 1;
		
		end
		
	end
	
	else begin  // Bug flag is set as high, denoting bug in system
	
		$display ( " There is an issue in locking the system " );
		bug_flag = 1;
	
	end 
	
	// Checking if wrong input PIN unlocks the system
	
	$display("");
	$display("");
	$display(" Checking if wrong pin unlocks the system ");
	$display("");
	$display("");
	
	//waiitng for certain clock cycles
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	
	// Wrong sequence is given as input
	
	
	for ( k = 0 ; k < 6 ; k = k+1)begin
	
			clock <= 1'b1;
			key[0] <= 1'b1;
			#10;
			clock <= 1'b0;
			#10;
			key[0] <= 1'b0;
			#10;
	
	end
	
	// Waiting for certain clock cycles
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	
	// entering verification is wrong input unlocked the system
	
			if(z) begin
				if(display_out == wrong_pin) begin // if the system is locked and display is correct, success message is displayed in console
				
					$display ( " Wrong PIN does not unlock the system, and Wrong PIN message is displayed correctly");
					
				end
			end
			else begin
			
				$display("Error in wrong PIN system");
				bug_flag = 1;
			
			end
			
	// Testing unlocking system
	
	$display("");
	$display("");
	$display("Testing Unlocking System");
	$display("");
	$display("");
	
	// Entering the correct PIN input sequence
	
	for ( k=0 ; k<6 ; k=k+1 ) begin
	
		if ( k % 2 == 0 ) begin
		
			
			clock <= 1'b1;
			key[0] <= 1'b1;
			
			
			
			
			#10;
			clock <= 1'b0;
			if ( display_out == display_zero ) begin
				
				$display ( " The display shows value as expected " );
			
			end
			
			else begin
			
				$display (" Error in display, fix it ! ");
				display_flag = 1;
				
			end
			
			key[0] <= 1'b0;
			#10;
			
			
		end
		else begin
		
			
			clock <= 1'b1;
			key[1] <= 1'b1;
						
			#10;
			clock <= 1'b0;
			
			if ( display_out == display_one ) begin
				
				$display ( " The display shows value as expected " );
			
			end
			
			else begin
			
				if ( k != 5) begin
					$display (" Error in display, fix it ! %d ", k);
					display_flag = 1;
					
				end
				
			end
			
			key[1] <= 1'b0;
			#10;
			

		end
	end
	
	// waiting for certain clock cycles
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	
	// checking if the system is unlocked
	
	if (!z ) begin // if the system is unlocked, then success message is displayed on console
	
		$display ( " System Unlocked as expected ! " );
		
		if ( unlock_disp == display_out ) begin
		
			$display ( " UnLock Value displayed correctly ");
		
		end
		
		else begin // if system is remaining locked, then error message is displayed.
		
			$display ( " Error in displaying lock value " );
			display_flag = 1;
		
		end
	
	end
	
	else begin 
	
		$display ( " There is an issue in unlocking the system " );
		bug_flag = 1;
	
	end 
	
	// waiting for certain clock cycles
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	
	// checking if wrong pin during repeat state makes the error signal high
			
	$display("");
	$display("");
	$display(" Checking if Error system works when the system is in unlocked state ");
	$display("");
	$display("");
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	
	// first sequence of input
	
	for ( k=0 ; k<6 ; k=k+1 ) begin
	
		if ( k % 2 == 0 ) begin
		
			
			clock <= 1'b1;
			key[0] <= 1'b1;
			
			
			
			
			#10;
			clock <= 1'b0;
			
			
			key[0] <= 1'b0;
			#10;
			
			
		end
		else begin
		
			
			clock <= 1'b1;
			key[1] <= 1'b1;
						
			#10;
			clock <= 1'b0;
			
	
			
			key[1] <= 1'b0;
			#10;
			

		end
	end
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	
	//Entering the second sequence as " 000000 " 
	
	for(k=0; k<6 ; k=k+1) begin
	
		clock <= 1'b1;
			key[0] <= 1'b1;
			#10;
			clock <= 1'b0;
			key[0] <= 1'b0;
			#10;
	
	end
	
	// entering the PIN wrongly, error should be high and error display should work if the module works properly
	
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
		
	// Checking if the error flag is high
	
		if ( error ) begin
		
			$display ( " Error is Flagged ! , System works as expected " );
			
			//checking if error is displayed in the display
			
			if ( display_out == error_disp ) begin
			
				$display ( " Error is diplayed ! Display works as expected " );
			
			end
			else begin
			
				$display ("Display error, Bug ! Bug ! Fix it !");
				display_flag = 1;
			
			end
		
		end
		else begin
		
			$display ( " Error is not HIGH ! Bug Here ! " );
			bug_flag = 1;
		
		end
		
	// checking if the timeout system works
		
	$display("");
	$display("");
	$display(" Checking if the timeout system works as expected ");
	$display("");
	$display("");
	
	// Checking if the time-out system works
	
	for(k=0;k<51;k = k+1)begin // checking if the system is getting timed_out when no key is pressed
	
		#10;
		clock <= 1'b1;
		#10;
		clock <= 1'b0;
		
	end
	
	if ( display_out != time_out ) begin
		
			$display ( " System is not in time out - Check OK ! ");
		
	end
	else begin
		
		$display ( " Error in time out system " );
		bug_flag = 1;
			
	end
	
	// Now pressing a button and checking is the system has timed out
	
	#10;
	clock <= 1'b1;
	key[0] <= 1'b1;
	#10;
	clock <=1'b0;
	key[0] <= 1'b0;
	for(k=0;k<51;k = k+1)begin // checking if the system is getting timed_out when key is pressed
	
		#10;
		clock <= 1'b1;
		#10;
		clock <= 1'b0;
		
	end
	
	// System should time out now !
	
	$display("");
	$display("Checking if pressing a button times out system");
	$display("");
	
	if ( display_out == time_out ) begin
		
			$display ( " System is in time out - Check OK ! ");
		
	end
	else begin
		
		$display ( " Error in time out system " );
		bug_flag = 1;
			
	end
	
	$display("");
	$display("Checking if the system works after time out");
	$display("");
	
	// waiting for certain clock cycles
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
		
	

	// locking function
	
		for ( k = 0 ; k <  6 ; k = k + 1) begin // to check if the system locks correctly 
	
		if ( k % 2 == 0 ) begin // at even clock cycle key[0] is pressed
		
			
			clock <= 1'b1;
			key[0] <= 1'b1; // key[0] is pressed
			
			
			
			
			#10;
			clock <= 1'b0;
			
			
			key[0] <= 1'b0;
			#10;
			
			
		end
		else begin // at odd clock cycles, key[1] is pressed
		
			
			clock <= 1'b1;
			key[1] <= 1'b1;
						
			#10;
			clock <= 1'b0;
			
			
			
			key[1] <= 1'b0;
			#10;
			

		end
	end
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
		
	// sequence is entered twice and checked if the system is locked

	for ( k = 0 ; k <  6 ; k = k + 1) begin // to check if the system locks correctly 
	
		if ( k % 2 == 0 ) begin // at even clock cycle key[0] is pressed
		
			
			clock <= 1'b1;
			key[0] <= 1'b1; // key[0] is pressed
			
			
			
			
			#10;
			clock <= 1'b0;
			
			
			key[0] <= 1'b0;
			#10;
			
			
		end
		else begin // at odd clock cycles, key[1] is pressed
		
			
			clock <= 1'b1;
			key[1] <= 1'b1;
						
			#10;
			clock <= 1'b0;
			
			
			
			key[1] <= 1'b0;
			#10;
			

		end
	end
	
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
	clock <= 1'b1;
	#10;
	clock <= 1'b0;
	#10;
		

	if ( z ) begin // To check if time out has caused any bugs in the system
		$display ( " Time out system works ! " ) ;
		
		
		
	end
	
	else begin 
	
		$display ( " There is an issue in timeout system " );
		bug_flag = 1;
	
	end 
	
	$display("");
	$display("Okay, I have done the testing ! Let's see if we need any pesticides to weed out the bugs !");
	$display("");
	
	if ( bug_flag ) begin
	
		$display ( "");
		$display(" Bugs Found ! Okay, Lets get to work ! ");
	end
	if ( !bug_flag && !display_flag ) begin
		$display ( "");
		$display(" Hurray !! No Bugs for now ! But stay frosty ! Bugs are not visible, but does not mean they are not there ! ");
	end
	if( display_flag ) begin
		$display ( "");
		$display(" Bugs Found in Display System ! Okay, Lets get to work ! ");
	
	end
	
	
			
	
end

endmodule	