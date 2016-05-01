// Framework from FPGA4FUN.

module pb_debouncer(
    input clk, // 100Mhz
    input dirty,  // "PB" is the glitchy, asynchronous to clk, active low push-button signal
	 input reset, // Debounced reset signal

    // from which we make three outputs, all synchronous to the clock
    output reg PB_state,  // 1 as long as the push-button is active (down)
    output PB_down,  // 1 for one clock cycle when the push-button goes down (i.e. just pushed)
    output PB_up   // 1 for one clock cycle when the push-button goes up (i.e. just released)
	);

	// First use two flip-flops to synchronize the PB signal to the "clk" clock domain
	reg PB_sync_0;  always @(posedge clk) PB_sync_0 <= ~dirty;  // invert PB to make PB_sync_0 active high
	reg PB_sync_1;  always @(posedge clk) PB_sync_1 <= PB_sync_0;

	// 20-bit register for 100Mhz clock
	reg PB_cnt; // 19:0

	wire PB_idle = (PB_state==PB_sync_1);
	wire PB_cnt_max = &PB_cnt;	// true when all bits of PB_cnt are 1's

	always @(posedge clk, posedge reset)
	// taking care of reset state
	if (reset) begin
		PB_cnt <= 0;
		PB_state <= 0;
	end
	else if(PB_idle)
		 PB_cnt <= 0;  // waiting for user input
	else
	begin
		 PB_cnt <= PB_cnt + 20'd1;  // something's going on, increment the counter
		 if(PB_cnt_max) PB_state <= ~PB_state;  // if the counter is maxed out, PB changed!
	end

	// assigning outputs from logic
	assign PB_down = ~PB_idle & PB_cnt_max & ~PB_state; // active and maxed
	assign PB_up   = ~PB_idle & PB_cnt_max &  PB_state; // active and released
	
endmodule