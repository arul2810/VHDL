module pixelbuffer (

	input clock,
	
	input pixel_ready,
	
	input [15:0] input_pixel,
	
	output reg pixel_check,
	
	output reg [15:0] output_pixel
	
);


reg [7:0] x_address;
reg [8:0] y_address;


 LT24Input Display(


	// clock input
	
	.clock(clock),
	
	// input reset
	
	.reset (reset),
	
	.xAddr (x_address),
	
	.yAddr (y_address),
	
	.pixel (output_pixel),
	
	.pixelReady (pixel_check),
	
	// debug
	
	.debug (debug),
	
	.LT24Wr_n (LT24Wr_n),
	.LT24RD_n(LT24RD_n),
	.LT24CS_n(LT24CS_n),
	.LT24RS(LT24RS),
	.LT24ResetLT24Data_n(LT24Reset_n),
	.LT24Data( ),
	.LT24LCDOn(LT24LCDOn)
	
	

	
);


initial begin

	x_address = 8'b0;
	y_address = 9'b0;
	pixel_check = 1'b0;
	//add_change = 1'b0;
	
end

always @ (posedge clock ) begin

	if(pixel_ready) begin
	
		output_pixel <= input_pixel;
		pixel_check <= 1'b1;
		//add_change <= 1'b1;
	
	end
	
	else begin
	
		pixel_check <= 1'b0;
		if ( x_address < 240 ) begin
		
			x_address <= x_address + 1;
			//add_change <= 1'b0;
			
		end
		
		else begin
		
			if ( y_address < 320 ) begin
			
				x_address <= 8'b0;
				y_address <= y_address + 1;
				//add_change <= 1'b0;
				
			end 
			
			else begin
			
				x_address <= 8'b0;
				y_address <= 9'b0;
				//add_change <= 1'b0;
				
			end
			
	end 
		
	end
	
end



endmodule 
	