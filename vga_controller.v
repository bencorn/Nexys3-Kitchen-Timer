`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module vga_controller(
	input wire dclk,			//pixel clock: 25MHz 
	input wire clr,			//asynchronous reset
	
	input wire [7:0] bcd1,  // bcd1 indicator
	input wire [7:0] bcd2,  // bcd2 indicator
	input wire [7:0] bcd3,  // bcd3 indicator
	input wire [7:0] bcd4,  // bcd4 indicator
	
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc; initial hc <= 10'd0;
reg [9:0] vc; initial vc <= 10'd0;

initial begin
	red <= 3'd0;
	green <= 3'd0;
	blue <= 2'd0;
end

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1'b1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1'b1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire


assign hsync = (hc < hpulse) ? 1'b0:1'b1;
assign vsync = (vc < vpulse) ? 1'b0:1'b1;

wire [9:0] x_pos = hc - hbp;
wire [9:0] y_pos = vc - vbp;

wor [2:0] r_val, g_val, b_val;

wor [2:0] r_seg1, g_seg1, b_seg1;
wor [2:0] r_seg2, g_seg2, b_seg2;
wor [2:0] r_seg3, g_seg3, b_seg3;
wor [2:0] r_seg4, g_seg4, b_seg4;

assign {r_val,g_val,b_val} = {r_seg1,g_seg1,b_seg1};
assign {r_val,g_val,b_val} = {r_seg2,g_seg2,b_seg2};
assign {r_val,g_val,b_val} = {r_seg3,g_seg3,b_seg3};
assign {r_val,g_val,b_val} = {r_seg4,g_seg4,b_seg4};


// Displaying SSEG from decoder on VGA
sseg #(
	.X(25),
	.Y(0),	
	.W(60),
	.H(160)	
) seg1 (
	.bcd(bcd1),
	.x(x_pos), 
   .y(y_pos),
	.r(r_seg1), 
	.g(g_seg1), 
	.b(b_seg1)
);

sseg #(
	.X(195),
	.Y(0),	
	.W(60),
	.H(160)	
) seg2 (
	.bcd(bcd2),
	.x(x_pos), 
   .y(y_pos),
	.r(r_seg2), 
	.g(g_seg2), 
	.b(b_seg2)
);

sseg #(
	.X(355),
	.Y(0),	
	.W(60),
	.H(160)	
) seg3 (
	.bcd(bcd3),
	.x(x_pos), 
   .y(y_pos),
	.r(r_seg3), 
	.g(g_seg3), 
	.b(b_seg3)
);

sseg #(
	.X(505),
	.Y(0),	
	.W(60),
	.H(160)	
) seg4 (
	.bcd(bcd4),
	.x(x_pos), 
   .y(y_pos),
	.r(r_seg4), 
	.g(g_seg4), 
	.b(b_seg4)
);

always @(*)
begin
	// first check if we're within vertical active video range
	if (vc >= vbp && vc < vfp)
	begin
		red = r_val;
		green = g_val;
		blue = b_val[2:1];		
	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
	
end

endmodule
