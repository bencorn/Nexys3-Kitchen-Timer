`timescale 1ns / 1ps

module bcd2vga(
		input [3:0] min0, min1, sec0, sec1,
		output reg [7:0] bcd1, bcd2, bcd3, bcd4
    );

	parameter ZERO = 8'b00111111, //to display 0
				 ONE = 8'b00000110, //to display 1 
				 TWO = 8'b01011011, //to display 2 
				 THREE = 8'b01001111, //to display 3 
				 FOUR = 8'b01100110, //to display 4 
				 FIVE = 8'b01101101, //to display 5 
				 SIX = 8'b01111101, //to display 6 
				 SEVEN = 8'b00000111, //to display 7 
				 EIGHT = 8'b01111111, //to display 8
				 NINE = 8'b01101111, //to display 9
				 DASH = 8'b00111111; // display dash
				 
	 always @ (min0)
			begin
				case(min0)
					4'd0 : bcd1 = ZERO; //to display 0
					4'd1 : bcd1 = ONE; //to display 1
					4'd2 : bcd1 = TWO; //to display 2
					4'd3 : bcd1 = THREE; //to display 3
					4'd4 : bcd1 = FOUR; //to display 4
					4'd5 : bcd1 = FIVE; //to display 5
					4'd6 : bcd1 = SIX; //to display 6
					4'd7 : bcd1 = SEVEN; //to display 7
					4'd8 : bcd1 = EIGHT; //to display 8
					4'd9 : bcd1 = NINE; //to display 9
					default : bcd1 = ZERO; //dash
			  endcase
		  end
		  
	  always @ (min1)
			begin
				case(min1)
					4'd0 : bcd2 = ZERO; //to display 0
					4'd1 : bcd2 = ONE; //to display 1
					4'd2 : bcd2 = TWO; //to display 2
					4'd3 : bcd2 = THREE; //to display 3
					4'd4 : bcd2 = FOUR; //to display 4
					4'd5 : bcd2 = FIVE; //to display 5
					4'd6 : bcd2 = SIX; //to display 6
					4'd7 : bcd2 = SEVEN; //to display 7
					4'd8 : bcd2 = EIGHT; //to display 8
					4'd9 : bcd2 = NINE; //to display 9
					default : bcd2 = ZERO; //dash
			  endcase
		  end
		  
	  always @ (sec0)
			begin
				case(sec0)
					4'd0 : bcd3 = ZERO; //to display 0
					4'd1 : bcd3 = ONE; //to display 1
					4'd2 : bcd3 = TWO; //to display 2
					4'd3 : bcd3 = THREE; //to display 3
					4'd4 : bcd3 = FOUR; //to display 4
					4'd5 : bcd3 = FIVE; //to display 5
					4'd6 : bcd3 = SIX; //to display 6
					4'd7 : bcd3 = SEVEN; //to display 7
					4'd8 : bcd3 = EIGHT; //to display 8
					4'd9 : bcd3 = NINE; //to display 9
					default : bcd3 = ZERO; //dash
			  endcase
		  end
		  
	  always @ (sec1)
			begin
				case(sec1)
					4'd0 : bcd4 = ZERO; //to display 0
					4'd1 : bcd4 = ONE; //to display 1
					4'd2 : bcd4 = TWO; //to display 2
					4'd3 : bcd4 = THREE; //to display 3
					4'd4 : bcd4 = FOUR; //to display 4
					4'd5 : bcd4 = FIVE; //to display 5
					4'd6 : bcd4 = SIX; //to display 6
					4'd7 : bcd4 = SEVEN; //to display 7
					4'd8 : bcd4 = EIGHT; //to display 8
					4'd9 : bcd4 = NINE; //to display 9
					default : bcd4 = ZERO; //dash
			  endcase
		  end

endmodule
