-- ============================================================
-- File Name: src_mux.vhd
-- Desc: Source multiplexer for CPU register file. Used to forward values from two
--      source registers to ALU and other components.
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
use friscv.mux_interface;

entity src_mux is
    port (
        i_line          : in t_line_array(0 to 31);                -- For all 32 general purpose registers.
        o_line          : out std_logic_vector(31 downto 0);       -- Multiplexed output bus.
        i_sel           : in std_logic_vector(4 downto 0)          -- Source input address.
         );
end entity;

architecture structured of src_mux is
begin
    MUX_INTEFACE_Inst : entity mux_interface
    generic map (
        g_SELECT_WIDTH => 5,
        g_BUS_WIDTH => 32
                )
    port map (
        i_line => i_line,
        o_line => o_line,
        i_sel => i_sel
             );
end architecture;
