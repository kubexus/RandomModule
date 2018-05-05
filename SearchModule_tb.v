module SearchModule_tb();
	
	parameter NUM_OF_TAPS = 16;
	parameter SIZE = 32;
	
	reg 			clk		;
	reg 			start		;
	reg				ext_res	;
	
	wire 	found		;
	wire	started	;
	wire 	[NUM_OF_TAPS*8-1:0]		co_buf;
	
SearchModule #(	.NUM_OF_TAPS(NUM_OF_TAPS),
					.SIZE (SIZE)
					
					) modul(
			.clk (clk)						,
			.start (start)					,
			.ext_res (ext_res)			,
			.found	(found)						,
			.started (started)	,
			.co_buf (co_buf)
);

initial begin
	clk = 1'b0;
	start = 1'b0;
	repeat (4) #5 clk = ~clk;
	start = 1'b1;
	forever begin
		#5 clk = ~clk;
	end
	$finish;
	
end
endmodule
