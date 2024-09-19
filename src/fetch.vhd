-- ============================================================
-- File Name: fetch.vhd
-- Desc: Defines a fetch instruction pipeline stage. This module contains all defined lower level 
--      entities that somehow related to the fetch stage. Performs an instruction fetch from the
--      program memory and increments the program counter. This stage lasts for one clock cycle.
--
--      This stage will be stalled, if one of the previous instructions were related to program counter
--      overloading, therefore can provide to pipeline hazard.
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

use friscv.program_mem;
use friscv.pc_reg;

entity fetch_stage is
    port (
        i_stall     : in std_logic := '0';     -- Stalls the fetch stage by halting the PC and two buffer registers. 
        i_pc_load   : in std_logic := '0';     -- The condition for PC overloading are fully met.
        i_result    : in t_word;               -- Result value from the ALU (Execute stage).
        o_instr     : out t_word;              -- Output intruction passed to the decoder.
        o_pc        : out t_word;              -- Forwarding the current program counter value.

        i_clk       : in std_logic := '1';     -- Global clock.
        na_clr      : in std_logic := '1'      -- Global reset.
         );
end entity;

architecture rv32i of fetch_stage is
    signal w_pc_bus : t_word;           -- Connects PC output and program memory.
    signal w_instr  : t_word;           -- Connects the fetched instruction to the buffer register.

    -- Program memory component socket. --
    component program_mem is
        port (
            i_clk       : in std_logic;
            i_pc        : in t_word;
            o_instr     : out t_word
             );
    end component;
begin
    -- Fetch stage defines the PC register                                      --
    -- The program counter is stalled only when branch operation is identified  --
    -- in a decode stage parallel to this fetch stage. The stall lasts for one  --
    -- clock cycle.                                                             --
    PC_REG_Inst : entity pc_reg
    port map (
        i_data => i_result,
        i_load => i_stall,
        i_halt => i_pc_load,
        ni_clk  => i_clk,
        o_data => w_pc_bus,
        na_clr => na_clr
             );

    -- Fetches the instruction addressed by PC value.                           --
    PROGRAM_MEM_Inst : program_mem  
    port map (
        i_clk => i_clk,
        i_pc => w_pc_bus,
        o_instr => w_instr
             );
    
    -- Pipeline buffer register between the PC register and the decoder.        -- 
    pipeline(i_clk, na_clr, w_pc_bus, o_pc);
    -- Pipeline buffer register between the PC register and the decoder.        -- 
    pipeline_stall(i_clk, na_clr, i_stall, w_instr, o_instr);
end architecture;

-- Configuration is used to define different architectures for fetch stage components. --
-- 
-- Vendor supplied memory IP is used.
configuration FetchConfig of fetch_stage is
    for rv32i
        for PROGRAM_MEM_Inst: program_mem
            use entity friscv.program_mem(vendor);  -- Using memory with hex loading supported by quartus.
        end for;
    end for;
end configuration;
