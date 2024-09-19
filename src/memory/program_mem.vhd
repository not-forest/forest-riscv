-- ============================================================
-- File Name: program_mem.vhd
-- Desc: CPU program memory for holding CPU instructions.
-- TODO!: Swap to RAM cache when implementing system bus instead.
-- ============================================================
-- MIT License
--
-- Copyright (c) 2024, notforest
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal in the Software without restriction, 
-- including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
-- copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following 
-- conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
-- Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
-- WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
-- OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

library friscv;
library ieee;
use ieee.std_logic_1164.all;
use friscv.memory.all;
use friscv.primitives.all;
use friscv.lut_interface;

entity program_mem is
    port (
        i_clk   : in std_logic;    -- Clock input.
        i_pc    : in t_word;       -- Program counter input.
        o_instr : out t_word       -- Raw instruction output for decoder.
    );
end entity;

architecture structured of program_mem is
    component lut_interface
    generic (
        g_WIDTH     : integer   := 32;
        g_DEPTH     : integer;        
        g_PATH      : string    := "" 
    );
    port (
        i_clk       : in std_logic := '0';
        i_addr      : in std_logic_vector(g_DEPTH - 1 downto 0); 
        o_data      : out std_logic_vector(g_WIDTH - 1 downto 0);
        c_DEFAULT   : in t_memory(0 to 2 ** g_DEPTH - 1) := (others => (others => '0')) 
    );
    end component;
begin
    LUT_INTERFACE_Inst: lut_interface
        generic map (
            g_PATH => "../../asm/branch.hex", --> Using ROM program (temporary)
            g_DEPTH => 8                    --> To not waste FPGA space (temporary).
        )
        port map (
            i_clk     => i_clk,
            i_addr    => i_pc(7 downto 0),  --> To not waste FPGA space (temporary).
            o_data    => o_instr
        );
end architecture;

library altera_mf;
use altera_mf.altera_mf_components.all;
use friscv.program_mem;

architecture vendor of program_mem is
begin
    ALTSYNCRAM_Inst : altsyncram
	GENERIC MAP (
		address_aclr_a          => "none",
		clock_enable_input_a    => "bypass",
		clock_enable_output_a   => "bypass",
		init_file               => "../../asm/program.hex",
		intended_device_family  => "cyclone iv e",
		lpm_hint                => "enable_runtime_mod=no",
		lpm_type                => "altsyncram",
		numwords_a              => 256,
		operation_mode          => "rom",
		outdata_aclr_a          => "none",
		outdata_reg_a           => "clock0",
		widthad_a               => 8,
		width_a                 => 32,
		width_byteena_a         => 1
	)
	PORT MAP (
		address_a               => i_pc(9 downto 2),    -- Ignoring first 2 bits because words are addressed.
		clock0                  => i_clk,
		q_a                     => o_instr
	);
end architecture;

-- Configuration is used to define different architectures for fetch stage components. --
-- 
-- This configuration is using 'synthload' architecture to automatically load
-- hex binary code from the file located at "ROOT/asm/XYZ.hex".
configuration ProgramMemoryConfig of program_mem is
    for structured
        for LUT_INTERFACE_Inst: lut_interface
            use entity friscv.lut_interface(synthload);  -- Using synthesis load supported by quartus.
        end for;
    end for;
end configuration;
