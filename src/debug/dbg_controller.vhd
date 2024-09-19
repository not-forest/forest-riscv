-- ============================================================
-- File Name: dbg_controller.vhd
-- Desc: Defines a debug controller for obtaining data from the current state of the CPU. This chip will obtain controll
--      over the CPU when the EBREAK instruction is used. Transfer control back to the CPU when ECALL is used. By default
--      debug chip does not control the CPU until above conditions are not met.
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
use ieee.numeric_std.all;
use friscv.primitives.all;
use friscv.debug.all;

entity dbg_controller is
    port (
        i_dbgi  : in t_DebugInputRecord;                                -- Input debug command and arguments.
        i_dbgo  : in t_DebugOutputRecord := c_DEBUG_OUTPUT_INIT;        -- Data record to communicate with the CPU.
        o_dbg   : out t_word;                                           -- Output fetched value from the OS.

        i_clk   : in std_logic := '1';                                  -- Global clock.
        na_clr  : in std_logic := '1';                                  -- Global reset.

        o_clk   : out std_logic := '1';                                 -- Output clock to the CPU.
        ona_clr : out std_logic := '1'                                  -- Output reset to the CPU.
         ); 
end entity;

architecture rtl of dbg_controller is
    signal r_odata : t_word := (others => '0');                         -- Prevents o_dbg latch.
begin
    -- Process for transfering data between debugger and system console.
    process (all) begin
        -- If debugger currently owns control over the CPU.
        if i_dbgo.decode.env = '1' then
        r_odata <= (others => '0');
        -- Ouput writing part.
        case i_dbgi.cmd is
            -- No-op.
            when NOP        => null; 
            -- Reading the PC.
            when READPC     => r_odata <= i_dbgo.pc;
            -- Selecting and reading the requested register.
            when READREG    => r_odata <= i_dbgo.regs(to_integer(unsigned(i_dbgi.data(4 downto 0)))); 
            -- Reading current raw instruction.
            when READINSTR  => r_odata <= i_dbgo.instr; 
            -- Writing decoded flags.
            when READVALS   => r_odata <= "00000"                 &
                                        i_dbgo.decode.bad       &
                                        i_dbgo.decode.env       &
                                        i_dbgo.decode.alu_src   &
                                        i_dbgo.decode.pc_write  &
                                        i_dbgo.decode.mem_read  &
                                        i_dbgo.decode.dbus      &
                                        i_dbgo.decode.rs2       &
                                        i_dbgo.decode.rs1       &
                                        i_dbgo.decode.opsel     &
                                        i_dbgo.decode.funct3;
            -- Writing a bit value to the clock line.
            when WRITECLK   => o_clk <= i_dbgi.data(0);
            -- Writing a bit value to the reset line.
            when RESET      => ona_clr <= i_dbgi.data(0);
            when others     => unreachable;
        end case;

        o_dbg <= r_odata;
        else
            o_clk   <= i_clk;
            ona_clr <= na_clr;
        end if;
    end process;
end architecture;

