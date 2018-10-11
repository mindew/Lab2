`include "shiftregister.v"
`timescale 1ns/1ps
// Shift Register test bench
module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;      // 1 = you're at clock edge
    reg             parallelLoad;           // 1 = Load shift reg with parallelDataIn
    wire[7:0]       parallelDataOut;        // shifted reg data contents
    wire            serialDataOut;          // Positive edge synchronized
    reg[7:0]        parallelDataIn;         // load shift reg in parallel
    reg             serialDataIn;           // load shift reg in serial


    // Instantiate with parameter width = 8
    shiftregister #(8) dut
    (
        .clk(clk),
    	.peripheralClkEdge(peripheralClkEdge),
    	.parallelLoad(parallelLoad),
    	.parallelDataIn(parallelDataIn),
    	.serialDataIn(serialDataIn),
    	.parallelDataOut(parallelDataOut),
    	.serialDataOut(serialDataOut)
    );

initial clk=0;
always #10 clk=!clk;

initial begin
  $dumpfile("shiftregister.vcd");
  $dumpvars();

  // Test Case 1:
  // Parallel = 10000000, Serial = 1
  // Parallel output = 00000001, seerial output = 0;
  parallelLoad = 1'b0;
  parallelDataIn = 8'b10000000;
  peripheralClkEdge = 1;
  serialDataIn=1; #20

  if((parallelDataOut !== 00000001) || (serialDataOut !== 0)) begin
      $display("Test Case 1 Failed %b %b", parallelDataOut, serialDataOut);
  end


  $finish();


end

endmodule
