`include "shiftregister.v"
`include "inputconditioner.v"
`include "fsm.v"
`include "datamemory.v"
`include "addressLatch.v"

//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

module spimemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);

// each transaction begins with the chip select cs line being asserted low
// miso = master in slave out
// mosi = master out slave in
// potentially change the format based on the input values
// should we instantiate those inputs with input conditioner?
// initial begin
// 	cs_pin = 0;
// 	sclk_pin = 0;
// 	mosi_pin = 1;
// 	miso_pin = 0;
// end

  wire conditioned1, posedge1, negedge1;
  wire conditioned2, posedge2, negedge2;
  wire conditioned3, posedge3, negedge3;
  wire[7:0] parallelDataOut, datamemoryout, address;
  wire serialDataOut, miso_bufe, dm_we, addr_we, sr_we;

  inputconditioner ic1(clk, mosi_pin, conditioned1, posedge1, negedge1);
  inputconditioner ic2(clk, sclk_pin, conditioned2, posedge2, negedge2);
  inputconditioner ic3(clk, cs_pin, conditioned3, posedge3, negedge3);

  fsm fsm1(posedge2, conditioned3, parallelDataOut[0], miso_bufe, dm_we, addr_we, sr_we);

  addressLatch al(clk, addr_we, parallelDataOut, address);

  datamemory dm(clk, datamemoryout, address[6:0], dm_we, parallelDataOut);

  shiftregister clkSerialIn(clk, posedge2, sr_we, datamemoryout, conditioned1, parallelDataOut, serialDataOut);

/*
	always @(posedge sclk_pin) begin
		if mosi_pin == 1;
			shiftregister clkSerialIn(clk,, Finite State Machine, SR_WE, DOUT);
			// implement address latch and loop it back to address of data memory
			// SR_WE and DOUT are undefined, yet
		end
	end

	always @(negedge sclk_pin) begin
		dff dffin(clk,sclk_pin,serial_out);
		// implement not gate from q to miso_pin?
		// miso_pin != q of dffin
	end


*/



endmodule
