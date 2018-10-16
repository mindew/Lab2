//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`include "inputconditioner.v"
// `timescale 1ns/1ps
module testConditioner();

    reg clk;
    reg noisysignal;
    wire conditioned;
    wire rising;
    wire falling;
    
    
    inputconditioner inputconditionerDUT
    (
        .clk(clk),
        .noisysignal (noisysignal),
        .conditioned(conditioned),
        .positiveedge(rising),
        .negativeedge(falling)
    );


      // Test harness asserts 'begintest' for 1000 time steps, starting at time 10


    initial begin
        $dumpfile("inputconditioner.vcd");
        $dumpvars();
        noisysignal = 0;
        clk=0;
    end

    // Generate clock (50MHz)
    initial clk = 0;
    always #10 clk = !clk;    // 50MHz Clock


    initial begin


        noisysignal = 0;#5
        
        noisysignal = 1;#20

        if(( conditioned != 1 )) begin
            $display("Conditioned Test case 1 Failed");
        end


        
        noisysignal = 0;#20

        if(( conditioned != 0 )) begin
            $display("Conditioned Test case 2 Failed");
        end



        noisysignal = 1; #5

        if(( inputconditionerDUT.synchronizer0 == 1 )) begin
            $display("Sync Test case 3 Failed");
        end

        #15

        if(( inputconditionerDUT.synchronizer1 == 1 )) begin
            $display("Sync Test case 4 Failed");
        end


        noisysignal = 0; #300
        noisysignal = 1; #5
        noisysignal = 0; #5
        noisysignal = 1; #5
        noisysignal = 0; #5
        noisysignal = 1; #250

        // Expect the conditioned output to be high when the pin input has stabilized.
        if (conditioned != 1) begin
            $display("Debouncing to Rest High Test Case 5 failed.");
        end


        #5
        $finish();
    end
        

        always @(posedge conditioned) begin
            #5;
            if (rising != 1 && $time > 100) begin
                $display("Positive Edge Test Case 6 failed");
            end
        end
        

        always @(negedge conditioned) begin
            #5;
            if (falling != 1 && $time > 100) begin
                $display("Negative Edge Test Case 7 failed");
            end
        end

        

        
endmodule