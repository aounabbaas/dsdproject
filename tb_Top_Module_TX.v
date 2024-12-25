`timescale 1ns / 1ps

module tb_Top_Module_TX;

// Testbench signals
reg clk;
reg rst;
reg [1:0] baudsel;
reg [7:0] d_in;
reg load;
wire tx_out;
wire tx_status;

// Instantiate the TopModule
Top_Module_TX uut (
    .clk(clk),
    .rst(rst),
    .baudsel(baudsel),
    .d_in(d_in),
    .load(load),
    .tx_out(tx_out),
    .tx_status(tx_status)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 100 MHz clock (10 ns period)
end

// Testbench sequence
initial begin
    // Initialize signals
    rst = 1;
    baudsel = 2'b00;  // Default to 9600 baud
    d_in = 8'b0;
    load = 0;

    // Reset
    #20;
    rst = 0;

    //Transmit a byte at 9600 baud
    d_in = 8'b00001111;  // Data to transmit
    load = 1;
    #10;
    load = 0;

end

endmodule
