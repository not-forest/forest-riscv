set_global_assignment -entity "jtag_debug_sys" -library "lib_jtag_debug_sys" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "jtag_debug_sys" -library "lib_jtag_debug_sys" -name IP_TOOL_VERSION "23.1"
set_global_assignment -entity "jtag_debug_sys" -library "lib_jtag_debug_sys" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_jtag_debug_sys" -name SPD_FILE [file join $::quartus(sip_path) "../jtag_debug_sys.spd"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "../../jtag_debug_sys.qsys"]

set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "jtag_debug_sys.vhd"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_synchronizer.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.sdc"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_mm_interconnect_0.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_mm_interconnect_0_avalon_st_adapter.vhd"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_mm_interconnect_0_rsp_mux.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_arbitrator.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_mm_interconnect_0_rsp_demux.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_mm_interconnect_0_cmd_mux.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_mm_interconnect_0_cmd_demux.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_traffic_limiter.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_reorder_memory.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_sc_fifo.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_st_pipeline_base.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_mm_interconnect_0_router_001.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_mm_interconnect_0_router.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_slave_agent.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_burst_uncompressor.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_master_agent.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_slave_translator.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_master_translator.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_pio_data.vhd"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_pio_cmd.vhd"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_pio_arg.vhd"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_master_0.vhd"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_master_0_p2b_adapter.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_master_0_b2p_adapter.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_packets_to_master.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_st_packets_to_bytes.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_st_bytes_to_packets.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/jtag_debug_sys_master_0_timing_adt.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_st_jtag_interface.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_jtag_dc_streaming.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_jtag_sld_node.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_jtag_streaming.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_st_clock_crosser.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_std_synchronizer_nocut.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_st_idle_remover.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_st_idle_inserter.v"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_st_pipeline_stage.sv"]
set_global_assignment -library "lib_jtag_debug_sys" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_st_jtag_interface.sdc"]
