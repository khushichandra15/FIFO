module simple_fifo(
input [3:0] data_in,
input wr_en, rd_en,
input reset, clock,
output empty, full,
output reg[3:0] data_out);

reg [3:0] rd_ptr;
reg [3:0] wr_ptr;
reg [3:0] mem[0:7];

always @( posedge clock or negedge reset)
begin : write_block
if (!reset)
	wr_ptr<=0;
else 
	if (wr_en && !full)
		begin
		wr_ptr = wr_ptr+1;
		mem[wr_ptr] <= data_in;
end
end

always @( posedge clock or negedge reset)
begin : read_block
if (!reset)
	rd_ptr<=0;
else 
	if (rd_en && !empty)begin
		rd_ptr <= rd_ptr+1;
		data_out <= mem[rd_ptr];
end
end

assign full=(wr_ptr>7) ? 1:0;
assign empty=(wr_ptr==rd_ptr) ? 1:0;


endmodule


//testbench
module simple_fifo_tb;
reg [3:0] data_in;
reg wr_en;
reg rd_en;
reg reset, clock;
wire empty, full;
wire [3:0] data_out;
simple_fifo obj(.data_in(data_in), .wr_en(wr_en), .rd_en(rd_en), .reset(reset), .clock(clock), .data_out(data_out), .empty(empty), .full(full));

initial 
begin
	clock=0;
	forever #5 clock=~clock;
end

initial
begin
	reset=0;
	#3 reset=1;
	wr_en=1; rd_en=0;
	#37 wr_en=0; rd_en=1;
end

initial
begin
data_in[3:0] = 4'b0000;
#12 data_in[3:0] = 4'b0001;
#10 data_in[3:0] = 4'b0010;
#10 data_in[3:0] = 4'b0011;
#10 data_in[3:0] = 4'b0100;
#10 data_in[3:0] = 4'b0101;
#10 data_in[3:0] = 4'b0110;
#10 data_in[3:0] = 4'b0111;
end
endmodule 





