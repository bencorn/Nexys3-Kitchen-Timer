//`timescale 1ms / 1ns
`timescale 1ns / 1ps

module timer(
	input clk,
   input reset,
	input pause,
	input start,
	input enable, //for the up/down enabler
	input [5:0] time_in,
	input min_button,
	input sec_button,
	input speed_switch,
	output reg led,
	output [5:0] min_out,  //maximum timer output is 59 111011
	output [5:0] sec_out  //maximum timer output is 59 111011
);

reg [2:0] state, next_state;
reg [2:0] state_reg, state_reg_next;
reg [2:0] clkspeed_count, clkspeed_count_next;
reg [5:0] sec_count, sec_count_next;			
reg [5:0] min_count, min_count_next;
reg [5:0] counter_sec, counter_sec_next;		
reg rst_sync_d1, rst_sync_d2;
reg [5:0] sec_deb, min_deb;

//state names
parameter RESET_STATE = 0,
  DOWN_COUNTER_SLOW = 1,
  DOWN_COUNTER_FAST = 2,
  UP_COUNTER_SLOW = 3,
  UP_COUNTER_FAST = 4,
  PAUSE_STATE = 5;

//---------------------------------------------------------- 
// NOTE: Reset is ACTIVE-HIGH
//----------------------------------------------------------

//Positive edge detect of the pause signal
reg pause_reg2, pause_deb;

always @ (posedge clk or posedge reset) begin
	if (reset == 1) begin
		pause_reg2 <= 0;
	end
	else begin
		pause_reg2 <= pause;
	end	
end
always @ (posedge clk or posedge reset) begin
	if (reset == 1) begin
		pause_deb <= 0;
	end
	else if ((pause == 1) && (pause_reg2 == 0)) begin //detects a posedge
		pause_deb <= 1;
	end
	else begin
		pause_deb <= 0;
	end	
end

// Store sec and min inputs when the second button and the minute button are pressed, respectively
always @ (posedge clk, posedge reset) begin
	  if (reset == 1) begin
			sec_deb <= 0;
			min_deb <= 0;
	  end
	  // in rst state & sec load
	  else if (state == RESET_STATE) begin
			if (sec_button == 1) begin
				sec_deb <= time_in;
			end
		
			// in rst state & min load
			else if (min_button == 1) begin
				min_deb <= time_in;
			end
	  end
	  else if (!min_button && !sec_button && !RESET_STATE) begin
			sec_deb <= sec_deb;
			min_deb <= min_deb;
	  end
end

// FSM of the Up/Down Counter
always @ (posedge clk or posedge reset) begin
  if (reset == 1) begin
   state <= RESET_STATE;
	sec_count <= 0;
	counter_sec <= 0;
	state_reg <= 0;
	min_count <= 0;
	sec_count <= 0;
  end
  else begin
	state <= next_state;
	sec_count <= sec_count_next;
	min_count <= min_count_next;
	counter_sec <= counter_sec_next;
	state_reg <= state_reg_next;
  end
end	
  
always @ (*) begin
  next_state = state;
  clkspeed_count_next = clkspeed_count;
  sec_count_next = sec_count; 
  min_count_next = min_count;
  counter_sec_next = counter_sec;
  
  case (state)
	RESET_STATE: begin
		if (min_button) begin
			min_count_next = min_deb;
		end
		if (sec_button) begin
			counter_sec_next = sec_deb;
		end
		if (start == 1) begin
			if ((speed_switch == 1) && (enable == 1)) begin
				next_state = UP_COUNTER_FAST;
				state_reg_next = UP_COUNTER_FAST;
				min_count_next = min_deb;
				sec_count_next = sec_deb;
				counter_sec_next = sec_deb;
			end
			else if ((speed_switch == 1) && (enable == 0)) begin
				next_state = DOWN_COUNTER_FAST;
				state_reg_next = DOWN_COUNTER_FAST;
				min_count_next = min_deb;
				sec_count_next = sec_deb;
				counter_sec_next = sec_deb;
			end
			else if ((speed_switch == 0) && (enable == 1)) begin
				next_state = UP_COUNTER_SLOW;
				state_reg_next = UP_COUNTER_SLOW;
				min_count_next = min_deb;
				sec_count_next = sec_deb;
				counter_sec_next = sec_deb;
			end
			else begin  //if ((speed_switch_deb == 0) && (enable_deb == 0))
				next_state = DOWN_COUNTER_SLOW;
				state_reg_next = DOWN_COUNTER_SLOW;
				min_count_next = min_deb;
				sec_count_next = sec_deb;
				counter_sec_next = sec_deb;
			end
		end
		else begin
			next_state = RESET_STATE;
			state_reg_next = RESET_STATE;
		end
	end
	
	DOWN_COUNTER_SLOW: begin					// Down Counter at 1Hz	
		if (reset == 1) begin
			next_state = RESET_STATE;
		end
		else if (pause_deb == 1) begin		// pause posedge is detected
			next_state = PAUSE_STATE;
		end
		else begin
		next_state = DOWN_COUNTER_SLOW;
			if (clkspeed_count == 5) begin
				if (sec_count > 0) begin
					sec_count_next = sec_count - 1;
					counter_sec_next = sec_count - 1;
				end
				// check to see if counter is done when min && sec are zero
				else if (counter_sec == 0) begin
					if ((counter_sec == 0) && (min_count == 0)) begin  // timer is done
						next_state = RESET_STATE;
						counter_sec_next = 0;
					end
					else begin
						// if seconds wero zero but not min -> decrement min && set sec to zero
						min_count_next = min_count - 1;
						counter_sec_next = 59;
						sec_count_next = 0;
					end	
				end
				else begin
					
					counter_sec_next = counter_sec - 1;
					sec_count_next = 0;
					min_count_next = min_count;
				end
			end
			else begin
				counter_sec_next = counter_sec;
				min_count_next = min_count;
				sec_count_next = sec_count;
			end
		end
	end
	
	DOWN_COUNTER_FAST: begin					// Down Counter at 5Hz	
		if (reset == 1) begin
			next_state = RESET_STATE;
		end
		else if (pause_deb == 1) begin		// pause posedge is detected
			next_state = PAUSE_STATE;
		end
		else begin
			next_state = DOWN_COUNTER_FAST;
			if (sec_count > 0) begin
				sec_count_next = sec_count - 1;
				counter_sec_next = sec_count - 1;
			end
			else if (counter_sec == 0) begin
				if ((counter_sec == 0) && (min_count == 0)) begin  // timer is done
					next_state = RESET_STATE;
					counter_sec_next = 0;
				end
				else begin
					min_count_next = min_count - 1;
					counter_sec_next = 59;
					sec_count_next = 0;
				end	
			end
			else begin
				counter_sec_next = counter_sec - 1;
				sec_count_next = 0;
				min_count_next = min_count;
			end
		end	
	end
	
	UP_COUNTER_SLOW: begin					// Up Counter at 1Hz	
		if (reset == 1) begin
			next_state = RESET_STATE;
		end
		else if (pause_deb == 1) begin		// pause posedge is detected
			next_state = PAUSE_STATE;
		end
		else begin
			next_state = UP_COUNTER_SLOW;
			if (clkspeed_count == 5) begin	// Check if 1sec has passed
				if (counter_sec == 59) begin
					if (min_count == 59) begin
						min_count_next = 0;
						counter_sec_next = 0;
					end
					else begin
						min_count_next = min_count + 1;
						counter_sec_next = 0;
					end
				end
				else begin
					counter_sec_next = counter_sec + 1;
					min_count_next = min_count;
				end
			end
			else begin
				counter_sec_next = counter_sec;
				min_count_next = min_count;
				sec_count_next = sec_count;
			end
		end
	end
	
	UP_COUNTER_FAST: begin					// Up Counter at 5Hz	
		if (reset == 1) begin
			next_state = RESET_STATE;
		end
		else if (pause_deb == 1) begin		// pause posedge is detected
			next_state = PAUSE_STATE;
		end
		else begin
			next_state = UP_COUNTER_FAST;
			if (counter_sec == 59) begin
				if (min_count == 59) begin
					min_count_next = 0;
					counter_sec_next = 0;
				end
				else begin
					min_count_next = min_count + 1;
					counter_sec_next = 0;
				end
			end
			else begin
				counter_sec_next = counter_sec + 1;
				min_count_next = min_count;
			end
		end
	end
	
	PAUSE_STATE: begin
		if (reset == 1) begin 
			next_state = RESET_STATE;
		end
		else if (pause_deb == 1) begin		// pause posedge is detected
			next_state = state_reg;
		end
		else begin
			sec_count_next = sec_count;
			counter_sec_next = counter_sec;
			min_count_next = min_count;
			next_state = PAUSE_STATE;
		end
	end
	default: begin
		next_state = state;
	end
  endcase
  
  
end  

// Counter for 1Hz Counter (Slow)
always @ (negedge clk or posedge reset) begin
	if (reset == 1) begin
		clkspeed_count = 0;
	end
	else begin
		if (state == PAUSE_STATE) begin
			clkspeed_count = clkspeed_count;
		end
		else if ((state == DOWN_COUNTER_SLOW) || (state == UP_COUNTER_SLOW)) begin
			if (clkspeed_count == 5) begin
				clkspeed_count = 1;
			end
			else begin
				clkspeed_count = clkspeed_count + 1;
			end
		end
		else begin
			clkspeed_count = 0;
		end
	end
end

// Logic for LED output signal
always @(posedge clk or posedge reset) begin
	if (reset == 1) begin
		led = 0;
	end
	else if ((state == DOWN_COUNTER_SLOW) && (next_state == RESET_STATE)) begin
		led = 1;
	end
	else if ((state == DOWN_COUNTER_FAST) && (next_state == RESET_STATE)) begin
		led = 1;
	end
	else if ((sec_button == 1) || (min_button == 1)) begin
		led = 0;
	end
	else begin
		led = led;
	end
end


// assign output signals 
assign min_out = min_count;
assign sec_out = counter_sec;

endmodule


