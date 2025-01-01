`timescale 1ns / 1ps

module UART(
    input clk,
    input reset,
	 input start,
	 input [7:0] rhr_data,
	 input [7:0] read_data,
    input done,
	 input [7:0] rx_data_ready,
	 output reg tx_load,
	 output reg[7:0] tx_out_data,
	 output reg write_enable,
	 output reg[7:0] write_data,
	 output reg[1:0] matrix_select,
	 output reg[1:0] col,
	 output reg[1:0] row,
	 output reg mac_start,
	 output reg want,
	 input [7:0] tx_count
);
	 reg [7:0] rx_data_ready_updated;
	 reg [7:0] tx_count_reg;
		always @(posedge clk or posedge reset) begin
			 if (reset)
				  state <= IDLE;
			 else
				  state <= next_state;
		end

	
		
	 parameter IDLE = 3'b0, RECEIVE_DATA = 3'b001,PREP_CALC = 3'b010, CALCULATION = 3'b011, TRANSMIT_DATA = 3'b100,TRANSMITTING = 3'b101;
	 reg [2:0] state, next_state;
	
always @(*) begin
    case (state)
        IDLE: begin
            if (start)
                next_state = RECEIVE_DATA;
            else
                next_state = IDLE;
        end

        RECEIVE_DATA: begin
            if (matrix_select == 1 && row == 2 && col == 2)
                next_state = PREP_CALC;
            else
                next_state = RECEIVE_DATA;
        end

        PREP_CALC: begin
            next_state = CALCULATION;
        end

        CALCULATION: begin
            if (done)
                next_state = TRANSMIT_DATA;
            else
                next_state = CALCULATION;
        end

        TRANSMIT_DATA: begin
            if (row == 2 && col == 2)
                next_state = IDLE;
            else
                next_state = TRANSMITTING;
        end
		  TRANSMITTING: begin
				if (tx_count < 10)
					next_state = TRANSMIT_DATA;
				else
					next_state = IDLE;
		  end
		  

        default: begin
            next_state = IDLE;
        end
    endcase
end
	 
	 reg [1:0] matrix_index;   // 0 to 1
    reg [1:0] row_index;      // 0 to 3
    reg [1:0] col_index;      // 0 to 3
	 
		always @(posedge clk or posedge reset) begin
        if (reset) begin
			  matrix_select <= 2'b00;
			  row <= 0;
			  col <= 0;
			  write_data <= 0;
			  write_enable <= 0;
			  tx_load <= 0;
			  matrix_index <= 2'b00;
			  row_index <= 2'b00;
			  col_index <= 2'b00;
			  rx_data_ready_updated <= 0;
			  tx_count_reg <= 1;
			  mac_start <= 0;
			  want <= 0;
			  tx_out_data <= 0;

		  end else begin
            case (state)
					 IDLE: begin						 
						  matrix_select <= 2'b00;
                    row <= 2'b00;
                    col <= 2'b00;
						  write_data <= 0;
						  write_enable <= 0;
						  tx_load <= 0;
						  want <= 0;
					 end 
                RECEIVE_DATA: begin
						want <= 1;
						 if((rx_data_ready_updated+1) == rx_data_ready) begin
							write_enable <= 1;
							write_data <= rhr_data;
							matrix_select <= matrix_index;
							row <= row_index;
							col <= col_index;
							rx_data_ready_updated <= rx_data_ready;
							
							  if (col_index < 2) begin
                            col_index <= col_index + 1;
                        end else begin
                            col_index <= 0;
                            if (row_index < 2) begin
                                row_index <= row_index + 1;
                            end else begin
                                row_index <= 0;
                                if (matrix_index < 1)
                                    matrix_index <= matrix_index + 1;
                            end
                        end
								
						 end else begin
							 write_enable <= 0;
						 end
					 end
					 PREP_CALC: begin
						  want <= 0;
						  mac_start <= 1;
					 end
					 
                CALCULATION: begin
						  mac_start <= 0;
						  
						  write_data <= 0;
						  write_enable <= 0;

				//Below should be ready by next clk cycle so using here
						  matrix_index <= 2;
                    row_index <= 0;
                    col_index <= 0;						  
						  matrix_select <= matrix_index;
							row <= row_index;
							col <= col_index;
                end
					 TRANSMIT_DATA: begin	
							want <= 1;
							if(tx_count_reg == (tx_count+1))begin		// <11 for 9 values
							tx_load <= 1;
							
							matrix_select <= matrix_index;
							row <= row_index;
							col <= col_index;
							tx_count_reg <= tx_count_reg + 1;
							
							if(col_index < 2) 
								col_index <= col_index + 1;
							else begin
								col_index <= 0;
								if (row_index < 2)begin
									row_index <= row_index + 1;
								end end
									 
                end else begin tx_load <= 0; end
					 end
					 TRANSMITTING: begin
							tx_out_data <= read_data;
					 end
                default: begin
							
                end
            endcase
        end
    end
	
endmodule
