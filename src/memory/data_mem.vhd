-- ============================================================
-- File Name: data_mem.vhd
-- Desc: CPU data RAM memory. Holds data obtained from store instructions and reads with load instructions.
--      Will automatically convert data to a proper format with sign extension, based on the instruction used.
-- TODO!: Swap to memory cache instead, when implementing system bus.
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
use friscv.memory.all;
use friscv.mem_interface;

entity data_mem is
    port (
        i_decode    : in t_DecoderRecord;               -- Input decoded flags.
        i_clk       : in std_logic;                     -- Input clock source.
        i_data      : in t_word;                        -- Input bus for storing data.
        i_addr      : in t_word;                        -- Input address word.
        o_data      : out t_word;                       -- Output data for reading data.
        na_clr      : in std_logic                      -- Clears the data memory. (Active low).
         );
end entity;

architecture structured of data_mem is
    signal w_bwrite : std_logic_vector(3 downto 0) := (others => '0');      -- Write full word, or stripped half-word/byte. 
    signal w_output : signed(t_word'range)         := (others => '0');      -- Used to prepare the value when reading data.
    signal w_wenable: std_logic                    := '0';                  -- Enables/disables memory for writing.
begin
    process (all) begin
        if falling_edge(i_clk) then
            -- Funct3 decides about the witdh of data from load/store type instruction.
            -- Each set bit defined one byte to load [ BYTE3 | BYTE2 | BYTE2 | BYTE1]. Others are ignored.
            case i_decode.funct3 is
                when "000" => -- LB | SB
                    w_bwrite <= "0001"; 
                    o_data <= t_word(resize(w_output(7 downto 0), 32));  -- Sign extension for signed byte data. 
                when "001" => -- LH | SH
                    w_bwrite <= "0011"; 
                    o_data <= t_word(resize(w_output(15 downto 0), 32));  -- Sign extension for signed half-word data.  
                when "010" =>  -- LW | SW
                    w_bwrite <= "1111";
                    o_data <= t_word(w_output);
                when "100" =>  -- LBU
                    w_bwrite <= "0001";
                    o_data <= t_word(w_output);
                when "101" =>  -- LHU
                    w_bwrite <= "0011";
                    o_data <= t_word(w_output);
                when others => unreachable;
            end case;
        end if;
    end process;

    MEM_INTERFACE_Inst : entity mem_interface
     generic map(
        g_DEPTH => 16                   --> 65536 bytes => 16384 words (temporary).
    )
     port map(
        i_data => i_data,
        i_addr => i_addr(15 downto 0),  --> temporary.
        i_bwrite => w_bwrite,
        i_clk => i_clk,
        i_wenable => w_wenable,
        o_data => w_output,
        na_clr => na_clr
    );

    -- Only enable writes when store instruction is used.
    w_wenable <= '1' when i_decode.opsel = x"f" else '0';
end architecture;
