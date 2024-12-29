`timescale 1ns / 1ps
module Top_Module_RX (
    input clk,                // System clock
    input reset,              // Reset signal
    input rx_data,            // UART receive data (serial input)
    output [7:0] rhr_data    // Receiver Holding Register (RHR) containing the received data
    );

    // Wires for baud rate generation
   wire rxclk;
	wire debounced_reset;     // Debounced load signal

    // Instantiate Debouncer for reset
    button rst_debouncer (
        .clk(clk),
        .in(reset),
        .out(debounced_reset)
    );
    // Instantiate the Baud Rate Generator
    GenerateBaud baud_gen (
        .clk(clk),
        .rst(debounced_reset),
        .txclk(),
        .rxclk(rxclk)
    );

    // Instantiate the UART Receiver
    Receiver uart_rx (
        .bclk(rxclk),             // Baud rate clock for receiving data
        .reset(debounced_reset),           // Reset signal
        .rx_data(rx_data),       // UART receive data
        .rhr_data(rhr_data)     // Output data register
    );

endmodule
