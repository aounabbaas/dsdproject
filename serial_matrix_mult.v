`timescale 1ns / 1ps

module Calculator (
    input [53:0] A,  // 3x3 matrix A, 6-bit elements each (total 54 bits)
    input [53:0] B,  // 3x3 matrix B, 6-bit elements each (total 54 bits)
    output reg [53:0] Result  // Result of the multiplication, 3x3 matrix, 72 bits
);

    reg [5:0] A1 [0:2][0:2];  // 3x3 matrix A, 6-bit elements
    reg [5:0] B1 [0:2][0:2];  // 3x3 matrix B, 6-bit elements
    reg [5:0] Res1 [0:2][0:2]; // Resultant 3x3 matrix, each element is 6 bits
    
    integer i, j, k;

    always @ (A or B) begin
        // Convert the 1D input arrays into 2D arrays
        {A1[0][0], A1[0][1], A1[0][2], A1[1][0], A1[1][1], A1[1][2], A1[2][0], A1[2][1], A1[2][2]} = A;
        {B1[0][0], B1[0][1], B1[0][2], B1[1][0], B1[1][1], B1[1][2], B1[2][0], B1[2][1], B1[2][2]} = B;

        // Initialize the result matrix to zero
        Res1[0][0] = 12'd0; Res1[0][1] = 12'd0; Res1[0][2] = 12'd0;
        Res1[1][0] = 12'd0; Res1[1][1] = 12'd0; Res1[1][2] = 12'd0;
        Res1[2][0] = 12'd0; Res1[2][1] = 12'd0; Res1[2][2] = 12'd0;

        // Matrix multiplication: Res1[i][j] = sum(A1[i][k] * B1[k][j] for k=0 to 2)
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                for (k = 0; k < 3; k = k + 1) begin
                    Res1[i][j] = Res1[i][j] + (A1[i][k] * B1[k][j]);
                end
            end
        end

        // Convert the 2D result matrix back to 1D output (72 bits)
        Result = {Res1[0][0], Res1[0][1], Res1[0][2], Res1[1][0], Res1[1][1], Res1[1][2], Res1[2][0], Res1[2][1], Res1[2][2]};
    end

endmodule

