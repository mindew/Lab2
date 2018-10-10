//-----------------------------------------------------------------------------
//  Wrapper for Lab 0: Full Adder using additional Pmod I/Os
// 
//  Rationale: 
//     The ZYBO board has 4 buttons, 4 switches, and 4 LEDs. But if we want to
//     show the results of a 4-bit add operation, we will need at least 6 LEDs!
//
//     This wrapper module assumes the use of the Pmod 8LD LED module and the
//     Pmod SWT switch module. In the following code the 8LD is plugged into JE
//     (bottom left) and the SWT is plugged into the top half of JA (right side),
//     but you can change that in code.
//
//  Your job:
//     Write FullAdder4bit with the proper port signature. It will be instantiated
//     by the lab0_wrapper_pmod module in this file, which interfaces with the
//     switches and LEDs for you.
//
//     Note: Be sure to un-comment the appropriate ports in your project XDC
//     constraint file: sw, ja_p, led, je
//
//     Note: Buttons, switches, and LEDs have the least-significant (0) position
//     labeled (usually on the right, except the SWT Pmod).      
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps

`include "adder.v"


module lab0_wrapper_pmod
(
    input  [3:0] sw,        // Built-in switches, used for input opA
    input  [3:0] ja_p,      // Plug SWT into top half of JA, used for input opB
    output [3:0] led,       // Built-in LED, used to display opA for sanity checking
    output [7:0] je         // Plug LD8 into JE, used to display sum, cout, overflow
);

    wire[3:0] opA, opB;       // Inputs to adder
    wire[3:0] sum;            // Output from adder
    wire cout;                // Carry out from adder
    wire ovf;                 // Overflow from adder
    
    // Assign logical signals to physical ports (change these if you move the Pmods)
    assign opA = sw;
    assign opB = ja_p;

    assign je[3:0] = sum;
    assign je[5:4] = 2'b0;    // Unused 
    assign je[6] = cout;
    assign je[7] = ovf;
    
    assign led = opA;   // Echo opA to built-in LEDs for debugging
       
    // TODO: You write the body of your FullAdder4bit module in adder.v
    FullAdder4bit adder(.sum(sum), .carryout(cout), .overflow(ovf), .a(opA), .b(opB));
        
endmodule
