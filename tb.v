`timescale 10ns / 1ns
module i2c_controller_tb;
	reg clk;
	reg rst;
	reg [6:0] addr;
	reg [7:0] data_in;
	reg enable;
	reg rw;
	wire [7:0] data_out;
	wire ready;
	wire i2c_sda;
	wire i2c_scl;
	i2c_controller master (
		.clk(clk), 
		.rst(rst), 
		.addr(addr), 
		.data_in(data_in), 
		.enable(enable), 
		.rw(rw), 
		.data_out(data_out), 
		.ready(ready), 
		.i2c_sda(i2c_sda), 
		.i2c_scl(i2c_scl)
	);
		
	i2c_slave_controller slave (
    .i2c_sda(i2c_sda), 
    .i2c_scl(i2c_scl)
    );
	
	initial begin
		clk = 0;
		forever #1 clk =  ~clk;	
	end
	
	initial begin
    clk = 0; rst = 1;
    #10;
	rst = 0;
    addr = 7'b0101010; data_in = 8'b11111111; rw = 1'b0; enable = 1;
	#10; enable = 0;
    #80; addr = 7'b0101010; rw = 1; enable = 1;
    #100; enable = 0;
    #500
    $finish;
	end
	initial begin
			$monitor ("time = %0t, datain = %b, dataout = %b",$time, data_in, data_out);
			$dumpfile("my_design.vcd");
    		$dumpvars(0, i2c_controller_tb);
    	end	
endmodule
