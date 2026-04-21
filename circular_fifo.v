module Circularfifo(data_out,empty,full,reset,clk,wr_en,rd_en,data_in);
input reset,clk;
input [3:0]data_in;
input wr_en,rd_en;
output empty,full;
output reg [3:0] data_out;

reg [3:0] rd_ptr,wr_ptr;
reg [3:0]mem[0:7];
reg[3:0]count;

always@(posedge clk,negedge reset) begin
if (!reset)
wr_ptr<=0;
else if (!full && wr_en) begin
wr_ptr<=(wr_ptr+1)%8;
mem[wr_ptr]<=data_in;
end
end

always@(posedge clk,negedge reset) begin
if(!reset) 
rd_ptr<=0;
else if (!empty && rd_en) begin
rd_ptr<=(rd_ptr+1)%8;
data_out<=mem[rd_ptr];
end
end

always @(posedge clk,negedge reset) begin
if(!reset)
count<=0;
else if (rd_en==0 && wr_en==1 && full===0)
count<=count+1;
else if (rd_en==1 && wr_en==0 && empty==0)
count<=count-1;
end



assign full =(count==8)?1:0;
assign empty=(count==0)?1:0;

endmodule


module tb_CircularFIFO;

reg reset, clk = 0;
reg [3:0] data_in;
reg wr_en, rd_en;
wire empty, full;
wire [3:0] data_out;

// DUT instantiation
Circularfifo DUT (
  data_out,
  empty,
  full,
  reset,
  clk,
  wr_en,
  rd_en,
  data_in
);

// Clock generation
initial forever #5 clk = ~clk;

// Control signals
initial begin
  reset = 0;
  #3 reset = 1;

  wr_en = 1; 
  rd_en = 0;

  #37 wr_en = 0; 
      rd_en = 1;

#44 wr_en=1;rd_en=0;
end

// Data input stimulus
initial begin
  data_in = 8;
  #12 data_in = 12;
  #10 data_in = 4;
  #10 data_in = 7;
  #10 data_in = 13;
  #10 data_in = 9;
  #10 data_in = 11;
  #10 data_in = 5;
  #10 data_in = 15;
  #10 data_in = 6;
end

endmodule
