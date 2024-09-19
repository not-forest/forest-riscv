-- ============================================================
-- File Name: pc_reg.vhd
-- Desc: CPU program counter register. The program counter will progress on rising edge to perform a fetch
--      instruction cycle together with program memory. If program counter is not overloaded with a synchronous
--      load, then the output is expected to be a previous value incremented by 4.
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

entity pc_reg is
    port ( 
        ni_clk       : in std_logic := '0';                 -- Register input clock (Rising edge).
        na_clr       : in std_logic;                        -- Asyncronous clear (Active low).
        i_load       : in std_logic := '0';                 -- Enables the data input port.
        i_halt       : in std_logic := '0';                 -- Halts the counter incrementation.
        i_data       : in t_word;                           -- 32-bit register input.
        o_data       : buffer t_word                        -- 32-bit register output.
         );
end entity;

architecture structured of pc_reg is
    signal w_in_data : t_word    := (others => '0');  -- Could be either overload data or PC + 4;
begin
    process (all) begin
        if falling_edge(ni_clk) then
            -- Writes input value if 'i_load'. Increments by 4 otherwise.
            case i_load is
                when '1' => w_in_data <= i_data;
                when '0' => w_in_data <= pc_incr(o_data);
            end case;
        end if;
    end process;

    REG_INTERFACE_Inst : entity reg_interface
    port map (
        i_clk => not ni_clk,
        na_clr => na_clr,
        i_enable => not i_halt,                             -- Halts the clock of internal register interface.
        i_data => w_in_data,
        o_data => o_data
             );
end architecture;
