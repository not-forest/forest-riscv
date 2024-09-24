-- ============================================================
-- File Name: mem_interface.vhd
-- Desc: Defines an interface to create on-chip unidirectional RAM memory of any width and depth. Used
--      to define higher level unidirectional memory designs from basic register files to caches.
--      This memory interface would always produce a byte-addressed memory model, i.e., each address
--      will point to a specific byte of data (not word).
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

library ieee;
library friscv;
use ieee.std_logic_1164.all;
use friscv.primitives.all;

-- Package definition for memory types
package memory is
    -- Defines a memory block of bytes. This block is always addressed byte-by-byte.
    type t_memory is array (natural range <>) of t_byte;
end package memory;

library friscv;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use friscv.memory.all;

-- Entity declaration
entity mem_interface is
    generic (
        g_WIDTH  : positive := 32;              -- Data width in bits
        g_DEPTH  : positive                     -- Number of address bits (2^g_DEPTH addressed bytes.)
    );
    port (
        i_clk     : in std_logic := '1';                             -- Clock signal
        na_clr    : in std_logic := '1';                             -- Asynchronous clear (Active low).
        i_addr    : in std_logic_vector(g_DEPTH - 1 downto 0);       -- Address input
        i_data    : in std_logic_vector(g_WIDTH - 1 downto 0);       -- Data input
        i_wenable : in std_logic := '0';                             -- Write enable signal
        i_bwrite  : in std_logic_vector(g_WIDTH/8 - 1 downto 0);     -- Number of bytes to write/read.
        o_data    : out signed(g_WIDTH - 1 downto 0)                 -- Data output (signed for ease of resizing.)
    );
end entity;

-- Architecture definition
architecture rtl of mem_interface is
    signal r_mem : t_memory(0 to 2 ** g_DEPTH - 1) := (others => (others => '0'));  -- Memory array initialized to zeros
begin
    -- Process for handling memory operations
    process(all) is
        variable w_addr : natural;
    begin
        w_addr := to_integer(unsigned(i_addr));

        if na_clr = '0' then
            r_mem <= (others => (others => '0'));
        elsif rising_edge(i_clk) then
            w_addr := to_integer(unsigned(i_addr));
            if i_wenable = '1' then
                -- Writing n-bytes to memory
                for i in 0 to g_WIDTH/8 - 1 loop
                    if i_bwrite(i) = '1' then
                        -- Will read byte-by-byte into the memory location.
                        r_mem(w_addr + i) <= i_data(7 + i * 8 downto i * 8);
                    end if;
                end loop;
            end if;

            -- Reading n-bytes from memory (always)
            for i in 0 to g_WIDTH/8 - 1 loop
                if i_bwrite(i) = '1' then
                    o_data(7 + i * 8 downto i * 8) <= signed(r_mem(w_addr + i));
                end if;
            end loop;
        end if;
    end process;
end architecture;
