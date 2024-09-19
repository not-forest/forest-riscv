-- ============================================================
-- File Name: cpu.vhd
-- Desc: Highest toplevel entity in the design hierarchy. Connects three pipeline stages
--      together, as well as some separate higher level entities.
-- Ver: All code is designed to use VHDL 2008.
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
use friscv.primitives.all;
use friscv.debug.all;

use friscv.fetch_stage;
use friscv.decode_stage;
use friscv.execute_stage;
use friscv.dbg_controller;

entity cpu is
    port (
        i_dbg       : in t_DebugInputRecord;            -- Input debug data from the external JTAG controller.
        o_dbg       : out t_word;                       -- Debug output of data transfered to the external controller.
        o_clk_ref   : out std_logic;                    -- Currently used CPU clock.

        i_clk       : in std_logic := '1';              -- Global clock.
        na_clr      : in std_logic := '1'               -- Global reset (Active low).
         );
end entity;

architecture rv32i of cpu is
    signal w_clk_s  : std_logic          := '1';                      -- Input clock source (external/debug)
    signal w_naclr_s: std_logic          := '1';                      -- Input asyncronous reset source (external/debug)

    signal w_cmp    : t_ComparatorRecord := c_COMPARATOR_RECORD_INIT; -- Global comparator result (rs1 ? rs2). [fetch <- decode -> execute]
    signal w_decode : t_DecoderRecord    := c_DECODER_RECORD_INIT;    -- Decoder output value.                 [fetch <- decode -> execute]
    signal w_sbus   : t_sbus             := c_CLEAR_SBUS;             -- SBUS data line.                       [         decode -> execute]
    signal w_instr  : t_word             := (others => '0');          -- Raw fetched instruction data          [fetch -> decode           ]
    signal w_pc     : t_word             := (others => '0');          -- Forwarded program counter             [fetch -> de->de -> execute]
    signal w_result : t_word             := (others => '0');          -- ALU result                            [fetch <----------- execute]
    signal w_data   : t_word             := (others => '0');          -- Data to write to the register file.   [         decode <- execute]

    signal w_dbgo     : t_DebugOutputRecord := c_DEBUG_OUTPUT_INIT;   -- Used to obtain data from the CPU via debugger chip.

    -- Fetch stage component socket --
    component fetch_stage is
        port (
            i_stall     : in std_logic;     -- Stalls the fetch stage by halting the PC and two buffer registers. 
            i_pc_load   : in std_logic;     -- The condition for PC overloading are fully met.
            i_result    : in t_word;        -- Result value from the ALU (Execute stage).
            o_instr     : out t_word;       -- Output intruction passed to the decoder.
            o_pc        : out t_word;       -- Forwarding the current program counter value.

            i_clk       : in std_logic;     -- Global clock.
            na_clr      : in std_logic      -- Global reset.
             );
    end component;

    -- Decode stage component socket --
    component decode_stage is
        port (
            i_instr     : in t_word;                        -- Raw instruction obtained from the fetch cycle stage.
            i_data      : in t_word;                        -- Data obtained from the execute cycle stage to write back to register file.
            i_pc        : in t_word;                        -- PC value forwarded from the fetch stage.
            o_sbus      : out t_sbus;                       -- SBUS output value.
            o_decode    : out t_DecoderRecord;              -- Parsed decoder output.
            o_cmp       : out t_ComparatorRecord;           -- Comparator output for the execute stage.

            o_dbg_regs  : out t_regs;                       -- Forwards to debugger chip. Only used with debug.
    
            i_clk       : in std_logic;                     -- Global clock.
            na_clr      : in std_logic                      -- Global reset.
         );
    end component;

    -- Execute stage component socket --
    component execute_stage is
        port (
            i_cmp       : in t_ComparatorRecord;            -- Compare value data of (rs1 and rs2).
            i_sbus      : in t_sbus;                        -- Input from SBUS
            i_pc        : in t_word;                        -- PC value source.
            i_decode    : in t_DecoderRecord;               -- Decoded instruction input signals.
            o_result    : out t_word;                       -- Forwarded result from the ALU.
            o_data      : out t_word;                       -- Data to the register file.

            i_clk       : in std_logic;                     -- Global clock.
            na_clr      : in std_logic                      -- Global reset.
         );
    end component;
begin
    -- Controls the CPU and obtains debug data from it.
    --
    -- When control is transfered from the OS to debugger, it holds the clock and reset line.
    -- System console should be used to control the state of the whole CPU.
    DBG_CONTROLLER_Inst : entity dbg_controller
     port map(
        i_dbgi => i_dbg,
        i_dbgo => w_dbgo,
        o_dbg => o_dbg,
        i_clk => i_clk,
        na_clr => na_clr,
        o_clk => w_clk_s,
        ona_clr => w_naclr_s
    ); 

    -- Fetches the next instruction from the program memory.    --
    FETCH_STAGE_Inst : fetch_stage
    port map(
        i_stall => w_decode.pc_write,
        i_pc_load => w_cmp.branch_match,
        i_result => w_result,
        o_instr => w_instr,
        o_pc => w_pc,
        i_clk => w_clk_s,
        na_clr => w_naclr_s
    );

    -- Decodes the instruction. Pushes data for execution       --
    DECODE_STAGE_Inst : decode_stage
    port map(
        i_instr => w_instr,
        i_data => w_data,
        i_pc => w_pc,
        o_sbus => w_sbus,
        o_decode => w_decode,
        o_cmp => w_cmp,
        o_dbg_regs => w_dbgo.regs,
        i_clk => w_clk_s,
        na_clr => w_naclr_s
    );

    -- Executes the decoded instruction and saves the data.     --
    EXECUTE_STAGE_Inst : execute_stage
    port map(
        i_cmp => w_cmp,
        i_sbus => w_sbus,
        i_pc => w_pc,
        i_decode => w_decode,
        o_result => w_result,
        o_data => w_data,
        i_clk => w_clk_s,
        na_clr => w_naclr_s
    );

    -- Signals below are only used for debugger.
    o_clk_ref       <= w_clk_s;
    w_dbgo.pc       <= w_pc;
    w_dbgo.instr    <= w_instr;
    w_dbgo.decode   <= w_decode;
end architecture;

-- Top level configuration for all three pipeline stages.
configuration CpuConfig of cpu is
    -- This configuration is used to provide a CPU working on a base instruction set RV32I.
    for rv32i
        for FETCH_STAGE_Inst : fetch_stage
            use entity friscv.fetch_stage(rv32i);
        end for;

        for DECODE_STAGE_Inst : decode_stage
            use entity friscv.decode_stage(rv32i);
        end for;

        for EXECUTE_STAGE_Inst : execute_stage 
            use entity friscv.execute_stage(rv32i);
        end for;
    end for;
end configuration;
