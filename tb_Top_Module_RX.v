`timescale 1ns / 1ps

module tb_Top_Module_RX;

    // Testbench signals
    reg clk;                      // System clock
    reg reset;                    // Reset signal
    reg rx_data;                  // UART receive data (serial input)
    reg [1:0] baudsel;            // Baud rate selection (to GenerateBaud)
    wire [7:0] rhr_data;          // Receiver Holding Register (RHR) containing the received data
    wire data_ready;              // Data ready signal

    // Clock generation
    always begin
        #5 clk = ~clk;  // 100 MHz clock
    end
    // Instantiate the GenerateBaud module to generate bclk
    GenerateBaud baudgen (
        .clk(clk),
        .rst(reset),
        .baudsel(baudsel),
        .txclk(),  // Not needed for this testbench, so we leave it unconnected
        .rxclk(bclk) // Connect rxclk to the testbench's bclk signal
    );

    // Instantiate the top module
    Top_Module_RX uut (
        .clk(clk),
        .reset(reset),
        .rx_data(rx_data),
        .baudsel(baudsel),
        .rhr_data(rhr_data),
        .data_ready(data_ready)
    );

    // Test stimulus
  initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        rx_data = 1;  // Start with idle state (high)
        baudsel = 2'b00;  // Set baud rate to 9600
        
        // Apply reset
        reset = 1;
        #10 reset = 0;

        // Wait for the baud rate clock (bclk) to stabilize
        @(posedge bclk);  // Wait for the first rising edge of bclk

        // Simulate receiving data
        // Start bit (low)
        rx_data = 0;
        @(posedge bclk);  // Wait for the next bclk cycle to sample the start bit

        // Send 8 data bits (e.g., 8'b10101010)
        rx_data = 1; @(posedge bclk);  // Bit 1
        rx_data = 0; @(posedge bclk);  // Bit 2
        rx_data = 1; @(posedge bclk);  // Bit 3
        rx_data = 0; @(posedge bclk);  // Bit 4
        rx_data = 1; @(posedge bclk);  // Bit 5
        rx_data = 0; @(posedge bclk);  // Bit 6
        rx_data = 1; @(posedge bclk);  // Bit 7
        rx_data = 0; @(posedge bclk);  // Bit 8
        
        // Stop bit (high)
        rx_data = 1;
        @(posedge bclk);  // Wait for one more cycle to complete the stop bit

        // Check output
        #10;

        
        // End simulation
        $finish;
    end

endmodule
