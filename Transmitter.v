module Transmitter(
    input bclk,             // Baud clock
	 input reset,
    input [7:0] d_in,       // 8-bit parallel data input
    input load,             // Load signal to load data into THR
    output reg tx_out,      // Serial data output
    output reg tx_status,    // Status signal (1 = ready to transmit, 0 = transmitting)
	 output reg [7:0] tx_count
);

// Registers and parameters
reg [7:0] THR;              // Transmitter Hold Register (THR)
reg [9:0] TSR;              // Transmitter Shift Register (TSR)
reg [3:0] bit_counter;      // Counter to track the number of bits transmitted
reg [2:0] state, next_state; // FSM state registers

// State encoding
localparam IDLE      = 3'b000,
           LOAD_THR  = 3'b001,
           LOAD_TSR  = 3'b010,
           TRANSMIT  = 3'b011,
			  DONE = 3'b100;

// FSM State Transition
always @(posedge bclk or posedge reset) begin
			if(reset)
			state <= IDLE;
			else
			state <= next_state; // State transitions based on next_state
end

// FSM Next State Logic
always @(*) begin
    case (state)
        IDLE: begin
            if (load && tx_status)
                next_state = LOAD_THR;
        end
        LOAD_THR: begin
            next_state = LOAD_TSR;
        end
        LOAD_TSR: begin
            next_state = TRANSMIT;
        end
        TRANSMIT: begin
            if (bit_counter >= 4'd8)  //8works, 9 doesnt in FPGA
                next_state = DONE;
            else
                next_state = TRANSMIT;
        end
		  DONE: begin
				next_state = IDLE;
		  end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// FSM Output Logic
always @(posedge bclk or posedge reset) begin
    if (reset) begin
		 tx_out <= 1'b1;          // Default high (idle state for UART)
		 tx_status <= 1'b1;       // Ready to transmit
		 bit_counter <= 4'b0;
		 TSR <= 10'b0;
		 THR <= 8'b0;
		 tx_count <= 0;
	 end else begin
	 
			 case (state)
				  IDLE: begin
						tx_status <= 1'b1;  // Ready to transmit
						tx_out <= 1'b1;     // Idle state
						bit_counter <= 0;
				  end
				  LOAD_THR: begin
						THR <= d_in;        // Load data into THR
						tx_status <= 1'b0;  // Set status to "transmitting"
				  end
				  LOAD_TSR: begin
						TSR <= {1'b1, THR, 1'b0}; // Add start (0) and stop (1) bits
						bit_counter <= 4'd0;      // Reset bit counter
				  end
				  TRANSMIT: begin
						tx_out <= TSR[bit_counter]; // Transmit the current bit
						bit_counter <= bit_counter + 1;
				  end
				  DONE: begin
						tx_out <= 1'b1;
						tx_count <= tx_count + 1;
						tx_status <= 1'b1;
				  end
				  default: begin
				      tx_status <= 1'b1;  // Ready to transmit
						tx_out <= 1'b1;     // Idle state
				  end
			 endcase
		end
end

endmodule
