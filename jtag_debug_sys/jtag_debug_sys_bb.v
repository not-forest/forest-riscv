
module jtag_debug_sys (
	dbg_clk_clk,
	dbg_pc_export,
	dbg_reset_reset_n,
	dbg_x0_export,
	dbg_x1_export,
	dbg_x10_export,
	dbg_x11_export,
	dbg_x12_export,
	dbg_x13_export,
	dbg_x14_export,
	dbg_x15_export,
	dbg_x16_export,
	dbg_x17_export,
	dbg_x18_export,
	dbg_x19_export,
	dbg_x2_export,
	dbg_x20_export,
	dbg_x21_export,
	dbg_x22_export,
	dbg_x23_export,
	dbg_x24_export,
	dbg_x25_export,
	dbg_x26_export,
	dbg_x27_export,
	dbg_x28_export,
	dbg_x29_export,
	dbg_x3_export,
	dbg_x30_export,
	dbg_x31_export,
	dbg_x4_export,
	dbg_x5_export,
	dbg_x6_export,
	dbg_x7_export,
	dbg_x8_export,
	dbg_x9_export,
	dbg_clock_export);	

	input		dbg_clk_clk;
	input	[31:0]	dbg_pc_export;
	input		dbg_reset_reset_n;
	input	[31:0]	dbg_x0_export;
	input	[31:0]	dbg_x1_export;
	input	[31:0]	dbg_x10_export;
	input	[31:0]	dbg_x11_export;
	input	[31:0]	dbg_x12_export;
	input	[31:0]	dbg_x13_export;
	input	[31:0]	dbg_x14_export;
	input	[31:0]	dbg_x15_export;
	input	[31:0]	dbg_x16_export;
	input	[31:0]	dbg_x17_export;
	input	[31:0]	dbg_x18_export;
	input	[31:0]	dbg_x19_export;
	input	[31:0]	dbg_x2_export;
	input	[31:0]	dbg_x20_export;
	input	[31:0]	dbg_x21_export;
	input	[31:0]	dbg_x22_export;
	input	[31:0]	dbg_x23_export;
	input	[31:0]	dbg_x24_export;
	input	[31:0]	dbg_x25_export;
	input	[31:0]	dbg_x26_export;
	input	[31:0]	dbg_x27_export;
	input	[31:0]	dbg_x28_export;
	input	[31:0]	dbg_x29_export;
	input	[31:0]	dbg_x3_export;
	input	[31:0]	dbg_x30_export;
	input	[31:0]	dbg_x31_export;
	input	[31:0]	dbg_x4_export;
	input	[31:0]	dbg_x5_export;
	input	[31:0]	dbg_x6_export;
	input	[31:0]	dbg_x7_export;
	input	[31:0]	dbg_x8_export;
	input	[31:0]	dbg_x9_export;
	output		dbg_clock_export;
endmodule
