//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles
    
    // initialize the counter
    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;
    
    always @(posedge clk ) begin
        positiveedge <= 0;
        negativeedge <= 0;
        if(conditioned == synchronizer1)
            counter <= 0;
        else begin
            if( counter == waittime) begin
                counter <= 0;
                if(conditioned==1 && synchronizer1 == 0) begin
                    negativeedge <= 1;
                end

                if(conditioned==0 && synchronizer1 == 1) begin
                    positiveedge <= 1;
                end

                conditioned <= synchronizer1;
            end
            else 
                counter <= counter+1;
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
    end



    // // At the positive edge, set positivedge to high
    // always @(posedge clk) begin
    //     positiveedge <= 1;
    //     negativeedge <= 0;
    // end

    // // At the negative edge, set negativedge to high
    // always @(negedge clk) begin
    //     positiveedge <= 0;
    //     negativeedge <= 1;
    // end



endmodule
