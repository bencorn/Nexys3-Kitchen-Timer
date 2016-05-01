`timescale 1ns / 1ps

// Display driver clock divider module.
// Steps down 100 Mhz Nexys3 clock to ~ 800 Hz.

module clkdiv(clk,sclk, reset);
	input wire clk;  // clock: 100Mhz
	input wire reset;
	output wire sclk; // 7-segment clock: 762.9Hz
	
	// 17-bit counter variable
	reg [16:0] count; // clock divider counter
	
	// clk div counter
	always @ (posedge clk, posedge reset) 
	begin
			if (reset) count <= 0;
	
			// increment counter by one
			else count <= count + 1;
			
	end
	
	// 100Mhz (1e+8) ÷ 2^17 = 762.9Hz
	assign sclk = count[16];


endmodule
