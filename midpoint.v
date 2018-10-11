// //-----------------------------------------------------------------------------
// //  Wrapper for Lab 2
// // 
// //  Rationale: 
// //     The ZYBO board has 4 buttons, 4 switches, and 4 LEDs. But if we want to
// //     show the results of a 4-bit add operation, we will need at least 6 LEDs!
// //
// //     This wrapper module allows for 4-bit operands to be loaded in one at a
// //     time, and multiplexes the LEDs to show the SUM and carryout/overflow at
// //     different times.
// //
// //  Your job:
// //     Write FullAdder4bit with the proper port signature. It will be instantiated
// //     by the lab0_wrapper module in this file, which interfaces with the buttons,
// //     switches, and LEDs for you.
// //
// //  Usage:
// //     btn0 - load operand A from the current switch configuration
// //     btn1 - load operand B from the current switch configuration
// //     btn2 - show SUM on LEDs
// //     btn3 - show carryout on led0, overflow on led1
// //
// //     Note: Buttons, switches, and LEDs have the least-significant (0) position
// //     on the right.      
// //-----------------------------------------------------------------------------


`timescale 1ns / 1ps

`include "shiftregister.v"
`include "inputconditioner.v"



module dff #( parameter W = 1 )
(
    input trigger,
    input enable,
    input      [W-1:0] d,
    output reg [W-1:0] q
);
    always @(posedge trigger) begin
        if(enable) begin
            q <= d;
        end 
    end
endmodule

// JK flip-flop
module jkff1
(
    input trigger,
    input j,
    input k,
    output reg q
);
    always @(posedge trigger) begin
        if(j && ~k) begin
            q <= 1'b1;
        end
        else if(k && ~j) begin
            q <= 1'b0;
        end
        else if(k && j) begin
            q <= ~q;
        end
    end
endmodule

// Two-input MUX with parameterized bit width (default: 1-bit)
module mux2 #( parameter W = 1 )
(
    input[W-1:0]    in0,
    input[W-1:0]    in1,
    input           sel,
    output[W-1:0]   out
);
    // Conditional operator - http://www.verilog.renerta.com/source/vrg00010.htm
    assign out = (sel) ? in1 : in0;
endmodule




module lab2_wrapper
#(parameter width = 8, frameSize = 4)
(
    input        clk,
    input  [1:0] sw,
    input  [2:0] btn,
    output [3:0] led
);

    wire clk,peripheralClkEdge, parallelLoad, serialDataIn;
    wire[width-1:0] parallelDataIn;
    wire[frameSize-1:0] valsToShow;
    wire[3:0] res0, res1;     // Output display options
    wire res_sel;             // Select between display options
    wire conditionedS0, positiveedge0, negativeedge0, conditionedS1, positiveedge1, negativeedge1, conditionedB0, positiveedge2, negativeedge2, conditionedB1, positiveedge3, negativeedge3;


    wire[width-1:0] parallelDataOut;
    wire serialDataOut;


   
    inputconditioner switch0(.conditioned(conditionedS0), .positiveedge(positiveedge0), .negativeedge(negativeedge0), .clk(clk), .noisysignal(sw[0])); 
    inputconditioner switch1(.conditioned(conditionedS1), .positiveedge(positiveedge1), .negativeedge(negativeedge1), .clk(clk), .noisysignal(sw[1])); 
    inputconditioner button0(.conditioned(conditionedB0), .positiveedge(positiveedge2), .negativeedge(negativeedge2), .clk(clk), .noisysignal(btn[0]));
    // inputconditioner button1(.conditioned(conditionedB1), .positiveedge(positiveedge3), .negativeedge(negativeedge3), .clk(clk), .noisysignal(btn[1]));
    

//    // Memory for stored inputs (parametric width set to 4 bits)
//    dff #(4) sRes_mem1(.trigger(clk), .enable(btn[0]), .d(conditionedS0), .q(serialDataIn));
//    dff #(4) sRes_mem2(.trigger(clk), .enable(btn[1]), .d(conditionedS1), .q(serialDataIn));
    
    parameter parallelIn = 8'hA5;
    shiftregister #(8) shiftregister(.parallelDataOut(parallelDataOut), .serialDataOut(serialDataOut), .clk(clk), .peripheralClkEdge(positiveedge1), .serialDataIn(conditionedS0), .parallelDataIn(parallelIn), .parallelLoad(negativeedge2) );
    // Capture button input to switch which MUX input to LEDs
    jkff1 src_sel(.trigger(clk), .j(btn[2]), .k(btn[1]), .q(res_sel));
    mux2 #(4) output_select(.in0(res0), .in1(res1), .sel(res_sel), .out(led));
    



    // Assign bits of second display output to show carry out and overflow
    assign res1[0] = parallelDataOut[0];
    assign res1[1] = parallelDataOut[1];
    assign res1[2] = parallelDataOut[2];
    assign res1[3] = parallelDataOut[3];

    assign res0[0] = parallelDataOut[4];
    assign res0[1] = parallelDataOut[5];
    assign res0[2] = parallelDataOut[6];
    assign res0[3] = parallelDataOut[7];


endmodule

