`timescale 1ns / 1ps

module Top_Module(input clk, input reset, input start, output done);

	//Wires into Memory
	wire [7:0] read_data;
   wire [7:0] write_data;         
	wire [1:0] matrix_select;
	wire [1:0] row;
   wire [1:0] col;
	wire write_enable;


	 matrix_controller fsm(
    .clk(clk),
    .reset(reset),
    .start(start),
	 .read_data(read_data),
    .done(done),
	 .write_enable(write_enable),
	 .matrix_select(matrix_select), 
	 .row(row), 
	 .col(col),
	 .write_data(write_data)
	);
    
	 Memory mem (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select),
        .row(row),
        .col(col),
        .write_enable(write_enable),
        .write_data(write_data),
        .read_data(read_data)
    );

	 	 

endmodule


