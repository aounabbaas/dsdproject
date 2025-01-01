`timescale 1ns / 1ps

module Memory (
    input clk,
    input reset,
    input [1:0] matrix_select, // Select matrix (0 to 2)
    input [1:0] row,          // Row index (0 to 2)
    input [1:0] col,          // Column index (0 to 2)
    input write_enable,       // Write enable signal
    input [7:0] write_data,   // Data to write
    output reg [7:0] read_data // Data read from memory
);

    // Memory storage for 3 3x3 matrices 
    reg [7:0] memory [2:0][2:0][2:0]; // 3 matrices, each 3x3, with 8-bit data
	 
    // Reset logic to initialize matrices (explicit assignments)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory[0][0][0] <= 8'd0;
            memory[0][0][1] <= 8'd0;
            memory[0][0][2] <= 8'd0;
            memory[0][1][0] <= 8'd0;
            memory[0][1][1] <= 8'd0;
            memory[0][1][2] <= 8'd0;
            memory[0][2][0] <= 8'd0;
            memory[0][2][1] <= 8'd0;
            memory[0][2][2] <= 8'd0;

            memory[1][0][0] <= 8'd0;
            memory[1][0][1] <= 8'd0;
            memory[1][0][2] <= 8'd0;
            memory[1][1][0] <= 8'd0;
            memory[1][1][1] <= 8'd0;
            memory[1][1][2] <= 8'd0;
            memory[1][2][0] <= 8'd0;
            memory[1][2][1] <= 8'd0;
            memory[1][2][2] <= 8'd0;
				
				memory[2][0][0] <= 8'd0;
            memory[2][0][1] <= 8'd0;
            memory[2][0][2] <= 8'd0;
            memory[2][1][0] <= 8'd0;
            memory[2][1][1] <= 8'd0;
            memory[2][1][2] <= 8'd0;
            memory[2][2][0] <= 8'd0;
            memory[2][2][1] <= 8'd0;
            memory[2][2][2] <= 8'd0;
				
        end else if (write_enable) begin
            memory[matrix_select][row][col] <= write_data; // Write data to selected matrix
        end 
		  
    end
	 
	 always @(*)begin
	 	read_data <= memory[matrix_select][row][col];
	 end

endmodule
