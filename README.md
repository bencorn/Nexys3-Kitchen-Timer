# Nexys3 Kitchen Timer
EC311 final project at Boston University. Full implementation of a kitchen timer in Verilog for Nexys3 100 Mhz FPGA.

# Timer Features
Count up to 59:59 with automatic roll-over to 00:00 to continue counting up.
Count down from 59:59 to 00:00 -> status LED when timer done and awaiting user input.
Pause and unpause at any time during timer operation.
Full reset of timer, seven segment, and VGA display.
Fast count at 5 Hz (5 / second) and normal count at 1 Hz (1 / seconds).
VGA output module of the timer display + synced seven segment display.
Debounced pushbutton support.

# What's included
Everything you need to have a timer going on your Nexys3 FPGA or 100 Mhz equivalent FPGA.
Will work on any FPGA, you'll just need to adjust the dividers.
