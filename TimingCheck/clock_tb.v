
`timescale 1 ns/ 100 ps

module clock_tb;



reg clock;

reg clock2;


clock dut(

.clock1 ( clock ),
.clock2 ( clock2 )

);

integer k;

initial begin

for( k = 0; k < 2 ; k =k+ 1 ) begin

	clock <= 1'b1;
	#20;
	clock <= 1'b0;
	#20;
	
end

for ( k=0 ; k < 2 ; k =k+ 1 ) begin


	clock2 <= 1'b1;
	#40;
	clock2 <= 1'b0;
	#40;
	
end

end 

endmodule
