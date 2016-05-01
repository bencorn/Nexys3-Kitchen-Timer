`timescale 1ns / 1ps

module display(
    input sclk, // ~ 800 Hz display clk
	 input reset, // active high rst
	 input [3:0] dleft, dmidleft, dmidright, dright, // 4 bit binary input 20:20
	 output reg[6:0] seg, // 7 segment output
	 output dp, // decimal point -> not used
	 output reg [3:0] an // anode output
	 );
	 
	reg [6:0] s_temp; // temp binary value of each input
	reg [1:0] state; // initial state
	
	// FSM states for anodes
	parameter left = 2'b00;
	parameter midleft = 2'b01;
	parameter midright = 2'b10;
	parameter right = 2'b11;
	
	// segment = {g,f,e,d,c,b,a};
	// 0 means ON and 1 means OFF

	// Seven Segment Cathode Parameters
	parameter ZERO = 7'b1000000, //to display 0
				 ONE = 7'b1111001, //to display 1
				 TWO = 7'b0100100, //to display 2
				 THREE = 7'b0110000, //to display 3
				 FOUR = 7'b0011001, //to display 4
				 FIVE = 7'b0010010, //to display 5
				 SIX = 7'b0000010, //to display 6
				 SEVEN = 7'b1111000, //to display 7
				 EIGHT = 7'b0000000, //to display 8
				 NINE = 7'b0010000, //to display 9
				 DASH = 7'b1111111; // display dash

	//assign anode = an_temp;
   //assign seg = sseg_temp;
   assign dp = 1'b1;
		
	// disp_cycle high when new cycle 
		
	always @ (posedge sclk or posedge reset) begin
		if (reset) begin
				//sseg_temp <= 7'd0; // holds binary value of each input
				// PREVIOUS CODE: seg <= 7'b1111111; CHANGED TO: s_temp <= 7'b1111111;
				s_temp <= 7'b1111111;  // 7 bit register to hold data output 
				an <= 4'b1111; // register to hold 4 bit anode enable
				state <= left; // initial state
			end
		else
			begin
				case(state) // divider MSB's used for case
					left:
						begin
							s_temp <= dleft;
							an <= 4'b0111;
							state <= midleft;
						end
					midleft:
						begin
							s_temp <= dmidleft;
							an <= 4'b1011;
							state <= midright;
						end
					midright:
						begin
							s_temp <= dmidright;
							an <= 4'b1101;
							state <= right;
						end
					right:
						begin
							s_temp <= dright;
							an <= 4'b1110;
							state <= left;
						end
				endcase
			end
		end
					
		// for timer implementation
		always @ (*)
			begin
				case(s_temp)
					4'd0 : seg = ZERO; //to display 0
					4'd1 : seg = ONE; //to display 1
					4'd2 : seg = TWO; //to display 2
					4'd3 : seg = THREE; //to display 3
					4'd4 : seg = FOUR; //to display 4
					4'd5 : seg = FIVE; //to display 5
					4'd6 : seg = SIX; //to display 6
					4'd7 : seg = SEVEN; //to display 7
					4'd8 : seg = EIGHT; //to display 8
					4'd9 : seg = NINE; //to display 9
					default : seg = DASH; //dash
					//PREVIOUS CODE: s_temp = DASH; CHANGED TO: seg = DASH;
			  endcase
		  end
	  
endmodule