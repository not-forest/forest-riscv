-- ============================================================
-- File Name: register_file.vhd
-- Desc: Holds all 32 general purpose RISC-V registers (x0 .. x31) and provides an interface
--      to pull their values into the SBUS and write data into one of them based on provided
--      decoder record.
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
use ieee.numeric_std.all;
use friscv.primitives.all;

use friscv.general_reg;
use friscv.comparator;
use friscv.src_mux;

entity register_file is
    port (
        i_clk       : in std_logic := '1';      -- Input clock source. 
        na_clr      : in std_logic := '1';      -- Asynchronous clear (Active low).
        i_decode    : in t_DecoderRecord;       -- Decoded flags.
        i_data      : in t_word;                -- Input data to write.
        i_pc        : in t_word;                -- Input PC to forward.
        i_imm       : in t_word;                -- Input immediate to forward.
        o_sbus      : out t_sbus;               -- Two values forwarded to the ALU.
        o_cmp       : out t_ComparatorRecord;   -- Comparator output obtained from the comparator instance.
        
        o_dbg_regs  : out t_regs -- Forwards to debugger chip. Only used with debug.
         );
end entity;

architecture structured of register_file is
    signal w_regs   : t_regs                    := (others => (others => '0')); -- Connects all 32 registers to the bus.
    signal w_rd     : std_logic_vector(1 to 31) := (others => '0');             -- Connects the enable input of all registers.
    signal w_regbus : t_sbus                    := c_CLEAR_SBUS;                -- This line forwards register values, before actually becode an SBUS.
    signal w_sbus   : t_sbus                    := c_CLEAR_SBUS;                -- Wires the actual SBUS with a pipeline buffer.

    signal w_decode : t_DecoderRecord           := c_DECODER_RECORD_INIT;       -- Buffered decoder's output cycles.

    constant x0     : t_word                    := (others => '0');             -- Constant 32-bit zero.
begin
    w_regs(0) <= x0;

    -- Generating and connecting all 31 general purpose registers.                  --
    g_REGS_GEN : for i in 1 to 31 generate
        g_GENERAL_REG_Inst : entity general_reg
        port map(
            i_clk => i_clk,
            na_clr => na_clr,
            i_enable => w_rd(i),
            i_data => i_data,
            o_data => w_regs(i)
        );
    end generate;

    -- Forwards the rs1 register to the regbus.                                     --
    g_SRC_MUX_Inst1 : entity src_mux
     port map(
        i_line => w_regs,
        o_line => w_regbus(0),
        i_sel => i_decode.rs1
    );
    
    -- Forwards the rs2 register to the regbus.                                     --
    g_SRC_MUX_Inst2 : entity src_mux
     port map(
        i_line => w_regs,
        o_line => w_regbus(1),
        i_sel => i_decode.rs2
    );

    -- Compares values of rs1 and rs2 and provides a constant output.
    COMPARATOR_Inst: entity comparator
     port map(
        i_clk => i_clk,
        na_clr => na_clr,
        i_regbus => w_regbus,     
        i_decode => i_decode,
        o_cmp => o_cmp
    ); 

    -- Actual SBUS1 obtains a PC or rs1 based on the current instruction.           --
    w_sbus(0) <= i_pc when i_decode.pc_write else w_regbus(0);
    -- Actual SBUS2 obtains an Immediate or rs2 based on the current instruction.   --
    w_sbus(1) <= i_imm when i_decode.alu_src else w_regbus(1);

    -- Buffer the SBUS lines. The output is ready for the execute CPU stage.
    pipeline(i_clk, na_clr, w_sbus(0), o_sbus(0));
    pipeline(i_clk, na_clr, w_sbus(1), o_sbus(1));

    process (all) is
    begin
        if falling_edge(i_clk) then
            -- Making sure previous bits were not set.
            w_rd <= (others => '0');

            -- Writing to some specific address if enabled. Otherwise writing to x0 (ignore).
            if w_decode.dbus_en then
                -- Acts as 5 to 32 decoder on each clock tick. Enables only the destination register for writing.
                w_rd(to_integer(unsigned(w_decode.dbus))) <= '1'; 
            end if;
        end if;
    end process;

    -- Pipeline buffer. Holds (rd, dbus_en) signals for storing data.
    pipeline(i_clk, na_clr, i_decode, w_decode);

    -- Debugger line only.
    o_dbg_regs <= w_regs;
end architecture;
