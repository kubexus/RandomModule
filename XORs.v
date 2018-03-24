module XORs #(parameter NUM_OF_TAPS = 15)(
	input clk,
	input res,
	input [NUM_OF_TAPS*8-1:0] co_buf,	// co_buf wspolczynnikow
	input [15:0] register,				// NLFSR
	output result
);

reg [15:1] TAPS;
assign result = 	( TAPS[15] & TAPS[14] & TAPS[13] & TAPS[12] ) ^ 
						( TAPS[11] & TAPS[10] & TAPS[9] ) ^ 
						( TAPS[8] & TAPS[7] ) ^
						( TAPS[6] & TAPS[5] ) ^
						TAPS[4] ^ TAPS[3] ^ TAPS[2] ^ TAPS[1] ;
						
initial begin
	TAPS <= {NUM_OF_TAPS{8'h00}};
end

genvar i;
generate
for (i=NUM_OF_TAPS; i>0; i=i-1) 
	begin: TAPSY
	always @ (posedge clk) begin
		if (res) begin
			TAPS[i] <= 1'b0;
		end else begin
			case (co_buf[i*8-1-:8])
				8'h00 :	TAPS[i] <= register[0];
				8'h01 :	TAPS[i] <= register[1];
				8'h02 :	TAPS[i] <= register[2];
				8'h03 :	TAPS[i] <= register[3];
				8'h04 :	TAPS[i] <= register[4];
				8'h05 :	TAPS[i] <= register[5];
				8'h06 :	TAPS[i] <= register[6];
				8'h07 :	TAPS[i] <= register[7];
				8'h08 :	TAPS[i] <= register[8];
				8'h09 :	TAPS[i] <= register[9];
				8'h0a :	TAPS[i] <= register[10];
				8'h0b :	TAPS[i] <= register[11];
				8'h0c :	TAPS[i] <= register[12];
				8'h0d :	TAPS[i] <= register[13];
				8'h0e :	TAPS[i] <= register[14];
				8'h0f :	TAPS[i] <= register[15];
				default : TAPS[i] <= 1'b0;
			endcase
		end
	end

end
endgenerate

endmodule
