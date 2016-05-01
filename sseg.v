module sseg #(
	parameter X=0,
	parameter Y=0,	
	parameter W=100,
	parameter H=200	
)(
	input wire [7:0] bcd,
	input wire [9:0] x,
	input wire [9:0] y,
	output wire [2:0] r,	
	output wire [2:0] g,	
	output wire [2:0] b);

parameter VLD=(W/4); //vertical line depth    |
parameter HLD=(H/7); //horisontal line depth  --
parameter MID=(H/2); //MID line

parameter hVLD=(VLD/2); //vertical line depth /2
parameter hHLD=(HLD/2); //horisontal line depth /2

wire A,B,C,D,E,F,G,DP;
assign {DP, G, F, E, D, C, B, A} = bcd;

wor [2:0] line;
	
assign r = 3'b000;
assign g = line;
assign b = 3'b000;

wire [2:0] line_A = ( ( x >= ( X )) && 
                      ( x <= ( X + W ) )&&
                      ( y >= ( Y ) ) && 
							 ( y <= ( Y + HLD ) ) && 
							 ( A ) ) ? 3'b111: 3'b000;

wire [2:0] line_D = ( ( x >= ( X )) && 
                      ( x <= ( X + W ) )&&
                      ( y >= ( Y + H - HLD) ) && 
							 ( y <= ( Y + H ) ) && 
							 ( D ) ) ? 3'b111: 3'b000;

wire [2:0] line_G = ( ( x >= ( X ) ) && 
                      ( x <= ( X + W ) )&&
                      ( y >= ( Y + MID - hVLD ) ) && 
							 ( y <= ( Y + MID + hVLD ) ) && 
							 ( G ) ) ? 3'b111: 3'b000;
							 
wire [2:0] line_F = ( ( x >= ( X ) ) && 
                      ( x <= ( X + VLD ) )&&
                      ( y >= ( Y ) ) && 
							 ( y <= ( Y + MID + hVLD ) ) && 
							 ( F ) ) ? 3'b111: 3'b000;							 

wire [2:0] line_E = ( ( x >= ( X ) ) && 
                      ( x <= ( X + VLD ) )&&
                      ( y >= ( Y + MID - hVLD ) ) && 
							 ( y <= ( Y + H ) ) && 
							 ( E ) ) ? 3'b111: 3'b000;							 

wire [2:0] line_B = ( ( x >= ( X + W - VLD ) ) && 
                      ( x <= ( X + W ) )&&
                      ( y >= ( Y ) ) && 
							 ( y <= ( Y + MID + hVLD ) ) && 
							 ( B ) ) ? 3'b111: 3'b000;							 
							 
wire [2:0] line_C = ( ( x >= ( X + W - VLD ) ) && 
                      ( x <= ( X + W ) )&&
                      ( y >= ( Y + MID - hVLD ) ) && 
							 ( y <= ( Y + H ) ) && 
							 ( C ) ) ? 3'b111: 3'b000;							 
							 
wire [2:0] line_DP = ( ( x >= ( X + W + hHLD  ) ) && 
                      ( x <= ( X + W + hHLD + HLD  ) )&&
                      ( y >= ( Y + H - VLD ) ) && 
							 ( y <= ( Y + H ) ) && 
							 ( DP ) ) ? 3'b111: 3'b000;							 
							 
							 
assign line = line_A;
assign line = line_D;
assign line = line_G;
assign line = line_F;
assign line = line_E;
assign line = line_B;
assign line = line_C;
assign line = line_DP;
assign line = 3'b000;
					  	  
endmodule
