transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib jtag_debug_sys
vmap jtag_debug_sys jtag_debug_sys
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_mm_interconnect_0.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_pio_reg_select.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_pio_instruction.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_pio_code.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_pio_clock.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_master_0.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_avalon_packets_to_master.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_avalon_st_packets_to_bytes.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_avalon_st_bytes_to_packets.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_avalon_st_jtag_interface.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_jtag_dc_streaming.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_jtag_sld_node.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_jtag_streaming.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_avalon_st_clock_crosser.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_std_synchronizer_nocut.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_avalon_st_idle_remover.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_avalon_st_idle_inserter.v}
vlog -vlog01compat -work work +incdir+/home/notforest/Documents/forest-riscv/db {/home/notforest/Documents/forest-riscv/db/clk_pll_altpll.v}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_merlin_traffic_limiter.sv}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -vlog01compat -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_avalon_st_pipeline_base.v}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_mm_interconnect_0_router_001.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_mm_interconnect_0_router.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_merlin_master_agent.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_merlin_master_translator.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_master_0_p2b_adapter.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_master_0_b2p_adapter.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/jtag_debug_sys_master_0_timing_adt.sv}
vlog -sv -work jtag_debug_sys +incdir+/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/submodules/altera_avalon_st_pipeline_stage.sv}
vcom -93 -work jtag_debug_sys {/home/notforest/Documents/forest-riscv/jtag_debug_sys/synthesis/jtag_debug_sys.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/p_counter.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/p_rom.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/c_decoder.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/rv32i_decoder.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/op_decoder.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/reg_decoder.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/pp_counter.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/zero32bit.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/bus_mux.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/im_mux.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/b_decoder.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_add.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_sub.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_and.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_or.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_xor.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_sll.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_srl.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_sra.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_mux.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/src_mux.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/pri_encoder.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_cmp.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/alu_cmp_unsigned.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/pri_encoder_8bit.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/one32bit.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/const_mux.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/pc_mux.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/four32bit.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/clk_pll.vhd}
vcom -93 -work work {/home/notforest/Documents/forest-riscv/data_ram.vhd}

