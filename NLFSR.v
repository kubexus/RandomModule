module NLFSR #(parameter SIZE = 32)(

	input 						clk,
	input 						res,
	input 						ena,
	input							selector_done,
	input 						feedback,
	
	output reg					failure,
	output reg					found,
	output reg [SIZE-1:0]	state
	
);

wire feedback1 = feedback ^ state[0];

parameter [35:0] period = (2**SIZE) - 1;
parameter per1 = (2**SIZE) / 4;
parameter per2 = (2**SIZE) / 2;

reg [35:0] i;

reg [SIZE-1:0] control1, control2;

parameter INIT_VAL = {1'b1,{SIZE-1{1'b0}}};

initial begin
	i <= 0;
	state <= INIT_VAL;
	failure <= 1'b0;
	found 	<= 1'b0;
	control1 <= {SIZE{1'b0}};
	control2 <= {SIZE{1'b0}};
end

always @ (posedge clk) begin
	if (res) begin
		state 	<= INIT_VAL;
		found 	<= 1'b0;
		failure 	<= 1'b0;
		i 			<= 0;
		control1 <= {SIZE{1'b0}};
		control2 <= {SIZE{1'b0}};
	end
	if (ena && selector_done) begin
		if (!found && !failure) begin
			state <= {feedback1,state[SIZE-1:1]};
			i <= i + 1;
		end
		if (state == INIT_VAL) begin
			if (i == period) begin
				found <= 1'b1;  // ZNALEZIONO PELNY OKRES
			end
			if (i > 5 && i < period) begin
				failure <= 1'b1;
			end
		end
		if (i > period + 3)
			failure <= 1'b1;
	end
end

endmodule

