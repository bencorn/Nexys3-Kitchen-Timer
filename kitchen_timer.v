`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Kitchen Timer Top Module for EC 311 at Boston University.
// Interfaces with the Nexys3 FPGA on a 100 Mhz Clock.

// Contains primitive VGA output with synced 7 segment output.
// Maximum time output is 59:59. If the clock is counting up,
// the time will roll back around and start again from 00:00.

// If the clock is counting down, it will count down to 00:00 and the
// status LED will come on awaiting the next input from the user.

// Second and minutes are set from six of the switches on the Nexys3.
// Left pushbutton sets the minutes | right pushbutton sets the seconds.
// Center pushbutton starts the timer | bottom pushbutton pauses and unpauses.
// Top pushbutton resets the timer, seven segment, and VGA output to 00:00.

// Engineered by: Benjamin Corn - Boston University College of Engineering - Class of 2018

//////////////////////////////////////////////////////////////////////////////////

module kitchen_timer(
	input clk, // 100 Mhz Nexys3 clk V10
	input rst, // global rst
	input pause, // pause time
	input start, // start time
	input enable, // 0 -> down | 1 -> up
	input min_button, // load min
	input sec_button, // load sec
	input speed_switch, // 0 -> 1 Hz | 1 -> 5 Hz
	input [5:0] time_in, // 6 bit bin
	output led, // status signal led
	output [6:0] seg, // cathode
	output [3:0] an, // anode
	output dp, // decimal
	output hsync, vsync, // rgb sync
	output [2:0] red, green, // rgb
	output [1:0] blue // rgb
    );
	 
	wire [5:0] sec_out, min_out;
	
	////////////////////////////////
	
	//     5 Hz Clock Divider     //
	
	fast_clock fast_clock(
		.clk(clk),
		.reset(rst),
		.fhz(fhz)
	);
	
	////////////////////////////////
	
	//        DEBOUNCING          //
	 	
	// db pause
	pb_debouncer pause_db(
		.clk(fhz),
		.dirty(pause),
		.reset(rst),
		.PB_up(pause_deb)
		);
		
		
	//////////////////////////////////

	//         TIMER MODULE         //
	timer timer_module(
		.clk(fhz), 
		.reset(rst),
		.pause(pause_deb),
		.start(start),
		.enable(enable),
		.time_in(time_in),
		.min_button(min_button),
		.sec_button(sec_button),
		.speed_switch(speed_switch),
		.led(led),
		.min_out(min_out),
		.sec_out(sec_out)
	);
	
	//////////////////////////////////
	
	//        DISPLAY MODULE        //
	
	wire [3:0] sec0, sec1, min0, min1;
		
	display_integrator display_driver(
		.clk(clk),
		.reset(rst),
		.min_out(min_out),
		.sec_out(sec_out),
		.seg(seg),
		.an(an),
		.dp(dp),
		.sec0(sec0),
		.sec1(sec1),
		.min0(min0),
		.min1(min1)
	);

	//////////////////////////////////
	
	//        BIN 2 SSEG VGA        //
	
	wire [7:0] bcd1, bcd2, bcd3, bcd4;
	
	bcd2vga decoder(
		.min0(min0),
		.min1(min1),
		.sec0(sec0),
		.sec1(sec1),
		.bcd1(bcd1),
		.bcd2(bcd2),
		.bcd3(bcd3),
		.bcd4(bcd4)
	);
	
	//////////////////////////////////
	
	//       VGA 25 Mhz Clock       //
	
	vga_clock vga_clock(
		.clk(clk),
		.clr(rst),
		.dclk(dclk),
		.segclk(segclk)
	);
	
	//////////////////////////////////
	
	//          VGA DRIVER          //
	
	vga_controller vga_driver(
		.dclk(dclk),
		.clr(rst),
		.bcd1(bcd1),
		.bcd2(bcd2),
		.bcd3(bcd3),
		.bcd4(bcd4),
		.hsync(hsync),
		.vsync(vsync),
		.red(red),
		.green(green),
		.blue(blue)
	);
	
	//////////////////////////////////
	

endmodule
