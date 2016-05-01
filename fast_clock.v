`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Clock divider for any 100 Mhz FPGA board. Outputs a ~5.96 Hz clock.

//////////////////////////////////////////////////////////////////////////////////
module fast_clock(clk, fhz, reset);
    input wire clk;  // clock: 100Mhz
    input wire reset;
    output wire fhz; // 5.96 Hz
    
    // 24-bit counter variable
    reg [23:0] count; // clock divider counter
    
    // clk div counter
    always @ (posedge clk, posedge reset) 
    begin
            if (reset) count <= 0;

            // increment counter by one
            else count <= count + 1;
            
    end
    
    // 100Mhz (1e+8) ÷ 2^24 = 5.96
    assign fhz = count[23];


endmodule