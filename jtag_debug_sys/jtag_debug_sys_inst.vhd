	component jtag_debug_sys is
		port (
			dbg_arg_bus_export  : out std_logic_vector(31 downto 0);                    -- export
			dbg_clk_clk         : in  std_logic                     := 'X';             -- clk
			dbg_cmd_bus_export  : out std_logic_vector(7 downto 0);                     -- export
			dbg_data_bus_export : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			dbg_reset_reset_n   : in  std_logic                     := 'X'              -- reset_n
		);
	end component jtag_debug_sys;

	u0 : component jtag_debug_sys
		port map (
			dbg_arg_bus_export  => CONNECTED_TO_dbg_arg_bus_export,  --  dbg_arg_bus.export
			dbg_clk_clk         => CONNECTED_TO_dbg_clk_clk,         --      dbg_clk.clk
			dbg_cmd_bus_export  => CONNECTED_TO_dbg_cmd_bus_export,  --  dbg_cmd_bus.export
			dbg_data_bus_export => CONNECTED_TO_dbg_data_bus_export, -- dbg_data_bus.export
			dbg_reset_reset_n   => CONNECTED_TO_dbg_reset_reset_n    --    dbg_reset.reset_n
		);

