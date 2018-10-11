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
  // Test code
  parallelLoad = 1;
  parallelDataIn = 8'b00000000; #50
  $display("serial out %b", serialDataOut);
  $display("data out %b", parallelDataOut);

  // Test Case 1:
  // Parallel = 10000000, Serial = 1
  // Parallel output = 00000001, seerial output = 0;
  parallelLoad = 1'b0;
  parallelDataIn = 8'b10000000;
  peripheralClkEdge = 0;
  serialDataIn = 1;   #50
  peripheralClkEdge = 1; #10
  peripheralClkEdge = 0;

<<<<<<< HEAD
module shifttest
(
output reg              clk,                    // FPGA clock
output reg              peripheralClkEdge,      // 1 = you're at clock edge
output reg              parallelLoad,           // 1 = Load shift reg with parallelDataIn
input [7:0]             parallelDataOut,        // shifted reg data contents
input                   serialDataOut,          // Positive edge synchronized
output reg[7:0]         parallelDataIn,         // load shift reg in parallel
output reg              serialDataIn,           // load shift reg in serial
=======
  if((parallelDataOut !== 00000001) || (serialDataOut !== 0)) begin
      $display("Test Case 1 Failed %b %b", parallelDataOut, serialDataOut);
  end
>>>>>>> e38c02ff2d4055346a0691a33ac6b2245b12d9be


  $finish();



end

<<<<<<< HEAD

    // always @(posedge clk) begin
        // Test Case 1:
        // Parallel = 10000000, Serial = 1
        // Parallel output = 00000001, seerial output = 0;
        peripheralClkEdge = 1'b1;
        parallelLoad = 1'b0;
        parallelDataIn = 8'b10000000;
        serialDataIn = 1'b1;
        #5 clk = 1;  #5 clk = 0;    // Generate single clock pulse
        
        #100

        if((parallelDataOut !== 00000001) || (serialDataOut !== 0)) begin
            $display("Test Case 1 Failed %b %b", parallelDataOut, serialDataOut);
        end

        #5
        endtest =1;


    end
endmodule 
=======
endmodule
>>>>>>> e38c02ff2d4055346a0691a33ac6b2245b12d9be
