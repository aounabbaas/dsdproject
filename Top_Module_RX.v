`timescale 1ns / 1ps
module Top_Module_RX (
    input clk,                // System clock
    input reset,              // Reset signal
    input rx_data,            // UART receive data (serial input)
    output [7:0] rhr_data,    // Receiver Holding Register (RHR) containing the received data
    output data_ready         // Data ready signal
);

    // Wires for baud rate generation
    wire txclk;
    wire rxclk;

    // Instantiate the Baud Rate Generator
    GenerateBaud baud_gen (
        .clk(clk),
        .rst(reset),
        .txclk(txclk),
        .rxclk(rxclk)
    );

    // Instantiate the UART Receiver
    Receiver uart_rx (
        .bclk(rxclk),             // Baud rate clock for receiving data
        .reset(reset),           // Reset signal
        .rx_data(rx_data),       // UART receive data
        .rhr_data(rhr_data),     // Output data register
        .data_ready(data_ready)  // Data ready signal
    );

endmodule
