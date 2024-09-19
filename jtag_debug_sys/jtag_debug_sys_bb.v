
module jtag_debug_sys (
	dbg_arg_bus_export,
	dbg_clk_clk,
	dbg_cmd_bus_export,
	dbg_data_bus_export,
	dbg_reset_reset_n);	

	output	[31:0]	dbg_arg_bus_export;
	input		dbg_clk_clk;
	output	[7:0]	dbg_cmd_bus_export;
	input	[31:0]	dbg_data_bus_export;
	input		dbg_reset_reset_n;
endmodule
