



module SPImemoryTest ();

	//inputs etc.


	// make instance
	spimemory dut(.clk(clk), .sclk_pin(sclk_pin), .cs_pin(cs_pin), .miso_pin(miso_pin), .mosi_pin(mosi_pin));

	// make clock


	initial begin


	  $dumpfile("SPImemoryTest.vcd");
	  $dumpvars();

		// Do some tests

		// For each test need to set the clock

		// set cs pin, sclk, , check the state of the fsm or the memory



	  $finish();



	end





endmodule