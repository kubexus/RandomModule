module PRNG_tb ();

reg clk,res,ena;
wire done;
wire [7:0] dout;


PRNG lfsr(
	.clk (clk),
	.res (res),
	.ena (ena),
	.done (done),
	.dout (dout)
);

initial begin
	clk = 1'b0;
	res = 1'b1;
	ena = 1'b0;
	repeat (4) #5 clk = ~clk;
	res = 1'b0;
	forever #5 clk = ~clk;
end

initial begin
	ena = 1'b0;
	@(negedge res);
	ena = 1'b1;
	repeat(1000000) @(posedge clk);
	$finish;
end

endmodule
