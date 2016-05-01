`timescale 1ns / 1ps

module vga_clock(
	input wire clk,		//master clock: 100MHz
	input wire clr,		//asynchronous reset
	output wire dclk,		//pixel clock: 25MHz
	output wire segclk	//7-segment clock: 381.47Hz
	);

	// 18-bit counter variable
	reg [17:0] q;

	// Clock divider --
	// Each bit in q is a clock signal that is
	// only a fraction of the master clock.
	always @(posedge clk or posedge clr)
	begin
		// reset condition
		if (clr == 1)
			q <= 0;
		// increment counter by one
		else
			q <= q + 1;
	end

	// 100Mhz ÷ 2^17 = 381.47Hz
	assign segclk = q[17];

	// 100Mhz ÷ 2^1 = 25MHz
	assign dclk = q[1];

endmodule
