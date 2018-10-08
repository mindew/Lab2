//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`include "inputconditioner.v"
module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    
    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));


    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock
    
    initial begin


        $dumpfile("inputconditioner.vcd");
        $dumpvars();

        clk=clk;pin=1;#1000
        $display("%b  %b  %b ",  conditioned, rising, falling);

        $finish();


    end
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronization, Debouncing, Edge Detection
    
endmodule
