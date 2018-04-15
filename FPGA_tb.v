module FPGA_tb ();

	reg clk;
	reg start;
	
	wire TX;
	wire found_smth;
	wire startedmod;
	
FPGA #(
	.NUM_OF_TAPS(6)		, 
	.SIZE(8)					, 
	.NUM_OF_MODULES(20)	, 
	.SEED(1351)) 
		efpega(
			.clk (clk)						,
			.start (start)					,
	
			.TX	(TX)						,
			.found_smth (found_smth)	,
			.startedmod (startedmod)
);

initial begin
	clk = 1'b0;
	start = 1'b1;
	repeat (4) #5 clk = ~clk;
	#10 start = 1'b0;
	repeat (4) #5 clk = ~clk;
	#10 start = 1'b1;
	forever begin
		#5 clk = ~clk;
	end
end
endmodule
