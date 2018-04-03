module SearchModule #(parameter NUM_OF_TAPS = 15, SIZE = 16)(
	input 			clk		,
	input 			start		,
	
	output wire 	found		,
	output 			co_buf
);

assign co_buf = taps_from_selector;

wire res;
wire gen_ena;
wire temp1, temp2, temp3;
wire failure;

wire [SIZE-1:0]	nlfsr_reg;

wire [NUM_OF_TAPS*8-1:0] taps_from_selector; 

PRNG generator (
	.clk 		(clk)			,
	.res 		(res)			,
	.ena 		(gen_ena)	,
	.dout 	(temp1)		,
	.done 	(temp2)
);

Selector #(NUM_OF_TAPS = 15) selector (
	.res 		(res)						,
	.clk 		(clk)						,
	.din 		(temp1)					,
	.take 	(temp2)					,
	.taps 	(taps_from_selector)	,
	.done 	(temp3)
);

XORs #(NUM_OF_TAPS = 15) xory (
	.clk			(clk)						,
	.res			(res)						,
	.co_buf		(taps_from_selector)	,	
	.register	(nlfsr_reg)				,	
	.result		(feedback)
);

NLFSR #(SIZE = 16) nlfsr (

	.clk			(clk)			,
	.res			(res)			,
	.ena			(ena)			,
	.feedback	(feedback)	,
	.found		(found)		,
	.failure		(failure)	,
	.state		(nlfsr_reg)	,


);

always @ (posedge clk) begin
	if (failure) begin
		res <= 1'b1;
	end
	if (res) begin
		res <= 1'b0;
	end
end

endmodule
