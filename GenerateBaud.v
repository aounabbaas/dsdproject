`timescale 1ns / 1ps

module GenerateBaud( input clk,input rst, output reg txclk, output reg rxclk);
reg [15:0] counter1 = 0;
reg [15:0] counter2 = 0;
reg [15:0] baudrate = 9600;
parameter sysclk=100_000_000;


always @(posedge clk) begin
  if(rst)begin
  counter1<=0;
  rxclk<=0;
  end
  if (counter1 >= (sysclk/(baudrate*8*2))) begin
		counter1 <= 0;
		rxclk <= ~rxclk;  // Toggle baud clock
  end else begin
		counter1 <= counter1 + 1;
  end
end

always @(posedge clk) begin
  if(rst)begin
  counter2<=0;
  txclk<=0;
  end
  if (counter2 >= (sysclk/(baudrate*2))) begin
		counter2 <= 0;
		txclk <= ~txclk;  // Toggle baud clock
  end else begin
		counter2 <= counter2 + 1;
  end
end


endmodule
