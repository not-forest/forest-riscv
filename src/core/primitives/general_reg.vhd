-- ============================================================
-- File Name: general_reg.vhd
-- Desc: RISC-V general purpose 32-bit register.
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
use friscv.reg_interface;

entity general_reg is
    port (
        i_clk       : in std_logic := '1';                  -- Clock input
        na_clr      : in std_logic := '1';                  -- Asynchronous clear (Active low)
        i_enable    : in std_logic := '0';                  -- Write enable
        i_data      : in t_word;                            -- Data input
        o_data      : out t_word                            -- Data output
    );
end entity general_reg;

architecture rtl of general_reg is
begin
    REG_INTERFACE_COMPONENT_Inst : entity reg_interface
    port map (
        i_clk   => i_clk,
        na_clr   => na_clr,
        i_enable => i_enable,
        i_data  => i_data,
        o_data  => o_data
    );
end architecture;
