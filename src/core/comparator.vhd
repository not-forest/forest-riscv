-- ============================================================
-- File Name: comparator.vhd
-- Desc: Main CPU comparator used to provide constant compare result from rs1 and rs2.
--      Will always override PC when funct3 is x"2". Will never override PC when funct3
--      is x"3".
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

entity comparator is
    port (
        i_clk       : in std_logic;            -- Input clock source.
        na_clr      : in std_logic;            -- Asyncronous clear (Active low).
        i_regbus    : in t_sbus;               -- Two source registers input (rs1 & rs2).
        i_decode    : in t_DecoderRecord;      -- Decoded flags.
        o_cmp       : out t_ComparatorRecord   -- Output comparator record.
         );
end entity;

architecture rtl of comparator is
    signal r_cmp : t_ComparatorRecord := c_COMPARATOR_RECORD_INIT; -- Buffered comparator.
    signal w_eq, w_lt, w_ltu : std_logic := '0';                   -- Compare signal wires.
begin
    -- Performign three basic comparison.
    w_eq  <= '1' when (signed(i_regbus(0)) = signed(i_regbus(1))) else '0';
    w_lt  <= '1' when (signed(i_regbus(0)) < signed(i_regbus(1))) else '0';
    w_ltu <= '1' when (unsigned(i_regbus(0)) < unsigned(i_regbus(1))) else '0';

    process (all) is
        variable cmp_res : t_ComparatorRecord; -- New comparator record.
    begin
        if na_clr = '0' then
            r_cmp <= c_COMPARATOR_RECORD_INIT;
        elsif falling_edge(i_clk) then
        -- New compare result on each cycle.
            cmp_res := c_COMPARATOR_RECORD_INIT;
            cmp_res.eq := w_eq;
            cmp_res.lt := w_eq;
            cmp_res.ltu := w_eq;


        -- Always override check.
            if i_decode.funct3 = "010" then
                cmp_res.branch_match := '1';    -- JAL, JALR (Always overrides).
                                                -- Only for operations related to overriding the PC.
            elsif i_decode.pc_write then
                case i_decode.funct3 is
                    when "000" => cmp_res.branch_match := w_eq;         -- BEQ
                    when "001" => cmp_res.branch_match := not w_eq;     -- BNE
                    when "100" => cmp_res.branch_match := w_lt;         -- BLT
                    when "101" => cmp_res.branch_match := not w_lt;     -- BGE
                    when "110" => cmp_res.branch_match := w_ltu;        -- BLTU
                    when "111" => cmp_res.branch_match := not w_ltu;    -- BGEU
                    when others => cmp_res.branch_match := '0';
                end case;
            end if;

            r_cmp <= cmp_res;
        end if;
    end process;

    o_cmp <= r_cmp;
end architecture;
