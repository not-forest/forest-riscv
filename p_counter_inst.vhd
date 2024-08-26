p_counter_inst : p_counter PORT MAP (
		clock	 => clock_sig,
		data	 => data_sig,
		sclr	 => sclr_sig,
		sload	 => sload_sig,
		q	 => q_sig
	);
