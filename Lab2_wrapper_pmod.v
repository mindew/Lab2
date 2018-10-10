// //-----------------------------------------------------------------------------
// //  Wrapper for Lab 2
// // 
// //  Rationale: 
// //     The ZYBO board has 4 buttons, 4 switches, and 4 LEDs. But if we want to
// //     show the results of a 4-bit add operation, we will need at least 6 LEDs!
// //
// //     This wrapper module assumes the use of the Pmod 8LD LED module and the
// //     Pmod SWT switch module. In the following code the 8LD is plugged into JE
// //     (bottom left) and the SWT is plugged into the top half of JA (right side),
// //     but you can change that in code.
// //
// //  Your job:
// //     This file inciates the shiftregister and interfaces with the
// //     switches and LEDs.
// //
// //     Note: Be sure to un-comment the appropriate ports in your project XDC
// //     constraint file: sw, ja_p, led, je
// //
// //     Note: Buttons, switches, and LEDs have the least-significant (0) position
// //     labeled (usually on the right, except the SWT Pmod).      
// //-----------------------------------------------------------------------------

// `timescale 1ns / 1ps

// `include "shiftregister.v"


// module lab2_wrapper_pmod
// #(parameter width = 8)
// #(parameter frameSize = 4)
// (
//     input  [3:0] sw,        // Built-in switches, used for input value
//     input  [3:0] btn,       // Built-in buttons, used to change led values
//     input  [3:0] ja_p,      // Plug SWT into top half of JA, used for input opB
//     output [3:0] led,       // Built-in LED, used to display opA for sanity checking
//     output [7:0] je         // Plug LD8 into JE, used to display sum, cout, overflow
// );


//     wire clk,peripheralClkEdge, parallelLoad, serialDataIn;
//     wire[width-1:0] parallelDataIn;
//     wire[frameSize-1:0] valsToShow; 

//     wire[width-1:0] parallelDataOut;
//     wire serialDataOut;
    
//     // Assign logical signals to physical ports (change these if you move the Pmods)
//     assign opA = sw;
//     assign opB = ja_p;

//     assign je[3:0] = sum;
//     assign je[5:4] = 2'b0;    // Unused 
//     assign je[6] = cout;
//     assign je[7] = ovf;

//     always @(btn[0]) begin

//         // Setting the LEDs

//         valsToShow = {parallelDataOut[0], parallelDataOut[1], parallelDataOut[2], parallelDataOut[3]};
        
//         assign led = valsToShow;// opA;   // Echo opA to built-in LEDs for debugging
           
//     end

//     shiftregister shiftregister(.parallelDataOut(parallelDataOut), .serialDataOut(serialDataOut), .clk(clk), .peripheralClkEdge(peripheralClkEdge), .serialDataIn(serialDataIn), .parallelDataIn(parallelDataIn), .parallelLoad(parallelLoad) );
        
// endmodule

