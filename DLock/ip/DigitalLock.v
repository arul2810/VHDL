
/* State Machine Based Digital Lock
* ---------------------
* By: Arul Prakash Samathuvamani
* For: University of Leeds - ELEC5566M Assingment 2
* 
*
* Date : 13th of March 2021
*
* Module Description:
* ------------------
* Digital Lock module that unlocks when correct sequence of PIN is entered. This module file is top-level entity. 
* This model is intended to work only on simulation and Hardware testing has 
* not been completed.
* 
*/



/* 
*     The module is parameterised.
*
*     PARAMETERS OF THE MODEL:
*							PIN_SIZE : Denotes the length of the PIN by default is set to 4.
*							TIME_OUT : Denotes time_out period after which the system is timed out.
*/



// Initialising Module



module DigitalLock #(

 parameter PIN_SIZE = 6,   // Parameter - Length of PIN
 parameter TIME_OUT = 50   // Parameter - Time_out Period

)(

	// Input Signals

	input clock,             // Clock Signal Input
	input reset,             // Reset Signal Input
	input [3:0]key,          // Denotes 4 Keys, Key[0] Key[1] Key[2] and Key[3]
	
	
	// Output Signals
	
	output reg z,				// Output Signal - Is HIGH when locked and LOW when unlocked.
	output reg error,        // Error Signal - high when in unlocked state, repeat PIN is wrong
	output reg [6:0]display_out         // Output Signal to 7-Segment display
	
);

// Registers Declaration 

 reg [(PIN_SIZE*2)-1 : 0 ]pin; // PIN registers stored in UNLOCK_STATE
 reg [(PIN_SIZE*2)-1 : 0 ]pin_reentry; // PIN registers to store pin during second entry in UNLOCK_STATE
 reg [(PIN_SIZE*2)-1 : 0 ]unlock_input; // PIN registers to store pin entered during LOCKED_STATE
 
 integer i; // Local Variable, used to identify the current input index of PIN
 
 reg [3:0]state; // State variable
 
 reg display_flag; // used as return variable for display function
 
 integer flag;
 integer current_index = 0;
 integer time_out_var; // Time Out Calculation variable
 
 
 localparam time_out_period = TIME_OUT; // Local variable equal to number of cycles without input for timeout.
 
 
 function display;

	// Inputs
	
	input[31:0]signal; // Input signal for 7 Segment display
	
	/* If signal is 1 - > Prints 1 denoting key press key[0]
			signal is 2 -> Prints 2 denoting key press key[1]
			Signal is 3 -> Prints 3 denoting key press key[3]
			Signal is 4 -> Prints 4 denoting key press key[4]
			Signal is 5  -> Prints 'E' denoting Error
			Signal is 6 -> Prints 'L' denoting that the system is locked
	 		Signal is 7 -> Prints 'U' denoting that the system is unlocked
			Signal is 8 -> Prints 'P' denoting that the system is locked and Input PIN is wrong
			Signal is 9 -> Prints 'O' denoting that the system has timed out.
			Signal is 10 -> prints 'e' denoting that the pin has repeating elements
		*/
	
	begin
	
	case (signal) 
	
		1 : begin
		
			display_out = 7'b0110000; // Prints 1
			display = 1'b1;
			
		end
		
		2 : begin
		
			display_out = 7'b1011011; // Prints 2
			display = 1'b1;
		end
		
		3 : begin
		
			display_out = 7'b1001111; // Prints 3
			display = 1'b1;
		end
		
		4 : begin
		
			display_out = 7'b1100110; // Prints 4
			display = 1'b1;
		end
		
		5 : begin
		
			display_out = 7'b1111001; // Prints 'E"
			display = 1'b1;
		end
		
		6 : begin
		
			display_out = 7'b0111000; // Prints 'L'
			display = 1'b1;
		end
		
		7 : begin
			
			display_out = 7'b0111110; // Prints 'U'
			display = 1'b1;
		end
		
		8 : begin
			
			display_out = 7'b1110011; // Prints 'P'
			display = 1'b1;
			
		end
		
		9 : begin
		
			display_out = 7'b0111111; // Prints 'O' 
			display = 1'b1;
		end
		
		10 : begin
			
			display_out = 7'b1111011; // Prints 'e'
			display = 1'b1;
		end
		
	endcase
	
	end
	endfunction
	
	
	// States Definition
	
	localparam UNLOCK_STATE = 4'b0000;  // Denotes Unlocked State
	localparam REPEAT_SEQ_STATE = 4'b0001;  // Denotes Repeat Input PIN state
	localparam LOCKED_STATE = 4'b0100; // Denotes locked state 
	localparam LOCKING_STATE = 4'b1100; // State when z is turned HIGH
	localparam UNLOCKING_STATE = 4'b1110; // State when z is turned LOW
	
	// Initialisation of variables 
	
	initial begin 
	
		error = 1'b0;
		z <= 1'b0;
		i = 0;
		display_out = 7'b0000000;
		
	end
	
	// State Output Declaration
	
	always @ (*) begin
	
		case (state)
		
			UNLOCK_STATE : begin
			
				z <= 1'b0;
			
				
			end
			
			REPEAT_SEQ_STATE : begin
				
				z <= 1'b0;
			
			end
			
			LOCKING_STATE : begin
			
				if ( flag ) begin  // When input PIN in first and second sequence match, then output is HIGH, i.e LOCKED 
					
					z <= 1'b1;
					
				end
				else begin   // When input PIN in first and second sequence does not match, then output remains LOW, i.e UNLOCKED 
				
					error <= 1'b1; 
					z <=1'b0;
					
					
				end
				
			end
			
			LOCKED_STATE : begin 
			
				z <= 1'b1;
				
			end
			
			UNLOCKING_STATE : begin
			
			if(flag) begin   // When input PIN matches to the stored PIN then out is LOW, i.e system is unlocked
				
					z <= 1'b0;
					
				end
				else begin
					
					z <= 1'b1; // When input PIN does not match the stored PIN then output is HIGH, ie system remains LOCKED
					
				end
				
			end
			
			default : begin
			
				z <= 1'b0;
				error <= 1'b0;
				
			end
		endcase
	end


	always @ ( posedge clock or posedge reset ) begin
	
		if ( reset ) begin
		
			if ( z ) begin
			
				state <= LOCKED_STATE;
			
			end
			
			if ( !z ) begin
			
				state <= UNLOCK_STATE;
				
			end
		end
		
		else begin
		
		if( time_out_var < time_out_period ) begin// if its below the threshold clock cycles before time out
	
			if(current_index > 0 ) begin // enters the loop only if one key is pressed.
				time_out_var <= time_out_var + 1;
			end
		
		end
		
		if ( time_out_var >= time_out_period  ) begin // if its above the threshold clock cycles the system is timed out , and system is reset to appropriate values
		
			i <= 0;
			current_index <=0;
			display_flag <= display(9); // the signal to be displayed is passed to display function
			time_out_var <= 0;
			if (!z) begin
			
				state <= UNLOCK_STATE;
			
			end
			
		end
	
		
			case ( state ) 
			
				UNLOCK_STATE : begin
				
					if ( i < PIN_SIZE ) begin
					
						if ( key[0] ) begin // If key 0 is pressed
			
							pin[current_index ] <= 1'b0;   // if key 0 is pressed, 00 is stored in the registers.
							pin[current_index+1] <= 1'b0;
							i <= i + 1;			// Current PIN index is increased
							current_index <= current_index + 2;
							display_flag <= display(1); // the value to be displayed is passed to the function
							time_out_var <= 0; //time_out variable is set back to 0
								
																																	  
						end  // end statement for key[0] if loop
						
						if ( key[1] ) begin  // If key 1 is pressed
						
							pin[ current_index ] <= 1'b1 ; // if key 0 is pressed, 01 is stored in the registers.
							pin[current_index + 1] <= 1'b0;
							i <= i + 1; // Current PIN index is increased
							current_index <= current_index + 2;
							display_flag <= display(2);
							time_out_var <= 0; //time_out variable is set back to 0
							
						end // end statement for key[1] if loop
					
						if ( key[2] ) begin  // If key 2 is pressed
						
							pin[ current_index ] <= 1'b0; // if key 0 is pressed, 10 is stored in the registers.
							pin[current_index + 1] <= 1'b1;
							i <= i+ 1;   // current pin index is increased
							current_index <= current_index + 2;
							display_flag <= display(3);
							time_out_var <= 0; //time_out variable is set back to 0
						
						end // end statement for key[2] if loop
						
						if ( key[3] ) begin  // If key 3 is pressed
						
							pin[current_index ] <= 1'b1; // if key 0 is pressed, 11 is stored in the registers.
							pin[current_index + 1] <= 1'b1;
							i <= i+1;  // Current PIN index is increased
							current_index <= current_index + 2;
							display_flag <= display(4);
							time_out_var <= 0; //time_out variable is set back to 0
							
						end // end statement for key[3] if loop
						
					end // end of i < pin_size loop
					
					else begin
					
						i<= 0;
						current_index <=0;
						state <= REPEAT_SEQ_STATE;
						
					end
				end
				
				REPEAT_SEQ_STATE : begin
				
						if ( i < PIN_SIZE ) begin
					
						if ( key[0] ) begin // If key 0 is pressed
			
							pin_reentry[current_index ] <= 1'b0;   // if key 0 is pressed, 00 is stored in the registers.
							pin_reentry[current_index+1] <= 1'b0;
							i <= i + 1;
							current_index <= current_index + 2;
							display_flag <= display(1); // the value to be displayed is passed to the function
							time_out_var <= 0; //time_out variable is set back to 0
								
																																	  
						end  // end statement for key[0] if loop
						
						if ( key[1] ) begin  // If key 1 is pressed
						
							pin_reentry[ current_index ] <= 1'b1 ; // if key 0 is pressed, 01 is stored in the registers.
							pin_reentry[current_index + 1] <= 1'b0;
							i <= i + 1;
							current_index <= current_index + 2;
							display_flag <= display(2);
							time_out_var <= 0; //time_out variable is set back to 0
							
						end // end statement for key[1] if loop
					
						if ( key[2] ) begin  // If key 2 is pressed
						
							pin_reentry[ current_index ] <= 1'b0; // if key 0 is pressed, 10 is stored in the registers.
							pin_reentry[current_index + 1] <= 1'b1;
							i <= i+ 1;
							current_index <= current_index + 2;
							display_flag <= display(3);
							time_out_var <= 0; //time_out variable is set back to 0
						
						end // end statement for key[2] if loop
						
						if ( key[3] ) begin  // If key 3 is pressed
						
							pin_reentry[current_index ] <= 1'b1; // if key 0 is pressed, 11 is stored in the registers.
							pin_reentry[current_index + 1] <= 1'b1;
							i <= i+1;
							current_index <= current_index + 2;
							display_flag <= display(4);
							time_out_var <= 0; //time_out variable is set back to 0
							
						end // end statement for key[3] if loop
						
					end // end of i < pin_size loop
					
					else begin
					
						i<= 0;
						current_index <=0;
						if ( pin == pin_reentry ) begin // If the input PIN in first and second sequence match, then enters the loop.
							
							flag <= 1; // Flag is set high
						end
					
						else begin
							flag <= 0; // Else flag is set low
						end
							state <= LOCKING_STATE;
					end
				end
				

				LOCKING_STATE : begin 
				
					if ( flag ) begin // if flag is high, then system is locked
						display_flag <= display(6); // Lock message is displayed
						
						state <= LOCKED_STATE; // System enters locked state
					end
					if (!flag) begin // if flag is low, then system enters unlock_state, i.e first sequence entry
						state <= UNLOCK_STATE;
						display_flag <= display(5); // Error message is displayed
					end
				end
				
				LOCKED_STATE : begin
				
					if ( i < PIN_SIZE ) begin
					
						if ( key[0] ) begin // If key 0 is pressed
			
							unlock_input[current_index ] <= 1'b0;   // if key 0 is pressed, 00 is stored in the registers.
							unlock_input[current_index+1] <= 1'b0;
							i <= i + 1;
							current_index <= current_index + 2;
							display_flag <= display(1); // the value to be displayed is passed to the function
							time_out_var <= 0; //time_out variable is set back to 0
								
																																	  
						end  // end statement for key[0] if loop
						
						if ( key[1] ) begin  // If key 1 is pressed
						
							unlock_input[ current_index ] <= 1'b1 ; // if key 0 is pressed, 01 is stored in the registers.
							unlock_input[current_index + 1] <= 1'b0;
							i <= i + 1;
							current_index <= current_index + 2;
							display_flag <= display(2);
							time_out_var <= 0; //time_out variable is set back to 0
							
						end // end statement for key[1] if loop
					
						if ( key[2] ) begin  // If key 2 is pressed
						
							unlock_input[ current_index ] <= 1'b0; // if key 0 is pressed, 10 is stored in the registers.
							unlock_input[current_index + 1] <= 1'b1;
							i <= i+ 1;
							current_index <= current_index + 2;
							display_flag <= display(3);
							time_out_var <= 0; //time_out variable is set back to 0
						
						end // end statement for key[2] if loop
						
						if ( key[3] ) begin  // If key 3 is pressed
						
							unlock_input[current_index ] <= 1'b1; // if key 0 is pressed, 11 is stored in the registers.
							unlock_input[current_index + 1] <= 1'b1;
							i <= i+1;
							current_index <= current_index + 2;
							display_flag <= display(4);
							time_out_var <= 0; //time_out variable is set back to 0
							
						end // end statement for key[3] if loop
						
					end // end of i < pin_size loop
					
					else begin
					
						i<= 0;
						current_index <=0;
						if( unlock_input == pin ) begin // If the input PIN matches the PIN entered during locking
				
							flag <= 1; // flag is set high
						end
						else begin 
							flag <= 0; // else, flag is set low
 						end
				
						state <= UNLOCKING_STATE;
						
					end
				end
			
			
			
			UNLOCKING_STATE : begin
			
					if ( flag ) begin // When flag is high, then the system is unlocked.
					
						display_flag <= display(7); // Unlock message is displayed
						
						state <= UNLOCK_STATE; // System enters unlock_state
					end
					if (!flag) begin // When flag is low, then system remains locked because input pin is wrong
					
						display_flag <= display(8); // Wrong pin message is displayed
						state <= LOCKED_STATE;
					end
			end
			default : begin
			
				z <= 1'b0;
				error <= 1'b0;
			end
		endcase
	end
end
endmodule
