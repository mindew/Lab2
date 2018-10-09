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

        // // SB Indicates should be
        // // Test case 1, conditioned 1, posedge 1, negedge 0    
        // $display("Conditioned | Posedge | Negedge | SB Conditioned | SB Posedge | SB Negedge");
        // clk=clk;pin=1;#1000
        // $display("%b | %b | %b | 1 | 1 | 0",  conditioned, rising, falling);



        // Test case 2, conditioned 2, posedge 1, 
        $finish();


    end
    
endmodule
