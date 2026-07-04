module uart_tx #(parameter CLK_HZ = 125000000,
                 parameter BAUD = 115200) (input       clk,
                                           input       start,
                                           input [7:0] data,
                                           output reg  tx,
                                           output reg  busy);

   localparam integer CLKS_PER_BIT = CLK_HZ / BAUD;

   // states
   localparam         IDLE = 2'd0;
   localparam         START = 2'd1;
   localparam         DATA = 2'd2;
   localparam         STOP = 2'd3;

   reg [1:0]          state = IDLE;
   reg [31:0]         clk_count = 0;
   reg [2:0]          bit_index = 0;
   reg [7:0]          data_reg = 0;

   initial begin
      tx = 1'b1;
      busy = 1'b0;
   end

   always @(posedge clk) begin
      case (state)
        IDLE: begin
           tx <= 1'b1;
           busy <= 1'b0;
           clk_count <= 0;
           bit_index <= 0;

           if (start) begin
              data_reg <= data;
              busy <= 1'b1;
              state = START;
           end
        end // case: IDLE

        START: begin
           tx <= 1'b0;
           if (clk_count == CLKS_PER_BIT - 1) begin
              clk_count <= 0;
              state <= DATA;
           end else begin
              clk_count <= clk_count + 1;
           end
        end

        DATA: begin
           tx <= data_reg[bit_index];
           if (clk_count == CLKS_PER_BIT - 1) begin
              clk_count <= 0;

              if (bit_index == 7) begin
                 bit_index <= 0;
                 state <= STOP;
              end else begin
                 bit_index <= bit_index + 1;
              end
           end else begin
              clk_count <= clk_count + 1;
           end // else: !if(clk_count == CLKS_PER_BIT - 1)
        end // case: DATA

        STOP: begin
           tx <= 1'b1;
           if (clk_count == CLKS_PER_BIT - 1) begin
              clk_count <= 0;
              state <= IDLE;
           end else begin
              clk_count <= clk_count + 1;
           end
        end
      endcase // case (state)
   end // always @ (posedge clk)

endmodule
