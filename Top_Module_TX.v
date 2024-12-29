`timescale 1ns / 1ps

module Top_Module_TX(
    input clk,               // System clock
    input rst,               // Reset signal
    input [7:0] d_in,        // 8-bit parallel data input
    input load,              // Load signal to load data
    output tx_out,           // Serial data output
    output tx_status         // Transmitter status
);

// Internal signals
wire txclk;                 // Transmitter baud clock
wire rxclk;                 // Receiver baud clock (not used here)
wire debounced_rst;      // Debounced reset signal
wire debounced_load;     // Debounced load signal

    // Instantiate Debouncer for reset
    button rst_debouncer (
        .clk(clk),
        .in(rst),
        .out(debounced_rst)
    );

    // Instantiate Debouncer for load
    button load_debouncer (
        .clk(clk),
        .in(load),
        .out(debounced_load)
    );
// Instantiate GenerateBaud module
GenerateBaud baud_generator (
    .clk(clk),
    .rst(debounced_rst),
    .txclk(txclk),
    .rxclk(rxclk)
);

// Instantiate Transmitter_FSM module
Transmitter transmitter (
    .bclk(txclk),            // Connect the generated baud clock
    .reset(debounced_rst),
	 .d_in(d_in),
    .load(debounced_load),
    .tx_out(tx_out),
    .tx_status(tx_status)
);

endmodule


