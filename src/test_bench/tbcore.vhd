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
use friscv.primitives.all;

-- Defines different data types for writing test benches.
package tb is
    -- Custom clock type for testbench simulations.
    subtype t_clock is X01; 

    -- Provides a constant simulation of clock ticks with certain frequency --
    procedure tick (signal clk  : inout t_clock; signal freq : in real);

    -- Debug function for decoder's record structure.
    function debug(d: t_DecoderRecord) return string;
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

    -- Debug function for decoder's record structure.
    function debug(d: t_DecoderRecord) return string is
    begin
        return    "   rs1: "      & to_string(d.rs1)        & lf
                & "   rs2: "      & to_string(d.rs2)        & lf
                & "   dbus: "     & to_string(d.dbus)       & lf
                & "   opsel: "    & to_string(d.opsel)      & lf
                & "   funct3: "   & to_string(d.funct3)     & lf
                & "   dbus_en: "  & to_string(d.dbus_en)    & lf
                & "   alu_src: "  & to_string(d.alu_src)    & lf
                & "   pc_write: " & to_string(d.pc_write)   & lf
                & "   mem_read: " & to_string(d.mem_read)   & lf
                & "   bad: "      & to_string(d.bad)        & lf
                & "   env: "      & to_string(d.env)        & lf;
    end function;
end package body;

library friscv;
library ieee;
use ieee.std_logic_1164.all;
use friscv.primitives.all;

-- Defines all RV32I instructions asserts.
package tb_rv32i is
    -- Allows to hold a pair of I/O signals for assertion.
    type t_assert is record
        name    : string(1 to 6);
        left    : t_word;
        right   : t_DecoderRecord;
    end record;

    -- add x31, x31, x31
    constant c_ADD : t_assert := (
        name => "ADD   ",
        left => x"01_ff_8f_b3",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- addi x31, x31, -1
    constant c_ADDI : t_assert := (
        name => "ADDI  ",
        left => x"ff_ff_8f_93",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- sub x31, x31, x31
    constant c_SUB : t_assert := (
        name => "SUB   ",
        left => x"41_ff_8f_b3",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"1",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- and x31, x31, x31
    constant c_AND : t_assert := (
        name => "AND   ",
        left => x"01_ff_ff_b3",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"2",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );

    -- andi x31, x31, 2047
    constant c_ANDI : t_assert := (
        name => "ANDI  ",
        left => x"7f_ff_ff_93",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"2",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- or x31, x31, x31
    constant c_OR : t_assert := (
        name => "OR    ",
        left => x"01_ff_ef_b3",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"3",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- ori x31, x31, 2047
    constant c_ORI : t_assert := (
        name => "ORI   ",
        left => x"7f_ff_ef_93",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"3",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- xor x31, x31, x31
    constant c_XOR : t_assert := (
        name => "XOR   ",
        left => x"01_ff_cf_b3",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"4",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- xori x31, x31, 2047
    constant c_XORI : t_assert := (
        name => "XORI  ",
        left => x"7f_ff_cf_93",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"4",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );

    -- sll x31, x31, x31
    constant c_SLL : t_assert := (
        name => "SLL   ",
        left => x"01_ff_9f_b3",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"5",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- sll x31, x31, 0x10
    constant c_SLLI : t_assert := (
        name => "SLLI  ",
        left => x"01_0f_9f_93",
        right => (
            rs1 => (others => '1'),
            rs2 => "10000",
            dbus => (others => '1'),
            opsel => x"5",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- srl x31, x31, x31
    constant c_SRL : t_assert := (
        name => "SRL   ",
        left => x"01_ff_df_b3",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"6",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- srli x31, x31, 0x10
    constant c_SRLI : t_assert := (
        name => "SRLI  ",
        left => x"01_0f_df_93",
        right => (
            rs1 => (others => '1'),
            rs2 => "10000",
            dbus => (others => '1'),
            opsel => x"6",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- sra x31, x31, x31
    constant c_SRA : t_assert := (
        name => "SRA   ",
        left => x"41_ff_df_b3",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"7",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- srai x31, x31, 0x10
    constant c_SRAI : t_assert := (
        name => "SRAI  ",
        left => x"41_0f_df_93",
        right => (
            rs1 => (others => '1'),
            rs2 => "10000",
            dbus => (others => '1'),
            opsel => x"7",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- slt x31, x31, x31
    constant c_SLT : t_assert := (
        name => "SLT   ",
        left => x"01_ff_af_b3",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"8",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- slt x31, x31, 0x10
    constant c_SLTI : t_assert := (
        name => "SLTI  ",
        left => x"01_0f_af_93",
        right => (
            rs1 => (others => '1'),
            rs2 => "10000",
            dbus => (others => '1'),
            opsel => x"8",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- sltu x31, x31, x31
    constant c_SLTU : t_assert := (
        name => "SLTU  ",
        left => x"01_ff_3f_b3",
        right => (
            rs1 => "11110",
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"9",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- sltiu x31, x31, 0x10
    constant c_SLTIU : t_assert := (
        name => "SLTIU ",
        left => x"01_0f_bf_93",
        right => (
            rs1 => (others => '1'),
            rs2 => "10000",
            dbus => (others => '1'),
            opsel => x"9",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- beq x31, x31, 0xfffff
    constant c_BEQ : t_assert := (
        name => "BEQ   ",
        left => x"01_ff_84_63",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => "01000",
            opsel => x"0",
            funct3 => "000",
            dbus_en => '0',
            alu_src => '1',
            pc_write => '1',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- bne x31, x31, 0xfffff
    constant c_BNE : t_assert := (
        name => "BNE   ",
        left => x"01_ff_94_63",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => "01000",
            opsel => x"0",
            funct3 => "001",
            dbus_en => '0',
            alu_src => '1',
            pc_write => '1',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- blt x31, x31, 0xfffff
    constant c_BLT : t_assert := (
        name => "BLT   ",
        left => x"01_ff_c4_63",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => "01000",
            opsel => x"0",
            funct3 => "100",
            dbus_en => '0',
            alu_src => '1',
            pc_write => '1',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- bge x31, x31, 0xfffff
    constant c_BGE : t_assert := (
        name => "BGE   ",
        left => x"01_ff_d4_63",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => "01000",
            opsel => x"0",
            funct3 => "101",
            dbus_en => '0',
            alu_src => '1',
            pc_write => '1',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- bltu x31, x31, 0xfffff
    constant c_BLTU : t_assert := (
        name => "BLTU  ",
        left => x"01_ff_e4_63",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => "01000",
            opsel => x"0",
            funct3 => "110",
            dbus_en => '0',
            alu_src => '1',
            pc_write => '1',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- bgeu x31, x31, 0xfffff
    constant c_BGEU : t_assert := (
        name => "BGEU  ",
        left => x"01_ff_f4_63",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => "01000",
            opsel => x"0",
            funct3 => "111",
            dbus_en => '0',
            alu_src => '1',
            pc_write => '1',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- jal x31, 0xfffff 
    constant c_JAL : t_assert := (
        name => "JAL   ",
        left => x"00_00_0f_ef",
        right => (
            rs1 => (others => '0'),
            rs2 => (others => '0'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "010",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '1',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- jal x31, 0(x31) 
    constant c_JALR : t_assert := (
        name => "JALR  ",
        left => x"00_0f_8f_e7",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '0'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "010",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- lui x31, 0xfffff
    constant c_LUI : t_assert := (
        name => "LUI   ",
        left => x"ff_ff_ff_b7",
        right => (
            rs1 => (others => '0'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- auipc x31, 0xfffff
    constant c_AUIPC : t_assert := (
        name => "AUIPC ",
        left => x"ff_ff_ff_97",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '1',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- lb x31 0(x31)
    constant c_LB : t_assert := (
        name => "LB    ",
        left => x"00_0f_8f_83",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '0'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "000",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '1',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- lh x31 0(x31)
    constant c_LH : t_assert := (
        name => "LH    ",
        left => x"00_0f_9f_83",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '0'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "001",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '1',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- lw x31 0(x31)
    constant c_LW : t_assert := (
        name => "LW    ",
        left => x"00_0f_af_83",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '0'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "010",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '1',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- lbu x31 0(x31)
    constant c_LBU : t_assert := (
        name => "LBU   ",
        left => x"00_0f_cf_83",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '0'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "100",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '1',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- lhu x31 0(x31)
    constant c_LHU : t_assert := (
        name => "LHU   ",
        left => x"00_0f_df_83",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '0'),
            dbus => (others => '1'),
            opsel => x"0",
            funct3 => "101",
            dbus_en => '1',
            alu_src => '1',
            pc_write => '0',
            mem_read => '1',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- sb x31 0(x31)
    constant c_SB : t_assert := (
        name => "SB    ",
        left => x"01_ff_80_23",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '0'),
            opsel => x"f",
            funct3 => "000",
            dbus_en => '0',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- sh x31 0(x31)
    constant c_SH : t_assert := (
        name => "SH    ",
        left => x"01_ff_90_23",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '0'),
            opsel => x"f",
            funct3 => "001",
            dbus_en => '0',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- sw x31 0(x31)
    constant c_SW : t_assert := (
        name => "SW    ",
        left => x"01_ff_a0_23",
        right => (
            rs1 => (others => '1'),
            rs2 => (others => '1'),
            dbus => (others => '0'),
            opsel => x"f",
            funct3 => "010",
            dbus_en => '0',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- fence
    constant c_FENCE : t_assert := (
        name => "FENCE ",
        left => x"0f_f0_00_0f",
        right => (
            rs1 => (others => '0'),
            rs2 => (others => '1'),
            dbus => (others => '0'),
            opsel => x"0",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => c_DECODER_RECORD_INIT.env
        )
    );
    
    -- ecall
    constant c_ECALL : t_assert := (
        name => "ECALL ",
        left => x"00_00_00_73",
        right => (
            rs1 => (others => '0'),
            rs2 => (others => '0'),
            dbus => (others => '0'),
            opsel => x"0",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => '0'
        )
    );
    
    -- ebreak
    constant c_EBREAK : t_assert := (
        name => "EBREAK",
        left => x"00_10_00_73",
        right => (
            rs1 => (others => '0'),
            rs2 => "00001",
            dbus => (others => '0'),
            opsel => x"0",
            funct3 => "011",
            dbus_en => '1',
            alu_src => '0',
            pc_write => '0',
            mem_read => '0',
            bad => '0',
            env => '1'
        )
    );
end package;
