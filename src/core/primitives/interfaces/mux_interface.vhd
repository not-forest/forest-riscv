-- ============================================================
-- File Name: mux_interface.vhd
-- Desc: Simple parametrizable multiplexer interface. 
--       Higher level register based logic will use an adjusted version of this interface as components.
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

entity mux_interface is
    generic (
        g_BUS_WIDTH     : natural;            -- Width of input vectors
        g_SELECT_WIDTH  : natural             -- Amount of bits for select input
    );
    port (
        i_sel   : in std_logic_vector(g_SELECT_WIDTH - 1 downto 0);         -- Select input
        i_line  : t_line_array(0 to (2 ** g_SELECT_WIDTH - 1));             -- Input lines
        o_line  : out std_logic_vector(g_BUS_WIDTH - 1 downto 0)                -- Multiplexed output
    );
end entity;

architecture rtl of mux_interface is
begin
    o_line <= i_line(to_integer(unsigned(i_sel)));  -- Returns the line at index position defined by i_sel
end architecture;
