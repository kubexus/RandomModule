module Interface #(parameter NUM_OF_TAPS = 5, NUM_OF_MODULES = 20)(
	input clk,
	input [NUM_OF_MODULES*(NUM_OF_TAPS*8)-1:0] co_buf,	
	input [NUM_OF_MODULES-1:0] found,
	
	output reg [NUM_OF_MODULES-1:0] res,
	output TX
);

reg [7:0] 	byte_out;
reg 			transmit_byte;

reg [(NUM_OF_TAPS*8)-1:0] 	buff;

reg [5:0] state;

parameter	IDLE 		= 6'b000001,
				SELECT 	= 6'b000010,
				SENDING	= 6'b000100,
				RESET		= 6'b001000;

wire jeden; 
assign jeden = 1'b0;

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
	byte_out		<= 8'h11;
	buff			<= {NUM_OF_TAPS{8'h00}};
	which			<= 0;
	transmit_byte		<= 1'b0;
	i				<= 1;
	state 		<= IDLE;
	res 			<= {NUM_OF_MODULES{1'b0}};
end

always @ (posedge clk) begin
	case (state)
		IDLE: begin
			if (found != {NUM_OF_MODULES{1'b0}}) begin
				state <= SELECT;
				for (i=0;i<NUM_OF_MODULES;i=i+1) begin
					if (found[i] == 1'b1) begin
						which <= i;
					end
				end
			end
		end
		
		SELECT: begin
			buff 		<= co_buf[(which+1)*(NUM_OF_TAPS*8)-1-:NUM_OF_TAPS*8];
			transmit_byte <= 1'b1;
			state 	<= SENDING;
			i <= 0;
		end
		
		SENDING: begin
			if (buff	== {NUM_OF_TAPS{8'h00}} || buff[7:0] == 8'h00) begin
				state <= RESET;
			end else begin
				if (tx_ready) begin
					if (i == 0) begin
						byte_out <= 8'hff;
					end else begin
						byte_out <= buff[i*8-1-:8];
					end	
					i 	<= i + 1;
				end
				if (i == NUM_OF_TAPS + 1) begin
					transmit_byte		<= 1'b0;
					res[which] 			<= 1'b1;
					i <= i + 1;
				end
				if (i == NUM_OF_TAPS + 2) begin
					state					<= RESET;
				end
			end
		end
		
		RESET: begin
			res 			<= {NUM_OF_MODULES{1'b0}};
			byte_out		<= 8'h11;
			buff			<= {NUM_OF_TAPS{8'h00}};
			which			<= 0;
			i				<= 1;
			state 		<= IDLE;
		end
	
	endcase
end

assign transmit = (transmit_byte) ? 1'b1:1'b0;

endmodule
