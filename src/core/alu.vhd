-- ============================================================
-- File Name: alu.vhd
-- Desc: Forest RISC-V CPU ALU module implementation. Performs all basic arithmetic and logical operations.
--      Implemented architecture might be different with additional RISC-V extensions.
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

entity alu is
    port (
        i_sbus      : in t_sbus;                -- SBUS input.
        i_decode    : in t_DecoderRecord;       -- Input decoder data.
        i_cmp       : in t_ComparatorRecord;    -- Input comparator data.
        o_result    : out t_word                -- Operation result.
    );
end entity;

architecture rv32i of alu is
begin
    process (all) is
        variable x1 : signed(t_word'range);   -- First operand.
        variable x2 : signed(t_word'range);   -- Second operand.
        variable y  : signed(t_word'range);   -- Result.

        alias distance : signed is x2(4 downto 0);
    begin
    -- Assignment.
        x1 := signed(i_sbus(0)); 
        x2 := signed(i_sbus(1));
        y  := (others => '0');
    -- Execution.
        case i_decode.opsel is
            when x"0"   => y := x1 + x2;                                                    -- ADD/LUI
            when x"1"   => y := x1 - x2;                                                    -- SUB
            when x"2"   => y := x1 and x2;                                                  -- AND
            when x"3"   => y := x1 or x2;                                                   -- OR
            when x"4"   => y := x1 xor x2;                                                  -- XOR
            when x"5"   => y := signed(shift_left(unsigned(x1), to_integer(distance)));     -- SLL
            when x"6"   => y := signed(shift_right(unsigned(x1), to_integer(distance)));    -- SRL
            when x"7"   => y := signed(shift_right(signed(x1), to_integer(distance)));      -- SRA
            when x"8"   => y(0) := i_cmp.lt;                                                -- SLT
            when x"9"   => y(0) := i_cmp.ltu;                                               -- SLTU

            when x"f"   => y := x1 + signed(i_decode.dbus); -- Reserved for all store-like memory operations.

            when others => unreachable;            -- Might be used in different architectures
        end case;

        o_result <= t_word(y);
    end process;
end architecture;
