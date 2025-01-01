`timescale 1ns / 1ps

module Top_Module(input clk, input reset, input start, input rx_data, output tx_out);
wire [7:0] read_data;
   wire [7:0] write_data;         
	wire [1:0] matrix_select;
	wire [1:0] row;
   wire [1:0] col;
	wire write_enable;
	
	wire [7:0] rhr_data;
	wire done;
	wire [7:0] rx_data_ready;
	wire tx_load;
	wire [7:0] tx_out_data;
	
	wire bclk;
	wire mac_start;
	wire want;
   wire [1:0] uart_matrix_select;
   wire [1:0] uart_row;
   wire [1:0] uart_col;
   wire uart_write_enable;
   wire [7:0] uart_write_data;

	wire [1:0] mac_matrix_select;
   wire [1:0] mac_row;
	wire [1:0] mac_col;
   wire mac_write_enable;
	wire [7:0] mac_write_data;
	
	wire [7:0] tx_count;
	
	wire tx_status;

assign matrix_select = !want ? mac_matrix_select : uart_matrix_select;
assign row = !want ? mac_row : uart_row;
assign col = !want ? mac_col : uart_col;
assign write_enable = !want ? mac_write_enable : uart_write_enable;
assign write_data = !want ? mac_write_data : uart_write_data;


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
			 .read_data(read_data),
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


	 matrix_controller fsm(
    .clk(clk),
    .reset(reset),
    .start(mac_start),
	 .read_data(read_data),
    .done(done),
	 .write_enable(mac_write_enable),
	 .matrix_select(mac_matrix_select), 
	 .row(mac_row), 
	 .col(mac_col),
	 .write_data(mac_write_data)
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
    
endmodule



