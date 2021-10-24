module LT24Input (


	// clock input
	
	input clock,
	
	// input reset
	
	input reset,
	
	input [15:0] pixel,
	
	input pixelReady,
	
	// debug
	
	output debug,
	
	// Interface for LT24Display.v -> following outputs is fed into LT24Display.v
	
	output LT24Wr_n,
	output LT24RD_n,
	output LT24CS_n,
	output LT24RS,
	output LT24Reset_n,
	output [15:0] LT24Data,
	output LT24LCDOn
	
);


// Input Pixel RGB Values

//wire pixelReady;
reg pixelWrite;
reg [15:0] pixelvalue;
wire ready;


// LCD Size 

localparam LCD_WIDTH = 240;
localparam LCD_HEIGHT = 320;


// LT24Display module is being called

LT24Display #(
    .WIDTH       (LCD_WIDTH  ),
    .HEIGHT      (LCD_HEIGHT ),
    .CLOCK_FREQ  (50000000   )
) DisplayIn (
    //Clock and Reset In
    .clock       (clock      ),
    .globalReset (reset),
    //Reset for User Logic
    //.resetApp    (reset   ),
    //Pixel Interface
    .xAddr       (xAddr      ),
    .yAddr       (yAddr      ),
    .pixelData   (pixelvalue  ),
    .pixelWrite  (pixelWrite ),
    .pixelReady  (ready ),
    //Use pixel addressing mode
    .pixelRawMode(1'b0       ),
    //Unused Command Interface
    .cmdData     (8'b0       ),
    .cmdWrite    (1'b0       ),
    .cmdDone     (1'b0       ),
    .cmdReady    (           ),
    //Display Connections
    .LT24Wr_n    (LT24Wr_n   ),
    .LT24Rd_n    (LT24Rd_n   ),
    .LT24CS_n    (LT24CS_n   ),
    .LT24RS      (LT24RS     ),
    .LT24Reset_n (LT24Reset_n),
    .LT24Data    (LT24Data   ),
    .LT24LCDOn   (LT24LCDOn  )
);


// Declaration of states


localparam STATE_1 = 2'b00;
localparam STATE_2 = 2'b01;
localparam STATE_3 = 2'b10;
localparam STATE_4 = 2'b11;


reg [1:0] STATE = 2'b00;


// Register for addresses

reg [7:0] xAddr = 8'b0 ;
reg [8:0] yAddr = 9'b0;

// Addresses are incremented in second state




// Working part of the module



always @ (posedge clock) begin



	case (STATE)
	
	
		STATE_1 : begin 
		
			if ( pixelReady && ready) begin
			
				pixelWrite <= 1'b1;
				//ready <= 1'b1;
				pixelvalue <=  pixel ;
				STATE <= STATE_2;
			
			end
			
		end
		
		STATE_2 : begin
		
			if ( xAddr < 240 ) begin
				
				xAddr <= xAddr + 1'b1;
				STATE <= STATE_3;
				
			
			end
			
			else if ( yAddr < 320 ) begin
			
				yAddr <= yAddr + 1'b1;
				xAddr <= 8'b0;
				STATE <= STATE_3;
				
			end
			
			else begin
			
				yAddr <= 9'b0;
				xAddr <= 8'b0;
				STATE <= STATE_3;
				
			end
		
		end
		
		STATE_3 : begin
		
			STATE <= STATE_4;
			
		end
		
		STATE_4 : begin
		
			STATE <= STATE_1;
			
		end
		
	endcase
					
	
end


endmodule