module BitCounter(

input clock,
input reset,
output reg [3:0]count

);

initial begin

count = 4'd0;

end

always @ (posedge clock or posedge reset ) begin

	if ( clock ) begin
	
		
		
	end
	
	else begin
	
		count  = 4'd0;
		
	end
end

endmodule

