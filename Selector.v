module Selector #(parameter NUM_OF_TAPS = 15)(
	input 		res,
	input 		clk,
	input [3:0] din,
	input 		take,
	
	output reg [NUM_OF_TAPS*8-1:0] taps,
	output reg done

);

reg 		occured;	// mowi czy wystapila najwyzsza potega
reg 		finished; // zapisano wszystkie tapsy
integer 	count;

initial begin
	done 		<= 1'b0;
	count 	<= 1;
	taps		<= {NUM_OF_TAPS*8{1'b0}};
	occured	<= 1'b0;
	finished	<= 1'b0;
end

always @ (posedge clk) begin
	if (res) begin
		done 		<= 1'b0;
		count 	<= 1;
		taps		<= {NUM_OF_TAPS*8{1'b0}};
		occured	<= 1'b0;
		finished	<= 1'b0;

	end else begin
		if (take && !finished) begin
			count <= count + 1;
			taps[count*8-1-:8] <= {4'b0000,din};
			if (din == 15) // jezeli wystapila najwyzsza potega
				occured <= 1'b1;
			if (count == NUM_OF_TAPS)
				finished <= 1'b1;
		end
		if (take && finished && !done) begin
			if (!occured) begin
				taps[7:0] <= 8'b00001111; // 31 - maksymalna potega 
			end
			done <= 1'b1;
		end
	end
end

endmodule
