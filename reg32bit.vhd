-- ============================================================
-- File Name: reg32bit.vhd
-- Desc: General purpose 32-bit register.
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
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity reg32 is
    Port (
        clk     : in std_logic;                      -- Clock signal
        we      : in std_logic;                      -- Write enable signal (single-bit)
        d_in    : in std_logic_vector(31 downto 0);  -- 32-bit input data
        d_out   : out std_logic_vector(31 downto 0)  -- 32-bit output data
    );
end reg32;

architecture Behavioral of reg32 is
    signal reg_data : std_logic_vector(31 downto 0) := (others => '0');  -- Register storage
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                reg_data <= d_in;  -- Write new data to the register if write enable is high
            end if;
        end if;
    end process;

    -- Assign the register's stored value to the output
    d_out <= reg_data;

end Behavioral;
