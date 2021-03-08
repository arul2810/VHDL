/* Hexadecimal to 7 Segment Encoder
* ---------------------
* By: Arul Prakash Samathuvamani
* For: University of Leeds 
* 
*
* Date : 5th March
*
* Module Description:
* ------------------
*  Hexadecimal to 7 Segment Verilog Procedural Block	
* 
*/


module HexTo7Segment(

input [3:0]hex,  // 4-bit hexadecimal input


output reg [6:0]seg

);

initial begin // Assigns the value during the initialisation of block.

seg[0] = 0 ;
seg[1] = 0 ;
seg[2] = 0 ;
seg[3] = 0 ;
seg[4] = 0 ;
seg[5] = 0 ;
seg[6] = 0 ;

end 



always @ * begin  // Runs when ever the value of hex changes		

case (hex) // Case statement runs when hex is equal to foolowing constant
		
	4'h1 : begin
		seg[0] = 0;
	seg[1] = 1;
	seg[2] = 1;
	seg[3] = 0;
	seg[4] = 0;
	seg[5] = 0;
	seg[6] = 0;

	end
	
	4'h2 : begin
		
	seg[0] = 1;
	seg[1] = 1;
	seg[2] = 0;
	seg[3] = 1;
	seg[4] = 1;
	seg[5] = 0;
	seg[6] = 1;
	
	end
	
	4'h3 : begin
	
	seg[0] = 1;
	seg[1] = 1;
	seg[2] = 1;
	seg[3] = 1;
	seg[4] = 0;
	seg[5] = 0;
	seg[6] = 1;
	
	end
	
	4'h4 : begin
	
	seg[0] = 0;
	seg[1] = 1;
	seg[2] = 1;
	seg[3] = 0;
	seg[4] = 0;
	seg[5] = 1;
	seg[6] = 1;
	
	end

	4'h5 : begin
	
	seg[0] = 1;
	seg[1] = 0;
	seg[2] = 1;
	seg[3] = 1;
	seg[4] = 0;
	seg[5] = 1;
	seg[6] = 1;
	
	end
	
	4'h6 : begin
	
	seg[0] = 1;
	seg[1] = 0;
	seg[2] = 1;
	seg[3] = 1;
	seg[4] = 1;
	seg[5] = 1;
	seg[6] = 1;
	
	end

	4'h7 : begin
	
	seg[0] = 1;	
	seg[1] = 1;	
	seg[2] = 1;
	seg[3] = 0;
	seg[4] = 0;
	seg[5] = 0;
	seg[6] = 0;
	
	end
	
	4'h8 : begin
	
	seg[0] = 1;
	seg[1] = 1;
	seg[2] = 1;
	seg[3] = 1;
	seg[4] = 1;
	seg[5] = 1;
	seg[6] = 1;
	
	end
	
	4'h9 : begin 
	
	seg[0] = 1;	
	seg[1] = 1;
	seg[2] = 1;
	seg[3] = 1;
	seg[4] = 0;
	seg[5] = 1;
	seg[6] = 1;
	
	end
	
	4'hA : begin 
	
	seg[0] = 1;
	seg[1] = 1;
	seg[2] = 1;
	seg[3] = 0;
	seg[4] = 1;
	seg[5] = 1;
	seg[6] = 1;
	
	end
	
	4'hB : begin 
	
	seg[0] = 0;
	seg[1] = 0;
	seg[2] = 1;
	seg[3] = 1;
	seg[4] = 1;
	seg[5] = 1;
	seg[6] = 1;
	
	end
	
	4'hC : begin
	
	seg[0] = 1;
	seg[1] = 0;
	seg[2] = 0;
	seg[3] = 1;
	seg[4] = 1;
	seg[5] = 1;
	seg[6] = 0;
	
	end
	
	4'hD : begin
	
	seg[0] = 0;
	seg[1] = 1;
	seg[2] = 1;
	seg[3] = 1;
	seg[4] = 1;
	seg[5] = 0;
	seg[6] = 1;
	
	end
	
	4'hE : begin
	
	seg[0] = 1;
	seg[1] = 0;
	seg[2] = 0;
	seg[3] = 1;
	seg[4] = 1;
	seg[5] = 1;
	seg[6] = 1;
	
	end
	
	4'hF : begin 
	
	seg[0] = 1;
	seg[1] = 0;
	seg[2] = 0;
	seg[3] = 0;
	seg[4] = 1;
	seg[5] = 1;
	seg[6] = 1;
	
	end
	
	default : begin
	
	seg[0] = 0 ;
	seg[1] = 0 ;
	seg[2] = 0 ;
	seg[3] = 0 ;
	seg[4] = 0 ;
	seg[5] = 0 ;
	seg[6] = 0 ;
	
	end

	
	
	endcase

	end

endmodule	