module Selector_tb ();

reg res,clk,take;
reg [4:0] din;

wire done;
wire [15*8-1:0] taps;

Selector #(.NUM_OF_TAPS(15))select (
	.res	(res),
	.clk	(clk),
	.din	(din),
	.take (take),
	.taps	(taps),
	.done	(done)

);

initial begin
	clk = 1'b0;
	take = 0;
	din = 0;
	res = 1'b1;
	repeat (4) #5 clk = ~clk;
	res = 1'b0;
	forever #5 clk = ~clk;
end

initial begin
	@(negedge res);
	repeat (16) begin
		@(negedge clk)
			take = 1'b1;
			din = $urandom % 32;
		@(negedge clk) take = 1'b0;
		repeat (8) @(posedge clk);
	end
	
	//$finish;
end

endmodule
