`timescale 1ns / 1ps

// Testbench for MatrixMemory module

module Memory_tb;

    reg clk;
    reg reset;
    reg [1:0] matrix_select;
    reg [1:0] row;
    reg [1:0] col;
    reg write_enable;
    reg [7:0] write_data;
    wire [7:0] read_data;

    Memory uut (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select),
        .row(row),
        .col(col),
        .write_enable(write_enable),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Test procedure

initial begin
    // Initialize inputs
    reset = 1;
    matrix_select = 0;
    row = 0;
    col = 0;
    write_enable = 0;
    write_data = 0;


    // Apply reset
    #10;
    reset = 0;

    // Write data to Matrix 0
    write_enable = 1;
    matrix_select = 0;
    row = 0; col = 0; write_data = 8'd1; #10;
    row = 0; col = 1; write_data = 8'd2; #10;
    row = 0; col = 2; write_data = 8'd3; #10;
    row = 1; col = 0; write_data = 8'd4; #10;
    row = 1; col = 1; write_data = 8'd5; #10;
    row = 1; col = 2; write_data = 8'd6; #10;
    row = 2; col = 0; write_data = 8'd7; #10;
    row = 2; col = 1; write_data = 8'd8; #10;
    row = 2; col = 2; write_data = 8'd9; #10;

    // Disable write enable
    write_enable = 0;

    // Read back data from Matrix 0
    matrix_select = 0;

    row = 0; col = 0; #10; #10; // Wait one clock cycle
    $display("Matrix 0 [0][0] = %d", read_data);
    row = 0; col = 1; #10; #10;
    $display("Matrix 0 [0][1] = %d", read_data);
    row = 0; col = 2; #10; #10;
    $display("Matrix 0 [0][2] = %d", read_data);
    row = 1; col = 0; #10; #10;
    $display("Matrix 0 [1][0] = %d", read_data);
    row = 1; col = 1; #10; #10;
    $display("Matrix 0 [1][1] = %d", read_data);
    row = 1; col = 2; #10; #10;
    $display("Matrix 0 [1][2] = %d", read_data);
    row = 2; col = 0; #10; #10;
    $display("Matrix 0 [2][0] = %d", read_data);
    row = 2; col = 1; #10; #10;
    $display("Matrix 0 [2][1] = %d", read_data);
    row = 2; col = 2; #10; #10;
    $display("Matrix 0 [2][2] = %d", read_data);

    // Finish simulation
    $stop;
end

endmodule
