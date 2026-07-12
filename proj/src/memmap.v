module memmap (input [15:0]     cpu_addr,
               output reg [7:0] cpu_rd_data, // memmap -> CPU
               input [7:0]      cpu_wr_data,
               input            cpu_we,

               output [12:0]    cpu_vram_addr,
               input [7:0]      cpu_vram_rd_data, // VRAM -> memmap
               output [7:0]     cpu_vram_wr_data,
               output           cpu_vram_we
               );

   // 0x0000 - 0x1FFF : ROM
   // 0x2000 - 0x23FF : RAM
   // 0x2400 - 0x3FFF : VRAM
   // 0x4000 -        : MIRROR

   wire in_rom = cpu_addr < 16'h2000;
   wire in_ram = cpu_addr >= 16'h2000 && cpu_addr < 16'h2400;
   wire in_vram = cpu_addr >= 16'h2400 && cpu_addr < 16'h4000;

   assign cpu_vram_we = (in_vram && cpu_we);
   assign cpu_vram_addr = cpu_addr - 16'h2400;
   assign cpu_vram_wr_data = cpu_wr_data;

   always @(*) begin
      if (in_rom) begin
         cpu_rd_data = 8'h00;
      end else if (in_ram) begin
         cpu_rd_data = 8'h00;
      end else if (in_vram) begin
         cpu_rd_data = cpu_vram_rd_data;
      end else begin
         cpu_rd_data = 8'h00;
      end
   end

endmodule
