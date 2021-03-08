/* 8-Bit Comparator Module
* ---------------------
* By: Arul Prakash Samathuvamani
*
* University of Leeds - PGT
*
*
* Date : 16th February 2021
*
* Module Description:
* ------------------
*
* Performs 8 Bit Comparision
*/


module Comparator8Bit(
input [7:0]a,
input [7:0]b,
output a_high,
output b_high,
output equal
);

assign a_high = (a > b); // a_high is 1 when a > b
assign b_high = (b>a);   // b_high is 1 when b > a
assign equal = ( a == b) ; // equal is 1 when a == b
