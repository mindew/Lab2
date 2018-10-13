`define START  3'd0
`define GET_BITS  3'd1
`define READ  3'd2
`define WRITE  3'd3
`define END  3'd4

module fsm(
  input sclk,
  input cs,
  input shift_register_output,
  output reg miso_bufe,
  output reg dm_we,
  output reg addr_we,
  output reg sr_we);

  reg [2:0] state;
  reg [2:0] count <= 3'd0;

  always @(posedge sclk) begin
    if (state == 3'dx)
      state <= 'START;
    case(state)
      'START begin
        if (cs == 0)
          state <= 'GET_BITS;
        else
          state <= 'START;
      end
      'GET_BITS begin
        if (count < 7)
          count <= count + 1;
        else if (count == 7) begin
          if (shift_register_output == 1'dx)
            count <= count;
          else if (shift_register_output == 1) begin
            count <= 0;
            state <= 'READ;
          end
          else if (shift_register_output == 0) begin
            count <= 0;
            state <= 'WRITE;
          end
        end
      end
      'READ begin
      end
      'WRITE begin
      end
      'END begin
      end
    end

endmodule
