`timescale 1ns / 1ps
// Button Synchronization Module (Debouncing)
module button(
    input clk,       // Clock signal
    input in,        // Button input (noisy)
    output out       // Synchronized button press output
);
    reg r1, r2, r3;  // Flip-flops for synchronization
    
    // Shift register to debounce the button input
    always @(posedge clk) begin
        r1 <= in;   // Capture raw input in r1
        r2 <= r1;   // Shift to r2
        r3 <= r2;   // Shift to r3
    end
    
    // Output goes high when the button is pressed cleanly
    assign out = ~r3 & r2;
    
endmodule 
