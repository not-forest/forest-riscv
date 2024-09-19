-- ============================================================
-- File Name: execute.vhd
-- Desc: Defines an execute instruction cycle stage. This last cycle is responsible for executing the
--      requested instruction within the ALU, performing data memory related operations and writing
--      the output to the destination register.
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
use friscv.primitives.all;

use friscv.data_mem;
use friscv.data_selector;
use friscv.alu;

entity execute_stage is
    port (
        i_cmp       : in t_ComparatorRecord;            -- Compare value data of (rs1 and rs2).
        i_decode    : in t_DecoderRecord;               -- Decoded information about the current instruction.
        i_sbus      : in t_sbus;                        -- Input from SBUS line.
        i_pc        : in t_word;                        -- PC value source.
        o_data      : out t_word;                       -- Data to the register file.
        o_result    : buffer t_word;                    -- Forwarded result from the ALU.

        i_clk       : in std_logic;                     -- Global clock.
        na_clr      : in std_logic                      -- Global reset.
         );
end entity;

architecture rv32i of execute_stage is
    type t_pcfifo is array (0 to 3) of t_word;

    signal w_result     : t_word;                       -- Wires the buffered result of the ALU operation to data selector. 
    signal w_mem_out    : t_word;                       -- Data read from memory.
    signal w_decode     : t_DecoderRecord;              -- Bufferd decoder.
    signal w_pcfifo     : t_pcfifo;                     -- Buffered fifo for PC from the fetch stage.
    signal w_write_pc   : std_logic;                    -- Defines if incremented PC must be read.

    -- ALU component socket. --
    component alu is
        port (
            i_sbus      : in t_sbus;                -- SBUS input.
            i_decode    : in t_DecoderRecord;       -- Input decoder data.
            i_cmp       : in t_ComparatorRecord;    -- Input comparator data.
            o_result    : out t_word                -- Operation result.
    );
    end component;
begin
    -- ALU instance that perform arithmetic and logical operations. --
    ALU_Inst : alu
    port map (
        i_sbus => i_sbus,
        i_decode => i_decode,
        i_cmp => i_cmp,
        o_result => o_result
             );

    DATA_MEM_Inst : entity data_mem 
    port map (
        i_decode => w_decode,
        i_clk => i_clk,
        i_addr => o_result,
        i_data => i_sbus(1),
        o_data => w_mem_out,
        na_clr => na_clr
             );

    -- Buffers the PC so it will match PC + 4.
    pipeline(i_clk, na_clr, i_pc, w_pcfifo(0));
    pipeline(i_clk, na_clr, w_pcfifo(0), w_pcfifo(1));
    pipeline(i_clk, na_clr, w_pcfifo(1), w_pcfifo(2));
    pipeline(i_clk, na_clr, w_pcfifo(2), w_pcfifo(3));
    -- Buffered result, forwarded to the data selector.
    pipeline(i_clk, na_clr, o_result, w_result);
    -- Bufferrd decoder.
    pipeline(i_clk, na_clr, i_decode, w_decode);

    -- Selects one of three available inputs.
    -- RAM | PC | RES
    -- When load operation is used, loads data from memory. When JAR or JALR
    -- operation is used, loads the incremented PC. Do not using buffered PC here,
    -- since the next PC is guaranteed to be incremented. Lastly the result is used.
    DATA_SELECTOR_Inst : entity data_selector
    generic map (
        g_SELECT_WIDTH => 3    -- Sources: RAM | PC | RES (default)
                )
    port map (
        i_data => (w_mem_out, w_pcfifo(3), w_result),
        i_sel => (w_decode.mem_read, w_write_pc),
        o_data => o_data
             );

    -- Only true for JAL, JALR instructions.
    w_write_pc <= '1' when w_decode.funct3 = "010" else '0';
    -- Non-buffered result is expected at the fetch stage.
    o_result <= o_result;
end architecture;

-- Configuration is used to define different architectures for execute stage components. --
--
-- Used ALU defines basic instruction set instruction with no extensions.
configuration ExecuteConfig of execute_stage is
    for rv32i
        for ALU_Inst : alu
            use entity friscv.alu(rv32i);      -- Using RISC-V base integer instruction set.
        end for;
    end for;
end configuration;
