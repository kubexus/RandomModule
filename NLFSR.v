module NLFSR #(parameter SIZE = 16)(

	input 						clk,
	input 						res,
	input 						ena,
	input 						feedback,
	
	output 						failure,
	output 						found,
	output reg [SIZE-1:0]	state
	
);

parameter period = 2**SIZE - 1;
integer i;

initial begin
	i <= 0;
end

always @ (posedge clk) begin
	if (res) begin
		state 	<= {SIZE{1'b1}};
		found 	<= 1'b0;
		failure 	<= 1'b0;
		i 			<= 0;
	end
	if (ena) begin
		if (state == {SIZE{1'b1}}) begin
			if (i == period) begin
				found <= 1'b1;  // ZNALEZIONO PELNY OKRES
			end
			if (i < period && i > 0) begin
				failure <= 1'b1;
			end
		end
		state <= {state[SIZE-2:0],feedback};
		i <= i + 1;
	end
end

endmodule

