module XORS_tb ();

reg res;
reg [15*8-1:0] co_buf;
reg [15:0] register;
reg clk;
wire result;

XORs #(.NUM_OF_TAPS(15))xory (
	.res			(res),
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
	forever #5 clk = ~clk;
end

initial begin
	@(negedge res);
	repeat (8) begin
		//#50 register = register + 1;
		@(negedge clk) res = 1'b0;
		//repeat (8) @(posedge clk);
	end
	
	//$finish;
end

endmodule
