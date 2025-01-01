`timescale 1ns / 1ps

module Top_Module(input clk, input reset, input start, input rx_data, output tx_out);

	//for paralled hardware
    wire [7:0] read_data1, read_data6;
    wire [7:0] uart_read_data1, uart_read_data6;

    assign uart_read_data1 = read_data1;
    assign uart_read_data6 = read_data6;

    wire [7:0] write_data1, write_data6;
	 
    wire [7:0] uart_write_data;
    wire [7:0] mac_write_data1, mac_write_data6;

    wire [3:0] row1, col1, row6, col6;
    wire [3:0] mac_row1, mac_col1, mac_row6, mac_col6;
    wire [3:0] uart_row, uart_col;

    wire uart_write_enable;
    wire write_enable1, write_enable6;
    wire mac_write_enable1, mac_write_enable6;

    wire [1:0] matrix_select1, matrix_select6;
    wire [1:0] mac_matrix_select1, mac_matrix_select6;
	 wire [1:0] uart_matrix_select;

	 wire done;
    wire done1, done6;
   
    assign done = done1 && done6;

	wire [7:0] rhr_data;
	wire [7:0] rx_data_ready;
	wire tx_load;
	wire [7:0] tx_out_data;
	
	wire bclk;
	wire mac_start;
	wire want;
		
	wire [7:0] tx_count;
	wire tx_status;

    assign matrix_select1 = !want ? mac_matrix_select1 : uart_matrix_select;
    assign matrix_select6 = !want ? mac_matrix_select6 : uart_matrix_select;

    assign row1 = !want ? mac_row1 : uart_row;
    assign row6 = !want ? mac_row6 : uart_row;

    assign col1 = !want ? mac_col1 : uart_col;
    assign col6 = !want ? mac_col6 : uart_col;

    assign write_enable1 = !want ? mac_write_enable1 : uart_write_enable;
    assign write_enable6 = !want ? mac_write_enable6 : uart_write_enable;

    assign write_data1 = !want ? mac_write_data1 : uart_write_data;
    assign write_data6 = !want ? mac_write_data6 : uart_write_data;

    Receiver uart_rx (
        .bclk(bclk),             // Baud rate clock for receiving data
        .reset(reset),           // Reset signal
        .rx_data(rx_data),       // UART receive data
        .rhr_data(rhr_data),     // Output data register
        .data_ready(rx_data_ready)  // Data ready signal
    );

		GenerateBaud baud_generator (
			 .clk(clk),
			 .rst(reset),
			 .bclk(bclk)
		);

		UART getandsend(
			 .clk(clk),
			 .reset(reset),
			 .start(start),
			 .rhr_data(rhr_data),
			 .read_data1(uart_read_data1),
			 .read_data6(uart_read_data6),
			 .done(done),
			 .rx_data_ready(rx_data_ready),
			 .tx_load(tx_load),
			 .tx_out_data(tx_out_data),
			 .write_enable(uart_write_enable),
			 .write_data(uart_write_data),
			 .matrix_select(uart_matrix_select),
			 .col(uart_col),
			 .row(uart_row),
			 .mac_start(mac_start),
			 .want(want),
			 .tx_count(tx_count)
		);
		
			Transmitter transmitter (
			 .bclk(bclk),            // Connect the generated baud clock
			 .reset(reset),
			 .d_in(tx_out_data),
			 .load(tx_load),
			 .tx_out(tx_out),
			 .tx_status(),
			 .tx_count(tx_count)
		);

    // Instantiate matrix_controller for row computations
    matrix_controller row_1 (
        .clk(clk),
        .reset(reset),
        .start(mac_start),
        .read_data(read_data1), 
        .which_row(0),
        .done(done1),
        .write_enable(mac_write_enable1),
        .matrix_select(mac_matrix_select1), 
        .row(mac_row1), 
        .col(mac_col1),
        .write_data(mac_write_data1)
    );
	 
    matrix_controller row_6 (
        .clk(clk),
        .reset(reset),
        .start(mac_start),
        .read_data(read_data6),
        .which_row(5),
        .done(done6),
        .write_enable(mac_write_enable6),
        .matrix_select(mac_matrix_select6), 
        .row(mac_row6), 
        .col(mac_col6),
        .write_data(mac_write_data6)
    );



    Memory shared_memory1 (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select1),
        .row(row1),
        .col(col1),
        .write_enable(write_enable1),
        .write_data(write_data1),
        .read_data(read_data1)
    );

    Memory shared_memory6 (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select6),
        .row(row6),
        .col(col6),
        .write_enable(write_enable6),
        .write_data(write_data6),
        .read_data(read_data6)
    );


    
endmodule



