module PRNG (
	input 				clk,
	input					res,
	input 				ena,
	output reg [3:0] 	dout,
	output reg 			done
);

reg [31:0] 	lfsr;
reg [7:0] 	waiter;
reg [2:0] 	i;

assign 		feedback 	= (lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0]);

initial begin
	lfsr 			<= 32'h18469258;
	dout			<= 5'h00;
	waiter		<= 8'h00;
	i 				<= 3'b000;
	done 			<= 1'b0;
end

always @ (posedge clk) begin

	if (res) begin
		dout		<= 5'h00;
		i 			<= 3'b000;
		done 		<= 1'b0;
		waiter	<= 8'h00;
	end 
	if (ena) begin
		if (waiter < 33) begin
			waiter <= waiter + 1; // pozwala przeliczyc cala dlugosc rejestru
		end else begin 
			lfsr <= {lfsr[30:0],feedback};
			if (i < 3) begin
				done <= 1'b0;
				dout[i] <= lfsr[31];
				i <= i + 1;
			end
			if (i == 3) begin
				dout[i] <= lfsr[31];
				done <= 1'b1;
				i <= 3'b000;
			end
		end
	end

end

endmodule
