module FPGA #(parameter NUM_OF_TAPS = 6, SIZE = 8, NUM_OF_MODULES = 20, SEED = 1351) (
	input clk,
	input start,
	
	output wire TX,
	output reg found_smth,
	output wire startedmod
);

reg start_S;

wire [NUM_OF_MODULES*(NUM_OF_TAPS*8)-1:0] coefficient_buff;
wire [NUM_OF_MODULES-1:0] found;

wire [NUM_OF_MODULES-1:0] res;
wire [NUM_OF_MODULES-1:0] started;

assign startedmod = started[2];

Interface #(
			.NUM_OF_TAPS		(NUM_OF_TAPS)		, 
			.SIZE					(SIZE)				, 
			.NUM_OF_MODULES	(NUM_OF_MODULES)	)
	interfejs (	
		.clk		(clk)					,
		.co_buf	(coefficient_buff),	
		.found	(found)				,
		.res		(res)					,
		.TX		(TX)
);

genvar i;
generate
for (i=0; i<NUM_OF_MODULES; i=i+1) begin: Trololo
	
	SearchModule #(
				.NUM_OF_TAPS 	(NUM_OF_TAPS), 
				.SIZE 			(SIZE), 
				.SEED 			(SEED + i) )
		szukacz (
			.clk		(clk)	,
			.start	(start_S)	,
			.ext_res (res[i]),
			.found	(found[i])	,
			.started	(started[i]),
			.co_buf	(coefficient_buff[(i+1)*(NUM_OF_TAPS*8)-1-:NUM_OF_TAPS*8])
	);
	
end
endgenerate

initial begin
	found_smth <= 1'b0;
	start_S <= 1'b0;
end

always @ (posedge clk) begin
	
	if (!start) begin
		start_S <= 1'b1;
	end else start_S <= 1'b0;
	
	if (found != {NUM_OF_MODULES{1'b0}}) begin
		found_smth <= 1'b1;
	end
	else found_smth <= 1'b0;

end

endmodule
