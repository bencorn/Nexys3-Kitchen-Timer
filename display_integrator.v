`timescale 1ns / 1ps

module display_integrator(
	input clk,
	input reset,
	input [5:0]min_out, // 6 bit input from timer
	input [5:0]sec_out, // 6 bit input from timer
	output [6:0] seg, // 7 segment output
	output dp, // decimal point -> not used
	output [3:0] an, // anode output
	output [3:0] sec0, sec1, min0, min1
);

	//clkdiv module 100 Mhz - 800 Hz
	wire sclk; // 7-segment clock: 762.9Hz
	clkdiv sub_clkdiv(
		.clk(clk),
		.reset(reset),
		.sclk(sclk));

	//binary2BCD conversion through magic math

	assign sec0 = sec_out / 10; // tens place
	assign sec1 = sec_out % 10; // ones place
	assign min0 = min_out / 10; // tens place
	assign min1 = min_out % 10; // ones place
		
	//display module
	display sub_display(
		.sclk(sclk), // 800 Hz
		.reset(reset), // active high
		.dleft(min0), // X0:00
		.dmidleft(min1), // 0X:00
		.dmidright(sec0), // 00:X0
		.dright(sec1), // 00:0X
		.seg(seg), // 1111111
		.dp(dp), // 1
		.an(an)); // 1111
		
	endmodule