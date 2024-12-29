`timescale 1ns / 1ps

module mac (
    input wire clk,
    input wire reset,
    input wire [7:0] in_a,       // 8-bit Input A
    input wire [7:0] in_b,       // 8-bit Input B
    input wire accumulate,       // Control signal: Accumulate or not
    output reg [7:0] mac_out    // 16-bit Output (Accumulated or raw product)
);

    // Internal signal for the multiplication result
    wire [15:0] mult_result;

    // Perform multiplication
    assign mult_result = in_a * in_b;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mac_out <= 8'b0; // Reset output to 0
        end else if (accumulate) begin
            mac_out <= mac_out + mult_result; // Accumulate result
        end else begin
            mac_out <= mult_result; // Output raw multiplication result
        end
    end
endmodule
