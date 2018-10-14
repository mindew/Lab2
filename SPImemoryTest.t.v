



module SPImemoryTest ();

	wire miso_pin;
	reg mosi_pin;
	reg cs_pin;
	reg sclk_pin;
	reg clk;

	//inputs etc.


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

		cs_pin = 0;
		sclk_pin = 0; #1000
		sclk_pin = 0; 

		if( dut.statemachine.currentState != 7'b0000000) begin// NEED TO CHANGE TO ACTUAL VARIABE NAMES
			$displayb("Test 1 failed. Is %b should be 7'b0000000", dut.statemachine.currentState);
		end
		

		// We start with CS high
		// Test 2

		cs_pin = 1;
		sclk_pin = 0; #1000
		sclk_pin = 1; #1000

		if( dut.statemachine.currentState != 7'b0000001) begin// NEED TO CHANGE TO ACTUAL VARIABE NAMES
			$displayb("Test 2 failed. Is %b should be 7'b0000001", dut.statemachine.currentState);
		end

		// Start presenting address bits 7'b1010101
		cs = 0;
		sclk = 0; mosi_pin = 0; #1000
		sclk = 1; #1000

		if(dut.fsm.state != 6'b000010) begin
			$displayb("Test failed: the state is expected to be receive, state is actually %b at time %t", dut.fsm.state, $time);
		end



	  $finish();



	end





endmodule