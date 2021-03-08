/* 1- Bit Adder Module
* ---------------------
* By: Arul Prakash Samathuvamani
*
*
*
* Date : 8th March 2021
*
* Module Description:
* ------------------
*
* Performs Procedural Comparator.	
*/

module ProceduralComparator(

input [7:0]a,
input [7:0]b,
output reg a_high, // Wires inside procedural block should have reg data type.
output reg b_high,
output reg equal
);


always @ *  begin  

  // Do not use assign for Reg ! ! 

 a_high = ( a > b ) ; // a_high is 1 when a > b

 b_high = ( b > a ); // b_high is 1 when b >a 

 equal = ( b == a  );  // when a -- b , equal is high

end 

endmodule 