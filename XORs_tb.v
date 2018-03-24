module XORS_tb ();

reg res;
reg [15*8-1:0] co_buf;
reg [15:0] register;
reg clk;
wire result;

XORs #(.NUM_OF_TAPS(15))xory (
	.res			(res),
	.clk			(clk),
	.co_buf		(co_buf),
	.register	(register),
	.result 		(result)
);

initial begin
	clk = 1'b0;
	co_buf = 120'h01060e050f00010b0b080f060a0108 ;
	register = 15'b001110101110001 ;
	res = 1'b1;
	repeat (4) #5 clk = ~clk;
	#10 res = 1'b0;
	forever begin
		#5 clk = ~clk;
	end
end

initial begin
	@(negedge res);
	#10 register = 15'b001101000101010 ;
	#10 register = 15'b001010111101010 ;
	#10 register = 15'b010001010101101 ;
	#10 register = 15'b001011101011101 ;
	#10 register = 15'b110111010100010 ;
	#10 register = 15'b001101011101001 ;
	#10 register = 15'b110010101001001 ;
end

endmodule
