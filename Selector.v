module Selector #(parameter NUM_OF_TAPS = 15, SIZE = 32)(
	input 		res,
	input 		clk,
	input [7:0] din,
	input 		take,
	input			ena,
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

	end
	if (ena) begin
		if (take && !finished) begin
			if (din[4:0] != 5'b00000 && din[4:0] < SIZE) begin
				case(count)
					1:	begin
						taps[count*8-1-:8] <= {3'b000,din[4:0]};
						//count <= count + 1;
					end
					
					2: begin
						if ({3'b000,din[4:0]} != taps[(count-1)*8-1-:8]) begin
							taps[count*8-1-:8] <= {3'b000,din[4:0]};
							//count <= count + 1;
						end
					end
					
					3: begin
						//if ( ({3'b000,din[4:0]} != taps[(count-1)*8-1-:8]) && ({3'b000,din[4:0]} != taps[(count-2)*8-1-:8])) begin
							taps[count*8-1-:8] <= {3'b000,din[4:0]};
							//count <= count + 1;
						//end
					end
					
					4: begin
						//if ( ({3'b000,din[4:0]} != taps[(count-1)*8-1-:8]) && ({3'b000,din[4:0]} != taps[(count-2)*8-1-:8]) && ({3'b000,din[4:0]} != taps[(count-3)*8-1-:8])) begin
							taps[count*8-1-:8] <= {3'b000,din[4:0]};
							//count <= count + 1;
						//end
					end
					
					5:	begin
						taps[count*8-1-:8] <= {3'b000,din[4:0]};
						//count <= count + 1;
					end
					
					6: begin
						//if ({3'b000,din[4:0]} != taps[(count-1)*8-1-:8]) begin
							taps[count*8-1-:8] <= {3'b000,din[4:0]};
							//count <= count + 1;
						//end
					end
					
//					7: begin
//						if ( ({3'b000,din[4:0]} != taps[(count-1)*8-1-:8]) && ({3'b000,din[4:0]} != taps[(count-2)*8-1-:8])) begin
//							taps[count*8-1-:8] <= {3'b000,din[4:0]};
//							//count <= count + 1;
//						end
//					end
//					
//					8: begin
//						if ( ({3'b000,din[4:0]} != taps[(count-1)*8-1-:8]) && ({3'b000,din[4:0]} != taps[(count-2)*8-1-:8]) && ({3'b000,din[4:0]} != taps[(count-3)*8-1-:8])) begin
//							taps[count*8-1-:8] <= {3'b000,din[4:0]};
//							//count <= count + 1;
//						end
//					end
//					
//					9:	begin
//						taps[count*8-1-:8] <= {3'b000,din[4:0]};
//						//count <= count + 1;
//					end
//					
//					10: begin
//						if ({3'b000,din[4:0]} != taps[(count-1)*8-1-:8]) begin
//							taps[count*8-1-:8] <= {3'b000,din[4:0]};
//							//count <= count + 1;
//						end
//					end
//					
//					11: begin
//						if ( ({3'b000,din[4:0]} != taps[(count-1)*8-1-:8]) && ({3'b000,din[4:0]} != taps[(count-2)*8-1-:8])) begin
//							taps[count*8-1-:8] <= {3'b000,din[4:0]};
//							//count <= count + 1;
//						end
//					end
				endcase
				
				count <= count + 1;
				
				//if (din[4:0] == 19) // jezeli wystapila najwyzsza potega
				//	occured <= 1'b1;
				if (count == NUM_OF_TAPS + 1)
					finished <= 1'b1;
			end
		end
		if (finished && !done) begin
//			if (!occured) begin
//				taps[7:0] <= 8'b00001111; // 31 - maksymalna potega 
//			end
			done <= 1'b1;
		end
	end
end

endmodule
