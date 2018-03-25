module Interface #(parameter NUM_OF_TAPS = 15)(
	input clk,
	input res,
	input [20*(NUM_OF_TAPS*8)-1:0] co_buf,	// 20 modułów liczących
	input [19:0] found,
	output TX
);

reg [7:0] 	byte_out;
reg 			sending;
reg			select;
reg 			transmit;

reg [(NUM_OF_TAPS*8)-1:0] 	buff;

reg [5:0] state;
parameter	IDLE 		= 6'b000001,
				SELECT 	= 6'b000010,
				SENDING	= 6'b000100,
				RESET		= 6'b001000;

wire jeden; assign jeden = 1'b1 ^ res;
wire tx_ready;

reg [5:0] which;
reg [5:0] i;

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
	sending 		<= 1'b0;
	select		<= 1'b0;
	buff			<= {NUM_OF_TAPS{8'h00}};
	which			<= 0;
	i				<= 1;
	state 		<= IDLE;
end

always @ (posedge clk) begin
	case (state)
		IDLE: begin
			if (found != 20'h00000) begin
				state <= SELECT;
				case (found)
					20'b0000000000_0000000001	:	which <= 1;
					20'b0000000000_0000000010	:	which <= 2;
					20'b0000000000_0000000100	:	which <= 3;
					20'b0000000000_0000001000	:	which <= 4;
					20'b0000000000_0000010000	:	which <= 5;
					20'b0000000000_0000100000	:	which <= 6;
					20'b0000000000_0001000000	:	which <= 7;
					20'b0000000000_0010000000	:	which <= 8;
					20'b0000000000_0100000000	:	which <= 9;
					20'b0000000000_1000000000	:	which <= 10;
					20'b0000000001_0000000000	:	which <= 11;
					20'b0000000010_0000000000	:	which <= 12;
					20'b0000000100_0000000000	:	which <= 13;
					20'b0000001000_0000000000	:	which <= 14;
					20'b0000010000_0000000000	:	which <= 15;
					20'b0000100000_0000000000	:	which <= 16;
					20'b0001000000_0000000000	:	which <= 17;
					20'b0010000000_0000000000	:	which <= 18;
					20'b0100000000_0000000000	:	which <= 19;
					20'b1000000000_0000000000	:	which <= 20;
					default							:	which <= 0;
				endcase
			end
		end // IDLE
		
		SELECT: begin
			buff 		<= co_buf[which*(NUM_OF_TAPS*8)-1-:NUM_OF_TAPS*8];
			transmit <= 1'b1;
			state 	<= SENDING;
		end
		
		SENDING: begin
			if (tx_ready) begin
				byte_out <= buff[i*8-1-:8];
				i 			<= i + 1;
			end
			if (i == NUM_OF_TAPS) begin
				state		<= RESET;
			end
		end
		
		RESET: begin
			byte_out		<= 8'h00;
			sending 		<= 1'b0;
			select		<= 1'b0;
			buff			<= {NUM_OF_TAPS{8'h00}};
			which			<= 0;
			i				<= 1;
			state 		<= 6'b000001;
		end
	
	endcase
end

endmodule
