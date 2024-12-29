`timescale 1ns / 1ps

module mac_tb;
    // Inputs
    reg clk;
    reg reset;
    reg [7:0] in_a;
    reg [7:0] in_b;
    reg accumulate;

    // Output
    wire [7:0] mac_out;

    // Instantiate the MAC module
    mac uut (
        .clk(clk),
        .reset(reset),
        .in_a(in_a),
        .in_b(in_b),
        .accumulate(accumulate),
        .mac_out(mac_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        in_a = 0;
        in_b = 0;
        accumulate = 0;

        // Wait for reset to clear
        #10 reset = 0;

        // Test 1: Multiply without accumulation
        #10 in_a = 8'd3; in_b = 8'd4; accumulate = 0; // Output: 12
        #10 in_a = 8'd5; in_b = 8'd2;                // Output: 10

        // Test 2: Multiply and accumulate
        #10 accumulate = 1; in_a = 8'd6; in_b = 8'd3; // Accumulate: 18
        #10 in_a = 8'd2; in_b = 8'd2;                // Accumulate: 18 + 4 = 22

        // Test 3: Disable accumulation
        #10 accumulate = 0; in_a = 8'd7; in_b = 8'd8; // Output: 56, no accumulation

        // Test 4: Reset
        #10 reset = 1; #10 reset = 0;                 // Reset output to 0

        #20 $stop;
    end
endmodule
