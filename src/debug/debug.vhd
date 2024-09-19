-- ============================================================
-- File Name: debug.vhd
-- Desc: Defines debug related data types and functions. All data types do not affect the design logic for CPU itself,
--      but rather only provide an interface to read the current state of CPU and control it's behavior via system console.
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

package debug is
    -- Debug chip command data type. Allows to define which type of data to provide to and from the debugger.
    type t_DebugCmd is (
        NOP,        -- Does nothing.
        READREG,    -- Reads the current value of one of 32 general purpose register. (Data line is used to specify). 
        READPC,     -- Reads the current value of PC. (The newest value from fetch_stage is read).
        READINSTR,  -- Reads the currently forwarded instruction. (The newest value from fetch_stage is read).
        READVALS,   -- Reads the decoded output signals.
        WRITECLK,   -- Writes some value to the debug clock signal. (Data line is used to specify). 
        RESET       -- Causing the global reset within the system. This is the same as pressing the reset button on reset pin. 
    );
    -- Data record coming from the debug chip interface. It allows to parse which type of command the debug controller must perform.
    type t_DebugInputRecord is record 
        cmd     : t_DebugCmd;   -- Defines which command should the controller perform.
        data    : t_word;       -- Used during some commands as argument. For example to select one of 32 general purpose registers.
    end record;
    -- Debug lines that hold data values about the current CPU state. It will be forwarded to the JTAG debugger.
    type t_DebugOutputRecord is record 
        regs    : t_regs;           -- 32 general purpose registers in the exact current state.
        pc      : t_word;           -- PC register value in the exact current state.
        instr   : t_word;           -- Currently forwarded instruction to the decoder.
        decode  : t_DecoderRecord;  -- Obtained decoder signals.
    end record;

    constant c_DEBUG_OUTPUT_INIT : t_DebugOutputRecord := (
        regs => (others => (others => '0')),
        pc => (others => '0'), instr => (others => '0'),
        decode => c_DECODER_RECORD_INIT
    );

    -- Wraps the logic vector into the debug cmd.
    function to_cmd(v: t_byte) return t_DebugCmd;
end package;

package body debug is
    -- Wraps the logic vector into the debug cmd.
    function to_cmd(v: t_byte) return t_DebugCmd is
    begin
        return t_DebugCmd'val(to_integer(unsigned(v)));
    end function;
end package body;
