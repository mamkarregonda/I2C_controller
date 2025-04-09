`timescale 10ns / 1ns
module i2c_slave_controller(
	inout i2c_sda,
	inout i2c_scl
	);	
	localparam ADDRESS = 7'b0101010;
	localparam READ_ADDR = 0;
	localparam SEND_ACK = 1;
	localparam READ_DATA = 2;
	localparam WRITE_DATA = 3;
	localparam SEND_ACK2 = 4;
	reg [7:0] addr;
	reg [7:0] counter = 0;
	reg [5:0] state = 0;
	reg [7:0] data_in = 0;
	reg [7:0] data_out = 8'b0;
	reg sda_out = 0;
	reg sda_in = 0;
	reg start = 0;
	reg write_enable = 0;
	assign i2c_sda = (write_enable == 1) ? sda_out : 'bz;
	always @(negedge i2c_sda) begin
		if ((start == 0) && (i2c_scl == 1)) begin
			start <= 1;	
			counter <= 7;
		end
	end
	always @(posedge i2c_sda) begin
		if ((start == 1) && (i2c_scl == 1)) begin
			state <= READ_ADDR;
			start <= 0;
			write_enable <= 0;
		end
	end
	always @(posedge i2c_scl) begin
		if (start == 1) begin
			case(state)
				READ_ADDR: begin
					addr[counter] <= i2c_sda;
					if(counter == 0) state <= SEND_ACK;
					else counter <= counter - 1;					
				end
				SEND_ACK: begin
					if(addr[7:1] == ADDRESS) begin
						counter <= 7;						
						if(addr[0] == 0) begin 
							state <= READ_DATA;
						end
						else state <= WRITE_DATA;
					end
				end
				READ_DATA: begin
					data_in[counter] <= i2c_sda;	
					if(counter <= 0) begin						
						state <= SEND_ACK2;
					end else begin counter <= counter - 1;end 
					
				end
				SEND_ACK2: begin
					data_out <= data_in;
					state <= READ_ADDR;	
					counter <=7;
				end
				WRITE_DATA: begin	
					if(counter == 0) state <= READ_ADDR;
					else counter <= counter - 1;		
				end
								
			endcase
		end
	end
	always @(negedge i2c_scl) begin
		case(state)
			READ_ADDR: begin
				write_enable <= 0;			
			end
			SEND_ACK: begin
				sda_out <= 0;
				write_enable <= 1;	
			end
			READ_DATA: begin
				write_enable <= 0;
			end
			WRITE_DATA: begin
				sda_out <= data_out[counter];
				write_enable <= 1;
			end
			SEND_ACK2: begin
				sda_out <= 0;
				write_enable <= 1;
			end
		endcase
	end
endmodule