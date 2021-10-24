module DFlipFlop(

input d,
input reset,
input clock,
output reg q
);

always @ ( posedge clock or posedge reset ) begin

	if (reset) begin
		q <= 1'b0;
		end
	else begin
		q <= d;
		end
	end
endmodule

