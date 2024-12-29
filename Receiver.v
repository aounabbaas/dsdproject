`timescale 1ns / 1ps
module Receiver (
    input bclk,               // Clock signal (4x the baud rate)
    input reset,             // Reset signal
    input rx_data,           // UART receive data (serial input)
    output reg[7:0] rhr_data    // Receiver Holding Register (RHR) containing the received data
);

    localparam IDLE = 2'b0,
               RECEIVE_BITS = 2'b01,
               STOP_BIT = 2'b10;

    reg [1:0] state, next_state;      // Current state and next state
    reg [3:0] bit_counter;            // Bit counter (to count 8 data bits)
    reg [7:0] receiver_shift_reg;     // Receiver Shift Register (RSR) to store the received data bits
	 reg data_ready;         // Data ready signal (indicates that the data is available in the RHR)
    
	 // State transition logic (FSM)
    always @(posedge bclk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (FSM)
    always @(*) begin
        case (state)
            IDLE: begin
                if (rx_data == 0)  // Start bit detected (transition from high to low)
                    next_state = RECEIVE_BITS;
                else
                    next_state = IDLE;
            end
            RECEIVE_BITS: begin
                if (bit_counter >= 7)  // All 8 bits have been received
                    next_state = STOP_BIT;
                else
                    next_state = RECEIVE_BITS;
            end
            STOP_BIT: begin
                next_state = IDLE;  // Go back to IDLE after stop bit
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge bclk or posedge reset) begin
        if (reset) begin
            bit_counter <= 0;
            receiver_shift_reg <= 0;
            data_ready <= 0;
            rhr_data <= 0;
        end else begin
            case (state)
					 IDLE: begin
   					   bit_counter <= 0;
							receiver_shift_reg <= 0;
					 end
                RECEIVE_BITS: begin
						  data_ready <= 0;
						  receiver_shift_reg <= {rx_data, receiver_shift_reg[7:1]};
                    bit_counter <= bit_counter + 1;
                end
                STOP_BIT: begin
                    rhr_data <= receiver_shift_reg;  // Store received data in Receiver Holding Register
                    data_ready <= 1;  // Indicate that data is ready in RHR               
                end
                default: begin
                    data_ready <= 0;
                end
            endcase
        end
    end

endmodule
