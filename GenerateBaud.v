`timescale 1ns / 1ps

module GenerateBaud( input clk,input rst, input [1:0] baudsel, output reg txclk, output reg rxclk);
reg [15:0] counter1=0;
reg [15:0] counter2=0;
reg [15:0] baudrate;
parameter sysclk=100_000_000;
always @(*) begin
  case (baudsel)
		2'b00: baudrate = 9600;
		2'b01: baudrate = 19200;
		2'b10: baudrate = 38400;
		2'b11: baudrate = 57600;
		default: baudrate = 9600;
  endcase
end

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
