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


		// For each test need to set the serial clock: sclk = 0; #1000 sclk = 1; #1000

		// set cs pin, sclk, check the state of the fsm or the memory

		// Want to test the ability of the test finiate state machine to handle each input correctly.

		// 1) When the machine is started is the start bit correct? -> When cs is first low the 7 bits should be empty and the 8th bit is either read or write
		// 2) When the machine is in starte state with the cs high -> the value in the state machine should be 0000001
		// 3) When the machine is in the getting bits state, the value should be 00000010
		// 4) Write 11111 to the machine expect the address to be 11111
		// 5) Write 010101 to the mahcine expect the data memory to have 010101 in it


		// Test 1 (USe this syntax:  dut.dm.memory)

		cs_pin = 1;
		mosi_pin=0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		if( dut.fsm1.state != 3'b000) begin// NEED TO CHANGE TO ACTUAL VARIABE NAMES
			$display("Test 1 failed. Is %b should be 3'b000", dut.fsm1.state);
		end


		// We start with CS high
		// Test 2
		// Data: 0000000 and in start state

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		if( dut.fsm1.state != 3'b001) begin
			$display("Test 2 failed. Is %b should be 3'b001", dut.fsm1.state);
		end


		// Test 4
		// Data: 0000011 and in write state

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

		cs_pin = 0;
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		// Do I have to do this all 7 times, or can I leave some blank?
		// check the writing state
    	if( dut.fsm1.state != 3'b100) begin
			$display("Test 4 failed. Is %b should be 3'100", dut.fsm1.state);
		end


		// Check the data value in the data memory
		if( dut.dm.address != 7'b1000000) begin // Change variable address value
			$display("Test 4 failed. Is %b should be 7'b1000000", dut.dm.address);
		end



	  $finish();



	end





endmodule
