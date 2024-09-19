-- ============================================================
-- File Name: decode.vhd
-- Desc: Defines a decode instruction cycle stage. Decoder parses obtained raw instruction from
--      fetch stage and prepares the CPU for the execute stage. Prepares data for the SBUS1, SBUS2
--      and forwards data to next instruction stage.
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

use friscv.decoder;
use friscv.register_file;

entity decode_stage is
    port (
        i_instr     : in t_word;                        -- Raw instruction obtained from the fetch cycle stage.
        i_data      : in t_word;                        -- Data obtained from the execute cycle stage to write back to register file.
        i_pc        : in t_word;                        -- PC value forwarded from the fetch stage.
        o_sbus      : out t_sbus;                       -- SBUS output value.
        o_cmp       : out t_ComparatorRecord;           -- Comparator output for the execute stage.
        o_decode    : buffer t_DecoderRecord;           -- Parsed decoder output.

        i_clk       : in std_logic;                     -- Global clock.
        na_clr      : in std_logic;                     -- Global reset.

        o_dbg_regs  : out t_regs                        -- Forwards to debugger chip. Only used with debug. 
         );
end entity;

architecture rv32i of decode_stage is
    signal w_decode : t_DecoderRecord := c_DECODER_RECORD_INIT;     -- Wires the decoder and next pipeline buffer.
    signal w_imm    : t_word          := (others => '0');           -- Wires the immediate to register file.
    signal w_pc     : t_word          := (others => '0');           -- Buffered PC value.

    -- Decoder component socket. --
    component decoder is
        port (
            i_instr  : in t_word;
            o_decode : out t_DecoderRecord; 
            o_imm    : out t_word
            );
    end component;
begin
    -- Decodes the obtained raw instruction                             --
    DECODER_Inst : decoder
    port map(
        i_instr => i_instr,
        o_decode => w_decode,
        o_imm => w_imm
    );

    -- Prepares SBUS1, SBUS2 for next stage. Buffers the data.          --
    FILE_REG_Inst : entity register_file
     port map(
        i_clk => i_clk,
        na_clr => na_clr,
        i_decode => w_decode,
        i_data => i_data,
        i_pc => w_pc,
        i_imm => w_imm,
        o_cmp => o_cmp,
        o_sbus => o_sbus,
        -- Registers debug line.
        o_dbg_regs => o_dbg_regs
    );

    -- Stalls the PC, so that it match the instruction.
    pipeline(i_clk, na_clr, i_pc, w_pc);
    -- Stalls the decoder, so it can be still read in execute stage.
    pipeline(i_clk, na_clr, w_decode, o_decode);
end architecture;

-- Configuration is used to define different architectures for decode stage components. --
--
-- Used decoder can only parse regular RV32I ISA instructions.
configuration DecodeConfig of decode_stage is
    for rv32i
        for DECODER_Inst : decoder
            use entity friscv.decoder(rv32i);      -- Using RISC-V base integer instruction set.
        end for;
    end for;
end configuration;
