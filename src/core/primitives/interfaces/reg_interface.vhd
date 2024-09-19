-- ============================================================
-- File Name: reg_interface.vhd
-- Desc: Interface for creating CPU registers of various sizes. Stores data as
--      std_logic_vector type, and could store any convertable subtypes.
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

entity reg_interface is
    generic (
        g_WIDTH     : natural := 32                                              -- Defines register's width in bits.
    );
    port (
        i_data      : in std_logic_vector(g_WIDTH - 1 downto 0);                 -- Input data bus.
        o_data      : out std_logic_vector(g_WIDTH - 1 downto 0);                -- Output data bus.
        na_clr      : in std_logic := '1';                                       -- Asynchronous clear (Active low).
        i_clk       : in std_logic := '1';                                       -- Input clock source.
        i_enable    : in std_logic  := '0';                                      -- Enables write input.
        c_DEFAULT   : std_logic_vector(g_WIDTH - 1 downto 0) := (others => '0')  -- Holds the default value on reset.
    );
end entity;

architecture rtl of reg_interface is
    signal r_data: std_logic_vector(g_WIDTH - 1 downto 0) := c_DEFAULT; -- Set to the default value on clear.
begin
    process (all) begin
        if na_clr = '0' then
            r_data <= c_DEFAULT;
        elsif rising_edge(i_clk) then
            if i_enable = '1' then
                r_data <= i_data;
            end if;    
        end if;
    end process;
    o_data <= r_data;
end architecture;
