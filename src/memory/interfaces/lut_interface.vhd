-- ============================================================
-- File Name: lut_interface.vhd
-- Desc: Defines an interface to create read-only LUT memory (ROM). Two architectures allow
--      to define LUT memory at synthesis time from file, or by manual staticly provided values.
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
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;
use friscv.memory.all;

entity lut_interface is
    generic (
        g_WIDTH     : integer   := 32;      -- Width of the data bus in bits
        g_DEPTH     : integer;              -- Depth of the memory
        g_PATH      : string    := ""       -- Path to the hex file. (ignored for manualload).
    );
    port (
        i_clk       : in std_logic := '0';                                              -- Input clock source.
        i_addr      : in std_logic_vector(g_DEPTH - 1 downto 0);                        -- Input bus for addressing data
        o_data      : out std_logic_vector(g_WIDTH - 1 downto 0);                       -- Output bus for reading data
        c_DEFAULT   : in t_memory(0 to 2 ** g_DEPTH - 1) := (others => (others => '0')) -- Initialization memory. Used in manualload. 
    );

    -- This procedure is valid for both architectures.
    procedure read_mem(
        signal mem  : in t_memory(0 to 2 ** g_DEPTH - 1);
        signal data : out std_logic_vector(g_WIDTH - 1 downto 0)
    ) is 
        variable w_addr : integer;
    begin
        w_addr := to_integer(unsigned(i_addr));
        if falling_edge(i_clk) then
        -- Reading n-bytes from memory (always)
            for i in 0 to g_WIDTH / 8 - 1 loop
                data(7 + i * 8 downto i * 8) <= mem(w_addr + i);
            end loop;
        end if;
    end procedure;
end lut_interface;

-- Used to load LUT with data during synthesis time from file specified by a path. Would not work with most synthesizers.
architecture synthload of lut_interface is
    -- Reads contents of a file pointed by generic path.
    impure function init_mem(path: string) return t_memory is
        file LutHex         : text open read_mode is path;
        variable out_mem    : t_memory(0 to 2 ** g_DEPTH - 1) := (others => (others => '0'));
        variable next_byte  : bit_vector(g_WIDTH - 1 downto 0);
        variable rline      : line;
        variable i          : integer := 0;
        begin
            while not endfile(LutHex) loop
                readline(LutHex, rline);
                for j in 0 to rline'length - 1 loop
                    read(rline, next_byte);
                    out_mem(i) := to_stdlogicvector(next_byte);
                    i := i + 1;
                end loop;
            end loop;
            return out_mem;
        end function;

    signal r_mem        : t_memory(0 to 2 ** g_DEPTH - 1) := init_mem(g_PATH);    -- Holds data read from file.
begin
    read_mem(r_mem, o_data);
end architecture;

-- Used to load LUT with values provided in 'g_DEFAULT' generic. Might be used for small LUTs or if your software does not support synthload.
architecture manualload of lut_interface is
    signal r_mem : t_memory(0 to 2 ** g_DEPTH - 1) := c_DEFAULT;           -- Holds default memory content
begin
    read_mem(r_mem, o_data);
end architecture;
