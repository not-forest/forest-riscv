-- ============================================================
-- File Name: data_selector.vhd
-- Desc: Selects one of n sources to write data to the register file. Most significant
--      bit always has highest priority among others.
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

entity data_selector is
    generic (
        g_SELECT_WIDTH : natural                                -- Amount of possible input sources.
            );
    port (
        i_data  : in t_line_array(0 to g_SELECT_WIDTH - 1);     -- Input source lines.
        i_sel   : in std_logic_vector(0 to g_SELECT_WIDTH - 2); -- Select input source line.
        o_data  : out t_word                                    -- Output selected source.
         );
end entity;

architecture rtl of data_selector is
begin
    process (all) is
        variable id : integer;
    begin
        -- Default value with lowest priority.
        id := g_SELECT_WIDTH - 1;
        g_GEN_LOOP : for i in g_SELECT_WIDTH - 1 to 1 loop
            if i_sel(i) = '1' then id := i; end if;
        end loop;

        o_data <= i_data(id);
    end process;
end architecture;
