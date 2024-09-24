-- ============================================================
-- File Name: tbcore.vhd
-- Desc: Core data types and elements for writing test benches.
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

package tb is
    -- Custom clock type for testbench simulations.
    subtype t_clock is X01; 

    -- Provides a constant simulation of clock ticks with certain frequency --
    procedure tick (signal clk  : inout t_clock; signal freq : in real);
end package;

package body tb is
    -- Provides a constant simulation of clock ticks with certain frequency --
    procedure tick (
        signal clk      : inout t_clock;  -- This signal will simulate the clock behavior.
        signal freq     : in real         -- Clock's frequency. 
    ) is
    begin
        -- While current frequency exist, ticks the clock.
        if freq /= 0.0 then
            clk <= not clk after (1 sec / freq) / 2;
        end if;
    end procedure;
end package body;
