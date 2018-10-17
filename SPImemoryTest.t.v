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
		if( dut.fsm1.state != 3'b000) begin
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
		// Data: 11000000 and in write state

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


		// check that we are now in the WRITE state
    	if( dut.fsm1.state != 3'b100) begin
			$display("Test 3 failed. Is %b should be 3'100", dut.fsm1.state);
		end


		// Check the data value in the data memory
		if( dut.dm.address != 7'b1100000) begin // Change variable address value
			$display("Test 4 failed. Is %b should be 7'b1100000", dut.dm.address);
		end

		// check if parallelout in write mode is as same as the data memory
		// Data: 11000000
		// Write State --> Data memory == 11000000
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
		$display("memory is %b", dut.dm.memory[dut.dm.address]);
		$display("State is %b", dut.fsm1.state);
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
		mosi_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		// last bit is a 1 to tell it to go to READ state
		cs_pin = 0;
		mosi_pin = 1;

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		$display("memory is %b", dut.dm.memory[dut.dm.address]);
		$display("hiya State is %b", dut.fsm1.state);
		$display("hiya State is %b", dut.fsm1.shift_register_output);

		// check if read state is functioning
		// DataIn : 10100111 expected parallel data out: 10100111
		if(dut.sr1.parallelDataOut != 8'b10100111) begin
			$display("Test 6 failed. Is %b should be 8'10100111", dut.sr1.parallelDataOut);
		end

		// if(dut.miso_pin != 8'b10100111) begin
		// 	$display("Test 7 failed. Is %b should be 8'1010011 %b", dut.miso_pin,dut.fsm1.state);
		// end


		// gives two clock periods
		// MISO should be equal to data input
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		$display("hi %b %b %b %b %b", dut.sr1.serialDataOut, dut.miso_bufe, dut.fsm1.state, dut.miso_pin, dut.sr1.parallelDataOut);

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		$display("%b %b %b %b %b", dut.sr1.serialDataOut, dut.miso_bufe, dut.fsm1.state, dut.miso_pin, dut.sr1.parallelDataOut);

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		$display("%b %b %b %b %b", dut.sr1.serialDataOut, dut.miso_bufe, dut.fsm1.state, dut.miso_pin, dut.sr1.parallelDataOut);

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		$display("%b %b %b %b %b", dut.sr1.serialDataOut, dut.miso_bufe, dut.fsm1.state, dut.miso_pin, dut.sr1.parallelDataOut);

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		$display("%b %b %b %b %b", dut.sr1.serialDataOut, dut.miso_bufe, dut.fsm1.state, dut.miso_pin, dut.sr1.parallelDataOut);

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		$display("%b %b %b %b %b", dut.sr1.serialDataOut, dut.miso_bufe, dut.fsm1.state, dut.miso_pin, dut.sr1.parallelDataOut);

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		$display("%b %b %b %b %b", dut.sr1.serialDataOut, dut.miso_bufe, dut.fsm1.state, dut.miso_pin, dut.sr1.parallelDataOut);

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		$display("%b %b %b %b %b", dut.sr1.serialDataOut, dut.miso_bufe, dut.fsm1.state, dut.miso_pin, dut.sr1.parallelDataOut);

		sclk_pin = 0; #1000
		sclk_pin = 1; #1000
		$display("%b %b %b %b %b", dut.miso_pin, dut.miso_bufe, dut.fsm1.state, dut.miso_pin, dut.sr1.parallelDataOut);
		$display("%b", dut.al.q);
		$display("%b", dut.dm.address);
		$display("%b", dut.dm.dataIn);
		$display("%b", dut.dm.dataOut);
		$display("%b", dut.dm.writeEnable);




		sclk_pin = 0; #1000
		// sclk_pin = 1; #1000
		// sclk_pin = 0; #1000
		// sclk_pin = 1; #1000
		// sclk_pin = 0; #1000
		// sclk_pin = 1; #1000
		// sclk_pin = 0; #1000
		// sclk_pin = 1; #1000
		// sclk_pin = 0; #1000
		// sclk_pin = 1; #1000
		// sclk_pin = 0; #1000
		// sclk_pin = 1; #1000
		// sclk_pin = 0; #1000
		// sclk_pin = 1; #1000

		$display("%b %b %b %b", dut.sr1.serialDataOut, dut.miso_bufe, dut.fsm1.state, dut.miso_pin);

		if(dut.miso_pin != 1'b1) begin
			$display("Test 7 failed. Is %b should be 1'b1 %b", dut.miso_pin,dut.fsm1.state);
		end

		// Read State --> Give it 10100111 000< Parallel Data out should be equal == 1010011
		// MISO --> After 2 clock periods, miso should be equal to 1010011
	  $finish();



	end





endmodule
