module blinky(input      clk,
              input      btn,
              output reg led,
              output     uart_tx);

   reg btn_prev = 0;
   reg uart_start = 0;
   wire uart_busy;

   always @(posedge clk) begin
      led <= uart_busy;
      btn_prev <= btn;

      // no UART start pulse by default
      uart_start <= 1'b0;

      // send one character on rising edge
      if (btn && !btn_prev && !uart_busy)
        uart_start <= 1'b1;
   end

   uart_tx #(
             .CLK_HZ(125000000),
             .BAUD(115200)
             ) uart_tx_inst (
                             .clk(clk),
                             .start(uart_start),
                             .data("X"),
                             .tx(uart_tx),
                             .busy(uart_busy));

endmodule
