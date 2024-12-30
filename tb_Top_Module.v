`timescale 1ns / 1ps

module tb_Top_Module;

	// Inputs
	reg clk;
	reg reset;
	reg start;

	// Outputs
	wire done;

	// Instantiate the Unit Under Test (UUT)
	Top_Module uut (
		.clk(clk), 
		.reset(reset), 
		.start(start), 
		.done(done)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		start = 0;

		// Wait 100 ns for global reset to finish
		#100;
      reset = 0;
		start = 1;
		#10;
		start = 0;
	end
      
	always #5 clk = ~clk;
		
endmodule

