
module jtag_debug_sys (
	dbg_clk_clk,
	dbg_clock_export,
	dbg_code_export,
	dbg_instr_export,
	dbg_pc_export,
	dbg_reg_bus_export,
	dbg_reg_select_export,
	dbg_reset_reset_n);	

	input		dbg_clk_clk;
	output		dbg_clock_export;
	input	[31:0]	dbg_code_export;
	input	[10:0]	dbg_instr_export;
	input	[31:0]	dbg_pc_export;
	input	[31:0]	dbg_reg_bus_export;
	output	[4:0]	dbg_reg_select_export;
	input		dbg_reset_reset_n;
endmodule
