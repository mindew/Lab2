`include "shiftregister.v"
`include "inputconditioner.v"
`include "fsm.v"
`include "datamemory.v"
`include "addressLatch.v"
`include "dff.v"
`include "tri_buf.v"
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

  wire conditioned1, posedge1, negedge1;
  wire conditioned2, posedge2, negedge2;
  wire conditioned3, posedge3, negedge3;
  wire[7:0] parallelDataOut, datamemoryout, address;
  wire serialDataOut, miso_bufe, dm_we, addr_we, sr_we;
  wire q;

  inputconditioner ic1(clk, mosi_pin, conditioned1, posedge1, negedge1);
  inputconditioner ic2(clk, sclk_pin, conditioned2, posedge2, negedge2);
  inputconditioner ic3(clk, cs_pin, conditioned3, posedge3, negedge3);

  fsm fsm1(posedge2, conditioned3, parallelDataOut[0], miso_bufe, dm_we, addr_we, sr_we);

  addressLatch al(clk, addr_we, parallelDataOut, address);

  datamemory dm(clk, datamemoryout, address[6:0], dm_we, parallelDataOut);

  shiftregister sr1(clk, posedge2, sr_we, datamemoryout, conditioned1, parallelDataOut, serialDataOut);

  dff dfq(clk, negedge2,serialDataOut,q);

  tri_buf buffer(q,miso_pin,miso_bufe);


endmodule
