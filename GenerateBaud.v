`timescale 1ns / 1ps

module GenerateBaud( input clk,input rst, output reg bclk);
reg [15:0] counter1 = 0;
parameter baudrate = 9600;
parameter sysclk=100_000_000;

always @(posedge clk) begin
  if(rst)begin
	counter1<=0;
	bclk<=0;
  end if (counter1 >= (sysclk/(baudrate*2))) begin
		counter1 <= 0;
		bclk <= ~bclk;  // Toggle baud clock
  end else begin
		counter1 <= counter1 + 1;
  end end
endmodule
