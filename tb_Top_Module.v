`timescale 1ns / 1ps

module tb_Top_Module;

    // Inputs
    reg clk;
    reg reset;
    reg start;
    reg rx_data;

    // Outputs
    wire tx_out;


    // Internal Signals
    wire bclk;

    // Instantiate the Unit Under Test (UUT)
    Top_Module uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .rx_data(rx_data),
        .tx_out(tx_out)
    );

    // Instantiate the Baud Generator
    GenerateBaud baud_gen (
        .clk(clk),
        .rst(reset),
        .bclk(bclk)
    );

     // Clock Generation
    always #5 clk = ~clk; // 100 MHz clock

    // Test Variables
    reg [9:0] data_to_send [0:17]; // Array to hold 18 bytes of data
    integer i, j;

	 reg [9:0] sampled_data;  // To store a complete received frame
    integer bit_index;       // Bit index for sampling
    reg [7:0] received_data [0:17]; // Array to store received bytes
    integer received_count;  // Counter for received bytes
    
	 
	 initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        start = 0;
        rx_data = 1;

    // Initialize Data with Start and Stop Bits
    data_to_send[0] = {1'b1, 8'd5, 1'b0}; // Stop, 8-bit data, Start
    data_to_send[1] = {1'b1, 8'd4, 1'b0};
    data_to_send[2] = {1'b1, 8'd3, 1'b0};
    data_to_send[3] = {1'b1, 8'd2, 1'b0};
    data_to_send[4] = {1'b1, 8'd1, 1'b0};
    data_to_send[5] = {1'b1, 8'd2, 1'b0};
    data_to_send[6] = {1'b1, 8'd3, 1'b0};
    data_to_send[7] = {1'b1, 8'd4, 1'b0};
    data_to_send[8] = {1'b1, 8'd3, 1'b0};
    data_to_send[9] = {1'b1, 8'd2, 1'b0};
    data_to_send[10] = {1'b1, 8'd1, 1'b0};
    data_to_send[11] = {1'b1, 8'd2, 1'b0};
    data_to_send[12] = {1'b1, 8'd3, 1'b0};
    data_to_send[13] = {1'b1, 8'd4, 1'b0};
    data_to_send[14] = {1'b1, 8'd5, 1'b0};
    data_to_send[15] = {1'b1, 8'd8, 1'b0};
    data_to_send[16] = {1'b1, 8'd6, 1'b0};
    data_to_send[17] = {1'b1, 8'd7, 1'b0};


        // Reset the system
        #20; reset = 0;

        // Start sending data
        #10; start = 1; #10; start  = 0;
			for (i = 0; i < 18; i = i + 1) begin
				 for (j = 0; j < 10; j = j + 1) begin
					  @(posedge bclk); // Wait for bclk rising edge
					  rx_data = data_to_send[i][j]; // Send one bit at a time
				 end
			end

			
        // Wait for alldone signal
        #100;
		  rx_data = 1;
		  start = 0;
        $display("Transmission complete.");
		
		$display("Start receiving...");
        bit_index = 0;
        received_count = 0;
        sampled_data = 10'b0;

			while (received_count < 18) begin
			@(posedge bclk); // Keep waiting until tx_out goes low (start bit detected)
			if(tx_out == 0)begin
				sampled_data[0] = 0;
		  for (i = 1; i < 10; i = i + 1) begin
				@(posedge bclk)sampled_data[i] = tx_out;    
        end 
			
           received_data[received_count] = sampled_data[8:1]; // Extract 8-bit data
           received_count = received_count + 1;
                $display("Received byte %0d: %0d", received_count, sampled_data[8:1]);
            end
        end
	
        $display("Reception complete.");

        // Display all received data
        for (i = 0; i < 18; i = i + 1) begin
            $display("Received data[%0d]: %0d", i, received_data[i]);
        end
    end   
endmodule
