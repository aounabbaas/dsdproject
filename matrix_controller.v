`timescale 1ns / 1ps
//controls 5 rows based on which_row
module matrix_controller(
    input clk,
    input reset,
    input start,
	 input [7:0] read_data,
	 input [3:0] which_row,
	 output reg done,
	 output reg write_enable,
	 output reg [1:0] matrix_select, 
	 output reg [3:0] row, 
	 output reg [3:0] col,
	 output reg [7:0] write_data
);
    // Intermediate registers
    reg [7:0] a_data, b_data, mac_result;
	 reg [3:0] result_row, result_col; // Track result matrix indices
    reg [3:0] k;                  // Inner loop counter
    reg [3:0] state;
	 reg [3:0] next_state;
	 
// FSM state encoding
    parameter
    IDLE = 4'd0,
	 PREP_FETCH_A = 4'd1,
    FETCH_A = 4'd2,
	 PREP_FETCH_B = 4'd3,
    FETCH_B = 4'd4,
    MAC_OPERATION = 4'd5,
    WRITE_RESULT = 4'd6,
    UPDATE_INDICES = 4'd7,
    DONE = 4'd8,
	 CHECK_INDICES =4'd9;

	 

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start) next_state = PREP_FETCH_A;
                else next_state = IDLE;
            end

            PREP_FETCH_A: next_state = FETCH_A;

            FETCH_A: next_state = PREP_FETCH_B;
				
            PREP_FETCH_B: next_state = FETCH_B;

            FETCH_B: next_state = MAC_OPERATION;

            MAC_OPERATION: begin
                if (k == 9) // Inner loop completed   //2  for 3x3
                    next_state = WRITE_RESULT;
                else
                    next_state = PREP_FETCH_A;
            end
				
            WRITE_RESULT: begin
                if (result_row == 9 && result_col == 9) // == 2 for 3x3
                    next_state = DONE;
                else
                    next_state = UPDATE_INDICES;
            end

            UPDATE_INDICES: 
						next_state = CHECK_INDICES;
						
				CHECK_INDICES: begin
						if (result_row == which_row)
							next_state = PREP_FETCH_A;
						else if(result_row <= (which_row+4))  	//result_row already updated,k already reset and result_col also so continue
							next_state = PREP_FETCH_A;
						else
							next_state = DONE; 
				end				
				
            DONE: begin
                if (!start) next_state = IDLE;
                else next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output and operation logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            row <= 0;
            col <= 0;
				mac_result <= 0;
            matrix_select <= 0;
            write_enable <= 0;
            write_data <= 0;
            done <= 0;
            result_row <= 0;
            result_col <= 0;
            k <= 0;
        end else begin
            // Default assignments
            write_enable <= 0;
            

            case (state)
                IDLE: begin
                    row <= 0;
                    col <= 0;
                    result_row <= which_row;
                    result_col <= 0;
                    k <= 0;
                end

                PREP_FETCH_A: begin
						  done <= 0;
                    matrix_select <= 0; // Select matrix A
                    row <= result_row;  // Fetch current row
                    col <= k;           // Inner loop index
                end
					 
					 FETCH_A: begin
					     a_data <= read_data;
					 end

                PREP_FETCH_B: begin
                    matrix_select <= 1; // Select matrix B
                    row <= k;           // Inner loop index
                    col <= result_col;  // Fetch current column
                end

					 FETCH_B: begin
					     b_data <= read_data;
					 end

                MAC_OPERATION: begin
                    if (k == 0) begin
                        mac_result <= a_data * b_data; // Start new accumulation
                    end else begin
								 // Accumulate  
								mac_result <= mac_result + (a_data * b_data); 
						  end
                    k <= k + 1; // Increment inner loop counter
                end

                WRITE_RESULT: begin
                    matrix_select <= 2; // Select result matrix
                    write_enable <= 1; // Enable writing
                    row <= result_row;
                    col <= result_col;
						  write_data <= mac_result;
                end
					 
                UPDATE_INDICES: begin
                    if (result_col < 9) begin         // <2 for 3x3
                        result_col <= result_col + 1; // Move to next column
                    end else begin
                        result_col <= 0;             // Reset column
                        result_row <= result_row + 1; // Move to next row
                    end
                    k <= 0; // Reset inner loop counter
                end

                DONE: begin
                    done <= 1; // Operation complete
                end
            endcase
        end
    end

endmodule
