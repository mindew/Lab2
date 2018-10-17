`include "spimemory.v"
// Reference: State values

// `define START  3'd0 = 000
// `define GET_BITS  3'd1 = 001
// `define READ1  3'd2 = 010
// `define READ2  3'd3 = 011
// `define WRITE  3'd4 = 100
// `define END  3'd5 = 101



module SPImemoryTest ();

	wire miso_pin;
	reg mosi_pin;
	reg cs_pin;
	reg sclk_pin;
	reg clk;



	// make instance
	spimemory dut(.clk(clk), .sclk_pin(sclk_pin), .cs_pin(cs_pin), .miso_pin(miso_pin), .mosi_pin(mosi_pin));
	// miso is the output, everything else is an input

	// make inital clock

	initial begin
		clk = 0;
	end

	always begin
		#10 clk = !clk;
		// making the clock toggle
	end

	initial begin


	  $dumpfile("SPImemoryTest.vcd");
	  $dumpvars();


		// Test 1, confirm we are in START state

		cs_pin = 1;
		mosi_pin=0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		if( dut.fsm1.state != 3'b000) begin
			$display("Test 1 failed. Is %b should be 3'b000", dut.fsm1.state);
		end


		// We start with CS high
		// Test 2
		// Check that we have moved to the GET_BITS state

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		if( dut.fsm1.state != 3'b001) begin
			$display("Test 2 failed. Is %b should be 3'b001", dut.fsm1.state);
		end


		// Test 4
		// Data: 11000000 as the address

		cs_pin = 0;
		mosi_pin = 1;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 1;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		// go to the WRITE state
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000


		// check that we are now in the WRITE state
    	if( dut.fsm1.state != 3'b100) begin
			$display("Test 3 failed. Is %b should be 3'100", dut.fsm1.state);
		end


		// Check the address in the data memory has been set from these bits
		if( dut.dm.address != 7'b1100000) begin // Change variable address value
			$display("Test 4 failed. Is %b should be 7'b1100000", dut.dm.address);
		end

		// check if parallelout in write mode is as same as the address value
		if(dut.sr1.parallelDataOut != 8'b11000000) begin
			$display("Test 5 failed. Is %b should be 8'11000000", dut.sr1.parallelDataOut);
		end


		// now start writing a value of 00110000 to data memory
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		mosi_pin = 1;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		mosi_pin = 1;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		// confirm that 00110000 has been written to the data memory at the specified address
		if(dut.dm.memory[dut.dm.address] == 00110000)begin
			$display("Test 5b failed. Is %b, should be 8'00110000", dut.dm.memory[dut.dm.address]);
		end

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		// reset fsm back to START state, then set chip select to low to start GET_BITS
		cs_pin = 1;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		cs_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		// start second iteration of GET_BITS, put in same address to now read the value stored there
		mosi_pin = 1;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 1;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		cs_pin = 0;
		mosi_pin = 1;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		// last bit is a 1 to tell it to go to READ state
		cs_pin = 0;
		mosi_pin = 1;

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		// check if we are in the read state
		if(dut.fsm1.state != 8'b010) begin
			$display("Test 6 failed. Is %b should be 8'010", dut.fsm1.state);
		end

	  $finish();



	end





endmodule
