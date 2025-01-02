`timescale 1ns / 1ps

module Top_Module(input clk, input reset, input start, input rx_data, output tx_out);

	//for paralled hardware
    wire [7:0] read_data1, read_data2, read_data3, read_data4, read_data5, read_data6, read_data7, read_data8, read_data9, read_data10;
    wire [7:0] uart_read_data1, uart_read_data2, uart_read_data3, uart_read_data4, uart_read_data5, uart_read_data6, uart_read_data7, uart_read_data8, uart_read_data9, uart_read_data10;

    assign uart_read_data1 = read_data1;
    assign uart_read_data2 = read_data2;
    assign uart_read_data3 = read_data3;
    assign uart_read_data4 = read_data4;
    assign uart_read_data5 = read_data5;
    assign uart_read_data6 = read_data6;
    assign uart_read_data7 = read_data7;
    assign uart_read_data8 = read_data8;
    assign uart_read_data9 = read_data9;
    assign uart_read_data10 = read_data10;

    wire [7:0] write_data1, write_data2, write_data3, write_data4, write_data5, write_data6, write_data7, write_data8, write_data9, write_data10;
	 
    wire [7:0] uart_write_data;
    wire [7:0] mac_write_data1, mac_write_data2, mac_write_data3, mac_write_data4, mac_write_data5, mac_write_data6, mac_write_data7, mac_write_data8, mac_write_data9, mac_write_data10;

    wire [3:0] row1, col1, row2, col2, row3, col3, row4, col4, row5, col5, row6, col6, row7, col7, row8, col8, row9, col9, row10, col10;
    wire [3:0] mac_row1, mac_col1, mac_row2, mac_col2, mac_row3, mac_col3, mac_row4, mac_col4, mac_row5, mac_col5, mac_row6, mac_col6, mac_row7, mac_col7, mac_row8, mac_col8, mac_row9, mac_col9, mac_row10, mac_col10;
    wire [3:0] uart_row, uart_col;

    wire uart_write_enable;
    wire write_enable1, write_enable2, write_enable3, write_enable4, write_enable5, write_enable6, write_enable7, write_enable8, write_enable9, write_enable10;
    wire mac_write_enable1, mac_write_enable2, mac_write_enable3, mac_write_enable4, mac_write_enable5, mac_write_enable6, mac_write_enable7, mac_write_enable8, mac_write_enable9, mac_write_enable10;

    wire [1:0] matrix_select1, matrix_select2, matrix_select3, matrix_select4, matrix_select5, matrix_select6, matrix_select7, matrix_select8, matrix_select9, matrix_select10;
    wire [1:0] mac_matrix_select1, mac_matrix_select2, mac_matrix_select3, mac_matrix_select4, mac_matrix_select5, mac_matrix_select6, mac_matrix_select7, mac_matrix_select8, mac_matrix_select9, mac_matrix_select10;
	 wire [1:0] uart_matrix_select;

	 wire done;
    wire done1, done2, done3, done4, done5, done6, done7, done8, done9, done10;
   
    assign done = done1 && done2 && done3 && done4 && done5 && done6 && done7 && done8 && done9 && done10;

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
    assign matrix_select2 = !want ? mac_matrix_select2 : uart_matrix_select;
    assign matrix_select3 = !want ? mac_matrix_select3 : uart_matrix_select;
    assign matrix_select4 = !want ? mac_matrix_select4 : uart_matrix_select;
    assign matrix_select5 = !want ? mac_matrix_select5 : uart_matrix_select;
    assign matrix_select6 = !want ? mac_matrix_select6 : uart_matrix_select;
    assign matrix_select7 = !want ? mac_matrix_select7 : uart_matrix_select;
    assign matrix_select8 = !want ? mac_matrix_select8 : uart_matrix_select;
    assign matrix_select9 = !want ? mac_matrix_select9 : uart_matrix_select;
    assign matrix_select10 = !want ? mac_matrix_select10 : uart_matrix_select;

    assign row1 = !want ? mac_row1 : uart_row;
    assign row2 = !want ? mac_row2 : uart_row;
    assign row3 = !want ? mac_row3 : uart_row;
    assign row4 = !want ? mac_row4 : uart_row;
    assign row5 = !want ? mac_row5 : uart_row;
    assign row6 = !want ? mac_row6 : uart_row;
    assign row7 = !want ? mac_row7 : uart_row;
    assign row8 = !want ? mac_row8 : uart_row;
    assign row9 = !want ? mac_row9 : uart_row;
    assign row10 = !want ? mac_row10 : uart_row;

    assign col1 = !want ? mac_col1 : uart_col;
    assign col2 = !want ? mac_col2 : uart_col;
    assign col3 = !want ? mac_col3 : uart_col;
    assign col4 = !want ? mac_col4 : uart_col;
    assign col5 = !want ? mac_col5 : uart_col;
    assign col6 = !want ? mac_col6 : uart_col;
    assign col7 = !want ? mac_col7 : uart_col;
    assign col8 = !want ? mac_col8 : uart_col;
    assign col9 = !want ? mac_col9 : uart_col;
    assign col10 = !want ? mac_col10 : uart_col;

    assign write_enable1 = !want ? mac_write_enable1 : uart_write_enable;
    assign write_enable2 = !want ? mac_write_enable2 : uart_write_enable;
    assign write_enable3 = !want ? mac_write_enable3 : uart_write_enable;
    assign write_enable4 = !want ? mac_write_enable4 : uart_write_enable;
    assign write_enable5 = !want ? mac_write_enable5 : uart_write_enable;
    assign write_enable6 = !want ? mac_write_enable6 : uart_write_enable;
    assign write_enable7 = !want ? mac_write_enable7 : uart_write_enable;
    assign write_enable8 = !want ? mac_write_enable8 : uart_write_enable;
    assign write_enable9 = !want ? mac_write_enable9 : uart_write_enable;
    assign write_enable10 = !want ? mac_write_enable10 : uart_write_enable;

    assign write_data1 = !want ? mac_write_data1 : uart_write_data;
    assign write_data2 = !want ? mac_write_data2 : uart_write_data;
    assign write_data3 = !want ? mac_write_data3 : uart_write_data;
    assign write_data4 = !want ? mac_write_data4 : uart_write_data;
    assign write_data5 = !want ? mac_write_data5 : uart_write_data;
    assign write_data6 = !want ? mac_write_data6 : uart_write_data;
    assign write_data7 = !want ? mac_write_data7 : uart_write_data;
    assign write_data8 = !want ? mac_write_data8 : uart_write_data;
    assign write_data9 = !want ? mac_write_data9 : uart_write_data;
    assign write_data10 = !want ? mac_write_data10 : uart_write_data;


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
			 .read_data2(uart_read_data2),
			 .read_data3(uart_read_data3),
			 .read_data4(uart_read_data4),
			 .read_data5(uart_read_data5),
			 .read_data6(uart_read_data6),
			 .read_data7(uart_read_data7),
			 .read_data8(uart_read_data8),
			 .read_data9(uart_read_data9),
			 .read_data10(uart_read_data10),
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

    matrix_controller row_2 (
        .clk(clk),
        .reset(reset),
        .start(mac_start),
        .read_data(read_data2),
        .which_row(1),
        .done(done2),
        .write_enable(mac_write_enable2),
        .matrix_select(mac_matrix_select2), 
        .row(mac_row2), 
        .col(mac_col2),
        .write_data(mac_write_data2)
    );

    matrix_controller row_3(
        .clk(clk),
        .reset(reset),
        .start(mac_start),
        .read_data(read_data3), 
        .which_row(2),
        .done(done3),
        .write_enable(mac_write_enable3),
        .matrix_select(mac_matrix_select3), 
        .row(mac_row3), 
        .col(mac_col3),
        .write_data(mac_write_data3)
    );

    matrix_controller row_4 (
        .clk(clk),
        .reset(reset),
        .start(mac_start),
        .read_data(read_data4),
        .which_row(3),
        .done(done4),
        .write_enable(mac_write_enable4),
        .matrix_select(mac_matrix_select4), 
        .row(mac_row4), 
        .col(mac_col4),
        .write_data(mac_write_data4)
    );

    matrix_controller row_5 (
        .clk(clk),
        .reset(reset),
        .start(mac_start),
        .read_data(read_data5),
        .which_row(4),
        .done(done5),
        .write_enable(mac_write_enable5),
        .matrix_select(mac_matrix_select5), 
        .row(mac_row5), 
        .col(mac_col5),
        .write_data(mac_write_data5)
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

    matrix_controller row_7 (
        .clk(clk),
        .reset(reset),
        .start(mac_start),
        .read_data(read_data7),
        .which_row(6),
        .done(done7),
        .write_enable(mac_write_enable7),
        .matrix_select(mac_matrix_select7), 
        .row(mac_row7), 
        .col(mac_col7),
        .write_data(mac_write_data7)
    );

    matrix_controller row_8 (
        .clk(clk),
        .reset(reset),
        .start(mac_start),
        .read_data(read_data8),
        .which_row(7),
        .done(done8),
        .write_enable(mac_write_enable8),
        .matrix_select(mac_matrix_select8), 
        .row(mac_row8), 
        .col(mac_col8),
        .write_data(mac_write_data8)
    );

    matrix_controller row_9 (
        .clk(clk),
        .reset(reset),
        .start(mac_start),
        .read_data(read_data9),
        .which_row(8),
        .done(done9),
        .write_enable(mac_write_enable9),
        .matrix_select(mac_matrix_select9), 
        .row(mac_row9), 
        .col(mac_col9),
        .write_data(mac_write_data9)
    );

    matrix_controller row_10 (
        .clk(clk),
        .reset(reset),
        .start(mac_start),
        .read_data(read_data10),
        .which_row(9),
        .done(done10),
        .write_enable(mac_write_enable10),
        .matrix_select(mac_matrix_select10), 
        .row(mac_row10), 
        .col(mac_col10),
        .write_data(mac_write_data10)
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

    Memory shared_memory2 (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select2),
        .row(row2),
        .col(col2),
        .write_enable(write_enable2),
        .write_data(write_data2),
        .read_data(read_data2)
    );

    Memory shared_memory3 (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select3),
        .row(row3),
        .col(col3),
        .write_enable(write_enable3),
        .write_data(write_data3),
        .read_data(read_data3)
    );

    Memory shared_memory4 (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select4),
        .row(row4),
        .col(col4),
        .write_enable(write_enable4),
        .write_data(write_data4),
        .read_data(read_data4)
    );

    Memory shared_memory5 (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select5),
        .row(row5),
        .col(col5),
        .write_enable(write_enable5),
        .write_data(write_data5),
        .read_data(read_data5)
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

    Memory shared_memory7 (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select7),
        .row(row7),
        .col(col7),
        .write_enable(write_enable7),
        .write_data(write_data7),
        .read_data(read_data7)
    );

    Memory shared_memory8 (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select8),
        .row(row8),
        .col(col8),
        .write_enable(write_enable8),
        .write_data(write_data8),
        .read_data(read_data8)
    );

    Memory shared_memory9 (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select9),
        .row(row9),
        .col(col9),
        .write_enable(write_enable9),
        .write_data(write_data9),
        .read_data(read_data9)
    );

    Memory shared_memory10 (
        .clk(clk),
        .reset(reset),
        .matrix_select(matrix_select10),
        .row(row10),
        .col(col10),
        .write_enable(write_enable10),
        .write_data(write_data10),
        .read_data(read_data10)
    );

    
endmodule



