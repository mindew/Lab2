//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

module spiMemory
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
initial begin
	cs_pin = 0;
	sclk_pin = 0;
	mosi_pin = 1;
	miso_pin = 0; 
end

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






endmodule
   
