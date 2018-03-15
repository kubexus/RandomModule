module XORs #(parameter NUM_OF_TAPS = 15)(
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
	always @ (register) begin
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
//				8'h10 :	TAPS[i] <= register[16];
//				8'h11 :	TAPS[i] <= register[17];
//				8'h12 :	TAPS[i] <= register[18];
//				8'h13 :	TAPS[i] <= register[19];
//				8'h14 :	TAPS[i] <= register[20];
//				8'h15 :	TAPS[i] <= register[21];
//				8'h16 :	TAPS[i] <= register[22];
				default : TAPS[i] <= 1'b0;
			endcase
		end
	end

end
endgenerate



//// AND11
//always @ (register) begin
//case (co_buf[15*5-1-:5])
//	5'h00 :	AND11 <= register[0];
//	5'h01 :	AND11 <= register[1];
//	5'h02 :	AND11 <= register[2];
//	5'h03 :	AND11 <= register[3];
//	5'h04 :	AND11 <= register[4];
//	5'h05 :	AND11 <= register[5];
//	5'h06 :	AND11 <= register[6];
//	5'h07 :	AND11 <= register[7];
//	5'h08 :	AND11 <= register[8];
//	5'h09 :	AND11 <= register[9];
//	5'h0a :	AND11 <= register[10];
//	5'h0b :	AND11 <= register[11];
//	5'h0c :	AND11 <= register[12];
//	5'h0d :	AND11 <= register[13];
//	5'h0e :	AND11 <= register[14];
//	5'h0f :	AND11 <= register[15];
//	                 
//	5'h10 :	AND11 <= register[16];
//	5'h11 :	AND11 <= register[17];
//	5'h12 :	AND11 <= register[18];
//	5'h13 :	AND11 <= register[19];
//	5'h14 :	AND11 <= register[20];
//	5'h15 :	AND11 <= register[21];
//	5'h16 :	AND11 <= register[22];
//endcase
//end
//
//
//// AND12
//always @ (register) begin
//case (co_buf[9*5-1-:5])
//	5'h00 :	AND12 <= register[0];
//	5'h01 :	AND12 <= register[1];
//	5'h02 :	AND12 <= register[2];
//	5'h03 :	AND12 <= register[3];
//	5'h04 :	AND12 <= register[4];
//	5'h05 :	AND12 <= register[5];
//	5'h06 :	AND12 <= register[6];
//	5'h07 :	AND12 <= register[7];
//	5'h08 :	AND12 <= register[8];
//	5'h09 :	AND12 <= register[9];
//	5'h0a :	AND12 <= register[10];
//	5'h0b :	AND12 <= register[11];
//	5'h0c :	AND12 <= register[12];
//	5'h0d :	AND12 <= register[13];
//	5'h0e :	AND12 <= register[14];
//	5'h0f :	AND12 <= register[15];
//	                 
//	5'h10 :	AND12 <= register[16];
//	5'h11 :	AND12 <= register[17];
//	5'h12 :	AND12 <= register[18];
//	5'h13 :	AND12 <= register[19];
//	5'h14 :	AND12 <= register[20];
//	5'h15 :	AND12 <= register[21];
//	5'h16 :	AND12 <= register[22];
//endcase
//end
//
//// AND13
//always @ (register) begin
//case (co_buf[8*5-1-:5])
//	5'h00 :	AND13 <= register[0];
//	5'h01 :	AND13 <= register[1];
//	5'h02 :	AND13 <= register[2];
//	5'h03 :	AND13 <= register[3];
//	5'h04 :	AND13 <= register[4];
//	5'h05 :	AND13 <= register[5];
//	5'h06 :	AND13 <= register[6];
//	5'h07 :	AND13 <= register[7];
//	5'h08 :	AND13 <= register[8];
//	5'h09 :	AND13 <= register[9];
//	5'h0a :	AND13 <= register[10];
//	5'h0b :	AND13 <= register[11];
//	5'h0c :	AND13 <= register[12];
//	5'h0d :	AND13 <= register[13];
//	5'h0e :	AND13 <= register[14];
//	5'h0f :	AND13 <= register[15];
//	                 
//	5'h10 :	AND13 <= register[16];
//	5'h11 :	AND13 <= register[17];
//	5'h12 :	AND13 <= register[18];
//	5'h13 :	AND13 <= register[19];
//	5'h14 :	AND13 <= register[20];
//	5'h15 :	AND13 <= register[21];
//	5'h16 :	AND13 <= register[22];
//endcase
//end


endmodule
