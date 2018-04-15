module NLFSR #(parameter SIZE = 16)(

	input 						clk,
	input 						res,
	input 						ena,
	input							selector_done,
	input 						feedback,
	
	output reg					failure,
	output reg					found,
	output reg [SIZE-1:0]	state
	
);

parameter period = (2**SIZE);
integer i;

initial begin
	i <= 0;
	state <= {SIZE{1'b1}};
	failure <= 1'b0;
	found 	<= 1'b0;
end

always @ (posedge clk) begin
	if (res) begin
		state 	<= {SIZE{1'b1}};
		found 	<= 1'b0;
		failure 	<= 1'b0;
		i 			<= 0;
	end
	if (ena && selector_done) begin
		if (!found && !failure) begin
			state <= {feedback^state[0],state[SIZE-1:1]};
			i <= i + 1;
		end
		if (state == {SIZE{1'b1}} && !found) begin
			if (i == period) begin
				found <= 1'b1;  // ZNALEZIONO PELNY OKRES
			end
			if (i < period && i > 5) begin
				failure <= 1'b1;
			end
		end
		if (i > period + 3)
			failure <= 1'b1;
	end
end

endmodule

