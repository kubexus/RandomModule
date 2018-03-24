module Interface #(parameter NUM_OF_TAPS = 15)(
	input clk,
	input res,
	input [20*(NUM_OF_TAPS*8)-1:0] co_buf,	// 20 modułów liczących
	input [19:0] found,
	output TX
);

reg [7:0] 						byte_out;
reg 								sending;
reg								select;
reg [(NUM_OF_TAPS*8)-1:0] 	buff;

wire jeden; assign jeden = 1'b1 ^ res;
wire transmit;
wire tx_ready;

integer which;
integer i;

RS232_TRANSMITTER transmitter (
	.CLK		(clk),
	.INIT		(jeden),
	.DRL		(transmit),
	.LOAD		(tx_ready),
	.DIN		(byte_out),
	.TX		(TX)
);

initial begin
	byte_out		<= 8'h00;
	TX				<= 1'b0;
	sending 		<= 1'b0;
	select		<= 1'b0;
	buff			<= {NUM_OF_TAPS{8'h00}};
	which			<= 0;
	i				<= 0;
end

always @ (posedge clk) begin
	if (found != 20'h00000) begin
		select <= 1'b1;
		case (found)
			8'b0000000000_0000000001	:	which <= 1;
			8'b0000000000_0000000010	:	which <= 2;
			8'b0000000000_0000000100	:	which <= 3;
			8'b0000000000_0000001000	:	which <= 4;
			8'b0000000000_0000010000	:	which <= 5;
			8'b0000000000_0000100000	:	which <= 6;
			8'b0000000000_0001000000	:	which <= 7;
			8'b0000000000_0010000000	:	which <= 8;
			8'b0000000000_0100000000	:	which <= 9;
			8'b0000000000_1000000000	:	which <= 10;
			8'b0000000001_0000000000	:	which <= 11;
			8'b0000000010_0000000000	:	which <= 12;
			8'b0000000100_0000000000	:	which <= 13;
			8'b0000001000_0000000000	:	which <= 14;
			8'b0000010000_0000000000	:	which <= 15;
			8'b0000100000_0000000000	:	which <= 16;
			8'b0001000000_0000000000	:	which <= 17;
			8'b0010000000_0000000000	:	which <= 18;
			8'b0100000000_0000000000	:	which <= 19;
			8'b1000000000_0000000000	:	which <= 20;
			default							:	which <= 0;
		endcase
	end
end

always @ (posedge clk) begin
	if (select) begin
//		transmit <= 1'b1;
//		if (tx_ready) begin
		buff <= co_buf[(which-1)*(NUM_OF_TAPS*8)-1-:NUM_OF_TAPS*8];
//		end
	end
end


endmodule
