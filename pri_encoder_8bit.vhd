-- ============================================================
-- File Name: pri_encoder_10bit.vhd
-- Desc: 10-bit priority encoder for choosing the source input.
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
use ieee.std_logic_1164.all;

entity pri_encoder_10bit is
    port(
        din0   : in std_logic;  -- Input line 0
        din1   : in std_logic;  -- Input line 1
        din2   : in std_logic;  -- Input line 2
        din3   : in std_logic;  -- Input line 3
        din4   : in std_logic;  -- Input line 4
        din5   : in std_logic;  -- Input line 5
        din6   : in std_logic;  -- Input line 6
        din7   : in std_logic;  -- Input line 7
        din8   : in std_logic;  -- Input line 8
        din9   : in std_logic;  -- Input line 9
        dout   : out std_logic_vector(3 downto 0)  -- 4-bit output representing the highest priority input
    );
end pri_encoder_10bit;

architecture Behavioral of pri_encoder_10bit is
begin
    encoder : process(din0, din1, din2, din3, din4, din5, din6, din7, din8, din9) is
    begin
        if (din9 = '1') then
            dout <= "1001";
        elsif (din8 = '1') then
            dout <= "1000";
        elsif (din7 = '1') then
            dout <= "0111";
        elsif (din6 = '1') then
            dout <= "0110";
        elsif (din5 = '1') then
            dout <= "0101";
        elsif (din4 = '1') then
            dout <= "0100";
        elsif (din3 = '1') then
            dout <= "0011";
        elsif (din2 = '1') then
            dout <= "0010";
        elsif (din1 = '1') then
            dout <= "0001";
        elsif (din0 = '1') then
            dout <= "0000";
        else
            dout <= "0000"; -- Default output when no inputs are '1'
        end if;
    end process encoder;
end Behavioral;
