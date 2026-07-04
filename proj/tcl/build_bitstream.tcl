open_project ./pynq_z2_rtl/pynq_z2_rtl.xpr

update_compile_order -fileset sources_1

reset_run synth_1
reset_run impl_1

launch_runs impl_1 -to_step write_bitstream -jobs 32
wait_on_run impl_1

file copy -force ./pynq_z2_rtl/pynq_z2_rtl.runs/impl_1/fpga_top.bit pynq_z2_rtl.bit
