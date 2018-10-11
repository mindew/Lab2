`include "shiftregister.v"
//`timescale 1ns/1ps
// Shift Register test bench
module testshiftregister();

    wire             clk;    
    wire             peripheralClkEdge;      // 1 = you're at clock edge
    wire             parallelLoad;           // 1 = Load shift reg with parallelDataIn
    wire[7:0]       parallelDataOut;        // shifted reg data contents
    wire            serialDataOut;          // Positive edge synchronized
    wire[7:0]        parallelDataIn;         // load shift reg in parallel
    wire             serialDataIn;           // load shift reg in serial

    reg             begintest;
    wire            endtest;
    wire            dutpassed;


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

    shifttest #(8) tester
    (
        .clk(clk),
        .peripheralClkEdge(peripheralClkEdge),
        .parallelLoad(parallelLoad),
        .parallelDataIn(parallelDataIn),
        .serialDataIn(serialDataIn),
        .parallelDataOut(parallelDataOut),
        .serialDataOut(serialDataOut),
        .begintest(begintest),
        .endtest(endtest),
        .dutpassed(dutpassed)
    );

    // initial clk=0;
    // always #10 clk=!clk;

    // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
    initial begin
        begintest = 0;
        #10;
        begintest = 1;
        #1000;  
    end

    // Display test results ('dutpassed' signal) once 'endtest' goes high
    always @(posedge endtest) begin
        $display("DUT passed?: %b", dutpassed);
    end
endmodule


module shifttest
(
output reg           clk,                    // FPGA clock
output reg                   peripheralClkEdge,      // 1 = you're at clock edge
output reg                   parallelLoad,           // 1 = Load shift reg with parallelDataIn
input [7:0]        parallelDataOut,        // shifted reg data contents
input        serialDataOut,          // Positive edge synchronized
output reg[7:0]              parallelDataIn,         // load shift reg in parallel
output reg              serialDataIn,           // load shift reg in serial

input                   begintest,              // Triggers start of testing
output  reg             endtest,                // Raise once test completes
output  reg             dutpassed               // signal test result
);


    // things need to be in shiftregister
    // clk, peripheralClkEdge, parallelLoad, parallelDatain, serialDataIn
    initial begin
        peripheralClkEdge = 1'b0;
        parallelLoad = 1'b0;
    	parallelDataIn = 8'b00000000;      
        serialDataIn = 1'b0;
        clk=0;
    end

    always @(begintest) begin
        endtest = 0;
        dutpassed = 1;
        #10



    // always @(posedge clk) begin
        // Test Case 1:
        // Parallel = 10000000, Serial = 1
        // Parallel output = 00000001, seerial output = 0;
        peripheralClkEdge = 1'b1;
        parallelLoad = 1'b1;
        parallelDataIn = 8'b10000000;
        serialDataIn = 1'b1;
        #5 clk = 1;  #5 clk = 0;    // Generate single clock pulse
    

        if((parallelDataOut !== 00000001) || (serialDataOut !== 0)) begin
            $display("%d, %d, %d", clk, parallelDataIn, serialDataOut);
        end

        #5
        endtest =1;


    end
endmodule 
