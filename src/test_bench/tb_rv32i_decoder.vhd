-- ============================================================
-- File Name: tb_rv32i_decoder.vhd
-- Desc: Tests all possible RV32I instructions for properly decoded output signals. For each input instruction,
--      a corresponding expected t_DecoderRecord is provided.
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
use friscv.tb_rv32i.all;
use friscv.tb.all;

use friscv.decoder;

entity tb_rv32i_decoder is
    type tb_dut is record
        i_instr  : t_word;
        o_decode : t_DecoderRecord;
        o_imm    : t_word;          
    end record;
end entity;

architecture behavioral of tb_rv32i_decoder is
    signal sigs : tb_dut := (
        i_instr     => (others => 'X'),
        o_decode    => c_DECODER_RECORD_INIT,
        o_imm       => (others => 'X')
    );

    -- Defines a full array of assert pairs.
    type t_assert_array is array (natural range <>) of t_assert;

    -- All asserts are defines within 'tbcore.vhd'
    constant c_ASSERTS : t_assert_array(0 to 39) := (
        c_ADD, c_ADDI, c_SUB, c_AND, c_ANDI, c_OR, c_ORI, c_XOR, c_XORI, 
        c_SLL, c_SLLI, c_SRL, c_SRLI, c_SRA, c_SRAI, c_SLT, c_SLTI, c_SLTU, c_SLTIU, 
        c_LB, c_LH, c_LW, c_LBU, c_LHU, c_SB, c_SH, c_SW, 
        c_BEQ, c_BNE, c_BLT, c_BGE, c_BLTU, c_BGEU, 
        c_JAL, c_JALR, c_LUI, c_AUIPC, 
        c_FENCE, c_ECALL, c_EBREAK
    );
begin
    -- For this test bench specifically using RV32I architecture.
    DECODER_Inst: entity decoder(rv32i)
    port map(
        i_instr => sigs.i_instr,
        o_decode => sigs.o_decode,
        o_imm => sigs.o_imm
    );

    -- Asserts all RV32I instructions in for loop.
    p_MAIN : process begin
        report "Enter: p_MAIN";
        
        for i in 0 to c_ASSERTS'LENGTH - 1 loop
            report "Assert (" & to_string(i + 1) & "): " & c_ASSERTS(i).name; 
            sigs.i_instr <= c_ASSERTS(i).left;
            wait for 1 ns;

            -- Asserts each decoded output with expected result.
            if sigs.o_decode = c_ASSERTS(i).right then
                report "Assertion succeed!";
            else
                report "Error: assertion failed!: " & lf & debug(sigs.o_decode)
                severity error;
            end if;
        end loop;

        report "Done: p_MAIN";

        wait;
    end process;
end architecture;
