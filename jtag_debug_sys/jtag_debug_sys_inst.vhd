	component jtag_debug_sys is
		port (
			dbg_clk_clk           : in  std_logic                     := 'X';             -- clk
			dbg_clock_export      : out std_logic;                                        -- export
			dbg_code_export       : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_instr_export      : in  std_logic_vector(10 downto 0) := (others => 'X'); -- export
			dbg_pc_export         : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_reg_bus_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_reg_select_export : out std_logic_vector(4 downto 0);                     -- export
			dbg_reset_reset_n     : in  std_logic                     := 'X'              -- reset_n
		);
	end component jtag_debug_sys;

	u0 : component jtag_debug_sys
		port map (
			dbg_clk_clk           => CONNECTED_TO_dbg_clk_clk,           --        dbg_clk.clk
			dbg_clock_export      => CONNECTED_TO_dbg_clock_export,      --      dbg_clock.export
			dbg_code_export       => CONNECTED_TO_dbg_code_export,       --       dbg_code.export
			dbg_instr_export      => CONNECTED_TO_dbg_instr_export,      --      dbg_instr.export
			dbg_pc_export         => CONNECTED_TO_dbg_pc_export,         --         dbg_pc.export
			dbg_reg_bus_export    => CONNECTED_TO_dbg_reg_bus_export,    --    dbg_reg_bus.export
			dbg_reg_select_export => CONNECTED_TO_dbg_reg_select_export, -- dbg_reg_select.export
			dbg_reset_reset_n     => CONNECTED_TO_dbg_reset_reset_n      --      dbg_reset.reset_n
		);

