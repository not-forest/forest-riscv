	component jtag_debug_sys is
		port (
			dbg_clk_clk       : in  std_logic                     := 'X';             -- clk
			dbg_pc_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_reset_reset_n : in  std_logic                     := 'X';             -- reset_n
			dbg_x0_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x1_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x10_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x11_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x12_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x13_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x14_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x15_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x16_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x17_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x18_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x19_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x2_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x20_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x21_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x22_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x23_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x24_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x25_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x26_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x27_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x28_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x29_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x3_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x30_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x31_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x4_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x5_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x6_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x7_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x8_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_x9_export     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_clock_export  : out std_logic                                         -- export
		);
	end component jtag_debug_sys;

	u0 : component jtag_debug_sys
		port map (
			dbg_clk_clk       => CONNECTED_TO_dbg_clk_clk,       --   dbg_clk.clk
			dbg_pc_export     => CONNECTED_TO_dbg_pc_export,     --    dbg_pc.export
			dbg_reset_reset_n => CONNECTED_TO_dbg_reset_reset_n, -- dbg_reset.reset_n
			dbg_x0_export     => CONNECTED_TO_dbg_x0_export,     --    dbg_x0.export
			dbg_x1_export     => CONNECTED_TO_dbg_x1_export,     --    dbg_x1.export
			dbg_x10_export    => CONNECTED_TO_dbg_x10_export,    --   dbg_x10.export
			dbg_x11_export    => CONNECTED_TO_dbg_x11_export,    --   dbg_x11.export
			dbg_x12_export    => CONNECTED_TO_dbg_x12_export,    --   dbg_x12.export
			dbg_x13_export    => CONNECTED_TO_dbg_x13_export,    --   dbg_x13.export
			dbg_x14_export    => CONNECTED_TO_dbg_x14_export,    --   dbg_x14.export
			dbg_x15_export    => CONNECTED_TO_dbg_x15_export,    --   dbg_x15.export
			dbg_x16_export    => CONNECTED_TO_dbg_x16_export,    --   dbg_x16.export
			dbg_x17_export    => CONNECTED_TO_dbg_x17_export,    --   dbg_x17.export
			dbg_x18_export    => CONNECTED_TO_dbg_x18_export,    --   dbg_x18.export
			dbg_x19_export    => CONNECTED_TO_dbg_x19_export,    --   dbg_x19.export
			dbg_x2_export     => CONNECTED_TO_dbg_x2_export,     --    dbg_x2.export
			dbg_x20_export    => CONNECTED_TO_dbg_x20_export,    --   dbg_x20.export
			dbg_x21_export    => CONNECTED_TO_dbg_x21_export,    --   dbg_x21.export
			dbg_x22_export    => CONNECTED_TO_dbg_x22_export,    --   dbg_x22.export
			dbg_x23_export    => CONNECTED_TO_dbg_x23_export,    --   dbg_x23.export
			dbg_x24_export    => CONNECTED_TO_dbg_x24_export,    --   dbg_x24.export
			dbg_x25_export    => CONNECTED_TO_dbg_x25_export,    --   dbg_x25.export
			dbg_x26_export    => CONNECTED_TO_dbg_x26_export,    --   dbg_x26.export
			dbg_x27_export    => CONNECTED_TO_dbg_x27_export,    --   dbg_x27.export
			dbg_x28_export    => CONNECTED_TO_dbg_x28_export,    --   dbg_x28.export
			dbg_x29_export    => CONNECTED_TO_dbg_x29_export,    --   dbg_x29.export
			dbg_x3_export     => CONNECTED_TO_dbg_x3_export,     --    dbg_x3.export
			dbg_x30_export    => CONNECTED_TO_dbg_x30_export,    --   dbg_x30.export
			dbg_x31_export    => CONNECTED_TO_dbg_x31_export,    --   dbg_x31.export
			dbg_x4_export     => CONNECTED_TO_dbg_x4_export,     --    dbg_x4.export
			dbg_x5_export     => CONNECTED_TO_dbg_x5_export,     --    dbg_x5.export
			dbg_x6_export     => CONNECTED_TO_dbg_x6_export,     --    dbg_x6.export
			dbg_x7_export     => CONNECTED_TO_dbg_x7_export,     --    dbg_x7.export
			dbg_x8_export     => CONNECTED_TO_dbg_x8_export,     --    dbg_x8.export
			dbg_x9_export     => CONNECTED_TO_dbg_x9_export,     --    dbg_x9.export
			dbg_clock_export  => CONNECTED_TO_dbg_clock_export   -- dbg_clock.export
		);

