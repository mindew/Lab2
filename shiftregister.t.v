`include "shiftregister.v"
//`timescale 1ns/1ps
// Shift Register test bench
module testshiftregister();

    wire             clk;    
    reg             peripheralClkEdge;      // 1 = you're at clock edge
    reg             parallelLoad;           // 1 = Load shift reg with parallelDataIn
    wire[7:0]       parallelDataOut;        // shifted reg data contents
    wire            serialDataOut;          // Positive edge synchronized
    reg[7:0]        parallelDataIn;         // load shift reg in parallel
    reg             serialDataIn;           // load shift reg in serial

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
input reg           clk,                    // FPGA clock
input                   peripheralClkEdge,      // 1 = you're at clock edge
input                   parallelLoad,           // 1 = Load shift reg with parallelDataIn
output  reg[7:0]        parallelDataOut,        // shifted reg data contents
output  reg[7:0]        serialDataOut,          // Positive edge synchronized
input[7:0]              parallelDataIn,         // load shift reg in parallel
input                   serialDataIn,           // load shift reg in serial

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

    always @(posedge begintest) begin
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
        #5 Clk = 1;  #5 Clk = 0;    // Generate single clock pulse
        
        #100

        if((parallelDataOut !== 00000001) || (serialDataOut !== 0)) begin
            $display("Test Case 1 Failed");
        end

        #5
        endtest =1;


    end
endmodule 
