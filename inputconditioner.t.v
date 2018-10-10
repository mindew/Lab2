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
    
    reg begintest;
    wire endtest;
    wire dutpassed;
    
    inputconditionerDUT dut
    (
        .begintest(begintest),
        .endtest(endtest),
        .dutpassed(dutpassed),
        .clk(clk),
        .noisysignal(pin),
        .conditioned(conditioned),
        .positiveedge(rising),
        .negativeedge(falling)
    );

    // testConditionerTestBench tester
    // (

    //     .clk(clk),
    //     .noisysignal(pin),
    //     .positiveedge(rising),
    //     .negativeedge(falling)
    // );

    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock
    

    always @(endtest) begin
        $display("Test passed?: %b", dutpassed);
    end

endmodule



        // // // SB Indicates should be
        // // // Test case 1, conditioned 1, posedge 1, negedge 0    
        // // $display("Conditioned | Posedge | Negedge | SB Conditioned | SB Posedge | SB Negedge");
        // clk=clk;pin=1;#1000
        // $display("%b | %b | %b | 1 | 1 | 0",  conditioned, rising, falling);

module inputconditionerDUT
(
input begintest,
output reg  endtest,
output reg  dutpassed,

input noisysignal,
output reg conditioned,
output reg positiveedge,
output reg negativeedge,
output reg clk
);

initial begin
    positiveedge = 0;
    negativeedge = 0;
    conditioned = 0;
end


initial @(begintest) begin
    $dumpfilie("inputconditioner.vcd");
    $dumpvars;
    endtest = 0;
    dutpassed = 1;
    #50

    conditioned = 1; positiveedge = 1; negativeedge = 0;
    if(( conditioned != 1 ) || (positiveedge != 1) || (negativeedge != 0)) begin
        dutpassed = 0;
        $display("Test case 1, 1, 0 failed and got %b %b %b", conditioned, positiveedge, negativeedge);
    end
        // $dumpfile("inputconditioner.vcd");
        // $dumpvars();       

        // $finish();


    #5
    endtest = 1;
    $finish;
    end
    

endmodule