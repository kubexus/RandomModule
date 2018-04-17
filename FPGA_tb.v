module FPGA_tb ();

	reg clk;
	reg start;
	
	wire TX;
	wire found_smth;
	wire startedmod;
	
FPGA efpega(
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
	start = 1'b0;
	repeat (4) #5 clk = ~clk;
	start = 1'b1;
	forever begin
		#5 clk = ~clk;
	end
	@(TX == 0) 
	start = 1'b0;
	$finish;
	
end
endmodule
