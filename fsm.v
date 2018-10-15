`define START  3'd0
`define GET_BITS  3'd1
`define READ1  3'd2
`define READ2  3'd3
`define WRITE  3'd4
`define END  3'd5

module fsm
(
  input sclk,
  input cs,
  input shift_register_output,
  output reg miso_bufe,
  output reg dm_we,
  output reg addr_we,
  output reg sr_we
);

  reg [2:0] state;
  reg [2:0] count;

  always @(posedge sclk) begin
    if (state === 3'dx) begin
      state <= `START;
      count <= 3'd0;
    end
    case(state)
      `START: begin
        miso_bufe = 0;
        dm_we = 0;
        addr_we = 0;
        sr_we = 0;
        if (cs == 0)
          state <= `GET_BITS;
        else
          state <= `START;
      end
      `GET_BITS: begin
        sr_we <= 0;
        addr_we <= 1;
        dm_we <= 0;
        miso_bufe <= 0;
        if (count < 7)
          count <= count + 1;
        else if (count == 7) begin
          if (shift_register_output == 1'dx)
            count <= count;
          else if (shift_register_output == 1) begin
            count <= 0;
            state <= `READ1;
          end
          else if (shift_register_output == 0) begin
            count <= 0;
            state <= `WRITE;
          end
        end
      end
      `READ1: begin
        sr_we <= 1;
        dm_we <= 0;
        addr_we <= 0;
        miso_bufe <= 0;
        state <= `READ2;
      end
      `READ2: begin
        sr_we <= 0;
        dm_we <= 0;
        addr_we <= 0;
        miso_bufe <= 1;
        if (count < 7)
          count <= count + 1;
        else if (count == 7) begin
          state <= `END;
          count <= 0;
        end
      end
      `WRITE: begin
        sr_we <= 0;
        dm_we <= 1;
        addr_we <= 0;
        miso_bufe <= 0;
        if (count < 7)
          count <= count + 1;
        else if (count == 7) begin
          state <= `END;
          count <= 0;
        end
      end
      `END: begin
        if (cs == 1)
          state = `START;
        sr_we <= 0;
        dm_we <= 0;
        addr_we <= 0;
        miso_bufe <= 0;
      end
    endcase
    end



endmodule
