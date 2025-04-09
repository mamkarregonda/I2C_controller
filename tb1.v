`timescale 10ns / 1ns

module i2c_controller_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [6:0] addr;
    reg [7:0] data_in;
    reg enable;
    reg rw;

    // Outputs
    wire [7:0] data_out;
    wire ready;

    // Bidirs
    wire i2c_sda;
    wire i2c_scl;

    // Instantiate the Unit Under Test (UUT)
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
        forever #5 clk = ~clk; // 10ns period clock
    end

    initial begin
        // Initialize Inputs
        rst = 1;
        addr = 7'b0;
        data_in = 8'b0;
        enable = 0;
        rw = 1'b0;

        // Apply reset
        #20;
        rst = 0;

        // Test Case 1: Write operation
        #50;
        addr = 7'b0101010; data_in = 8'hAA; rw = 1'b0; enable = 1; // Write	
        #50;
        enable = 0;

        // Test Case 2: Read operation
        #100;
        addr = 7'b0101010;
        rw = 1'b1; // Read
        enable = 1;
        #100;
        enable = 0;

        // Test Case 3: Write to a different address
        #150;
        addr = 7'b1010101;
        data_in = 8'h55;
        rw = 1'b0; // Write
        enable = 1;
        #50;
        enable = 0;

        // Test Case 4: Read from the same address.
        #100;
        addr = 7'b1010101;
        rw = 1'b1;
        enable = 1;
        #100;
        enable = 0;

        // Test case 5: Write zero's to an address
        #150;
        addr = 7'b0101010;
        data_in = 8'b00000000;
        rw = 1'b0;
        enable = 1;
        #50;
        enable = 0;

        // Test case 6: Read zero's from the same address.
        #100;
        addr = 7'b0101010;
        rw = 1'b1;
        enable = 1;
        #100;
        enable = 0;

        #500;
        $finish;
    end

    initial begin
		$monitor ("time = %0t, datain = %b, dataout = %b",$time, data_in, data_out);
        //$monitor("Time=%0t, Addr=%b, DataIn=%b, DataOut=%b, RW=%b, Enable=%b, Ready=%b", $time, addr, data_in, data_out, rw, enable, ready);
        $dumpfile("i2c_test.vcd");
        $dumpvars(0, i2c_controller_tb);
    end

endmodule