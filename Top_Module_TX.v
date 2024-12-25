`timescale 1ns / 1ps
`timescale 1ns / 1ps

module Top_Module_TX(
    input clk,               // System clock
    input rst,               // Reset signal
    input [1:0] baudsel,     // Baud rate selection
    input [7:0] d_in,        // 8-bit parallel data input
    input load,              // Load signal to load data
    output tx_out,           // Serial data output
    output tx_status         // Transmitter status
);

// Internal signals
wire txclk;                 // Transmitter baud clock
wire rxclk;                 // Receiver baud clock (not used here)

// Instantiate GenerateBaud module
GenerateBaud baud_generator (
    .clk(clk),
    .rst(rst),
    .baudsel(baudsel),
    .txclk(txclk),
    .rxclk(rxclk)
);

// Instantiate Transmitter_FSM module
Transmitter transmitter (
    .bclk(txclk),            // Connect the generated baud clock
    .reset(rst),
	 .d_in(d_in),
    .load(load),
    .tx_out(tx_out),
    .tx_status(tx_status)
);

endmodule
