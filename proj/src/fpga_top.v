module fpga_top(
  input         btn,
  output        led,
  output [3:0]  vga_r,
  output [3:0]  vga_g,
  output [3:0]  vga_b,
  output        vga_hsync,
  output        vga_vsync,

  inout [14:0]  DDR_addr,
  inout [2:0]   DDR_ba,
  inout         DDR_cas_n,
  inout         DDR_ck_n,
  inout         DDR_ck_p,
  inout         DDR_cke,
  inout         DDR_cs_n,
  inout [3:0]   DDR_dm,
  inout [31:0]  DDR_dq,
  inout [3:0]   DDR_dqs_n,
  inout [3:0]   DDR_dqs_p,
  inout         DDR_odt,
  inout         DDR_ras_n,
  inout         DDR_reset_n,
  inout         DDR_we_n,

  inout         FIXED_IO_ddr_vrn,
  inout         FIXED_IO_ddr_vrp,
  inout [53:0]  FIXED_IO_mio,
  inout         FIXED_IO_ps_clk,
  inout         FIXED_IO_ps_porb,
  inout         FIXED_IO_ps_srstb
);

   wire clk;

   // vga -> vram port
   wire [12:0] vga_vram_rd_addr;
   wire [7:0]  vga_vram_rd_data;

   // memmap -> vram CPU port
   wire [12:0] cpu_vram_addr;
   wire [7:0]  cpu_vram_rd_data;
   wire [7:0]  cpu_vram_wr_data;
   wire        cpu_vram_we;

  system_wrapper ps_system (
    .FCLK_CLK0_0(clk),

    .DDR_addr(DDR_addr),
    .DDR_ba(DDR_ba),
    .DDR_cas_n(DDR_cas_n),
    .DDR_ck_n(DDR_ck_n),
    .DDR_ck_p(DDR_ck_p),
    .DDR_cke(DDR_cke),
    .DDR_cs_n(DDR_cs_n),
    .DDR_dm(DDR_dm),
    .DDR_dq(DDR_dq),
    .DDR_dqs_n(DDR_dqs_n),
    .DDR_dqs_p(DDR_dqs_p),
    .DDR_odt(DDR_odt),
    .DDR_ras_n(DDR_ras_n),
    .DDR_reset_n(DDR_reset_n),
    .DDR_we_n(DDR_we_n),

    .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
    .FIXED_IO_mio(FIXED_IO_mio),
    .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb)
  );

   blinky user_logic (.clk(clk),
                      .btn(btn),
                      .led(led),
                      .uart_tx());

   vga vga_inst (.clk(clk),
                 .vga_r(vga_r),
                 .vga_g(vga_g),
                 .vga_b(vga_b),
                 .vga_hsync(vga_hsync),
                 .vga_vsync(vga_vsync),
                 .vram_rd_addr(vga_vram_rd_addr),
                 .vram_rd_data(vga_vram_rd_data));

   memmap memmap_inst (.cpu_addr(16'b0),
                       .cpu_rd_data(),
                       .cpu_wr_data(8'b0),
                       .cpu_we(1'b0),

                       .cpu_vram_addr(cpu_vram_addr),
                       .cpu_vram_rd_data(cpu_vram_rd_data),
                       .cpu_vram_wr_data(cpu_vram_wr_data),
                       .cpu_vram_we(cpu_vram_we));

   vram vram_inst (.clk(clk),
                   // vga port
                   .vram_rd_addr(vga_vram_rd_addr),
                   .vram_rd_data(vga_vram_rd_data),
                   // cpu port
                   .cpu_addr(cpu_vram_addr),
                   .cpu_rd_data(cpu_vram_rd_data),
                   .cpu_wr_data(cpu_vram_wr_data),
                   .cpu_we(cpu_vram_we));

endmodule
