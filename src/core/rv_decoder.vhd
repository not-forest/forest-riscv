-- ============================================================
-- File Name: rv_decoder.vhd
-- Desc: Decodes the provided 32-bit instruction and outputs corresponding signal values.
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

entity decoder is
    port (
        i_instr     : in t_word;                -- RAW input 32-bit RISC-V instruction.
        o_decode    : out t_DecoderRecord;      -- Parsed decoder signals as record.
        o_imm       : out t_word                -- Parsed immediate is forwarded in a proper format.
         );
end entity;

-- ===============================================================================================================================
-- Base Integer Instruction Set (RV32I) decoder.
-- ===============================================================================================================================
-- Bellow is a table of all valid signal combinations. This decoder only supports basic RV32I instructions, and
-- will forward a (bad) flag bit, when unparsable instruction is found. Immediate is shifted within this decoder
-- and forwarded further. Funct3 is forwarded to the comparator and the data memory. Store operation uses 3 operands,
-- therefore 'rd' value is used as an immediate inside the ALU.
-- ===============================================================================================================================
-- | Instruction    | Opcode   | Funct3 (in) | Funct3(out) | opsel  | mem_read  | pc_write  | alu_src | dbus_en | imm            |
-- |----------------|----------|-------------|-------------|--------|-----------|-----------|---------|---------|----------------|
-- | ADD (R-Type)   | 0110011  | 000         | NEVER       | 0x0    | 0         | 0         | 0       | 1       | N/A            |
-- | ADDI (I-Type)  | 0010011  | 000         | NEVER       | 0x0    | 0         | 0         | 1       | 1       | 12-bit Imm     |
-- | SUB (R-Type)   | 0110011  | 000         | NEVER       | 0x1    | 0         | 0         | 0       | 1       | N/A            |
-- | AND (R-Type)   | 0110011  | 111         | NEVER       | 0x2    | 0         | 0         | 0       | 1       | N/A            |
-- | ANDI (I-Type)  | 0010011  | 111         | NEVER       | 0x2    | 0         | 0         | 1       | 1       | 12-bit Imm     |
-- | OR (R-Type)    | 0110011  | 110         | NEVER       | 0x3    | 0         | 0         | 0       | 1       | N/A            |
-- | ORI (I-Type)   | 0010011  | 110         | NEVER       | 0x3    | 0         | 0         | 1       | 1       | 12-bit Imm     |
-- | XOR (R-Type)   | 0110011  | 100         | NEVER       | 0x4    | 0         | 0         | 0       | 1       | N/A            |
-- | XORI (I-Type)  | 0010011  | 100         | NEVER       | 0x4    | 0         | 0         | 1       | 1       | 12-bit Imm     |
-- | SLL (R-Type)   | 0110011  | 001         | NEVER       | 0x5    | 0         | 0         | 0       | 1       | N/A            |
-- | SLLI (I-Type)  | 0010011  | 001         | NEVER       | 0x5    | 0         | 0         | 1       | 1       | 5-bit Imm      |
-- | SRL (R-Type)   | 0110011  | 101         | NEVER       | 0x6    | 0         | 0         | 0       | 1       | N/A            |
-- | SRLI (I-Type)  | 0010011  | 101         | NEVER       | 0x6    | 0         | 0         | 1       | 1       | 5-bit Imm      |
-- | SRA (R-Type)   | 0110011  | 101         | NEVER       | 0x7    | 0         | 0         | 0       | 1       | N/A            |
-- | SRAI (I-Type)  | 0010011  | 101         | NEVER       | 0x7    | 0         | 0         | 1       | 1       | 5-bit Imm      |
-- | SLT (R-Type)   | 0110011  | 010         | NEVER       | 0x8    | 0         | 0         | 0       | 1       | N/A            |
-- | SLTI (I-Type)  | 0010011  | 010         | NEVER       | 0x8    | 0         | 0         | 1       | 1       | 12-bit Imm     |
-- | SLTU (R-Type)  | 0110011  | 011         | NEVER       | 0x9    | 0         | 0         | 0       | 1       | N/A            |
-- | SLTIU (I-Type) | 0010011  | 011         | NEVER       | 0x9    | 0         | 0         | 1       | 1       | 12-bit Imm     |
-- | LB (I-Type)    | 0000011  | 000         | 000         | 0x0    | 1         | 0         | 1       | 1       | 12-bit Imm     |
-- | LH (I-Type)    | 0000011  | 001         | 001         | 0x0    | 1         | 0         | 1       | 1       | 12-bit Imm     |
-- | LW (I-Type)    | 0000011  | 010         | 010         | 0x0    | 1         | 0         | 1       | 1       | 12-bit Imm     |
-- | LBU (I-Type)   | 0000011  | 100         | 100         | 0x0    | 1         | 0         | 1       | 1       | 12-bit Imm     |
-- | LHU (I-Type)   | 0000011  | 101         | 101         | 0x0    | 1         | 0         | 1       | 1       | 12-bit Imm     |
-- | SB (S-Type)    | 0100011  | 000         | 000         | 0xf    | 0         | 0         | 1       | 0       | 12-bit Imm     |
-- | SH (S-Type)    | 0100011  | 001         | 001         | 0xf    | 0         | 0         | 1       | 0       | 12-bit Imm     |
-- | SW (S-Type)    | 0100011  | 010         | 010         | 0xf    | 0         | 0         | 1       | 0       | 12-bit Imm     |
-- | BEQ (B-Type)   | 1100011  | 000         | 000         | 0x0    | 0         | 1         | 1       | 0       | 13-bit Imm     |
-- | BNE (B-Type)   | 1100011  | 001         | 001         | 0x0    | 0         | 1         | 1       | 0       | 13-bit Imm     |
-- | BLT (B-Type)   | 1100011  | 100         | 100         | 0x0    | 0         | 1         | 1       | 0       | 13-bit Imm     |
-- | BGE (B-Type)   | 1100011  | 101         | 101         | 0x0    | 0         | 1         | 1       | 0       | 13-bit Imm     |
-- | BLTU (B-Type)  | 1100011  | 110         | 110         | 0x0    | 0         | 1         | 1       | 0       | 13-bit Imm     |
-- | BGEU (B-Type)  | 1100011  | 111         | 111         | 0x0    | 0         | 1         | 1       | 0       | 13-bit Imm     |
-- | JAL (J-Type)   | 1101111  | N/A         | ALWAYS      | 0x0    | 0         | 1         | 1       | 1       | 20-bit Imm     |
-- | JALR (I-Type)  | 1100111  | 000         | ALWAYS      | 0x0    | 0         | 0         | 1       | 1       | 12-bit Imm     |
-- | LUI (U-Type)   | 0110111  | N/A         | NEVER       | 0x0    | 0         | 0         | 1       | 1       | 20-bit Imm     |
-- | AUIPC (U-Type) | 0010111  | N/A         | NEVER       | 0x0    | 0         | 1         | 1       | 1       | 20-bit Imm     |
-- | ECALL          | 1110011  | 000         | NEVER       | 0x0    | 0         | 0         | 0       | 1       | N/A            |
-- | EBREAK         | 1110011  | 001         | NEVER       | 0x0    | 0         | 0         | 0       | 1       | N/A            |
architecture rv32i of decoder is
    signal r_env : std_logic := '1';    -- Holds the environment bit.
begin
    process(all)
        constant BRANCH_ALWAYS_FALSE : std_logic_vector(2 downto 0) := "011";    -- Causes the comparator to never overload the PC.
        constant BRANCH_ALWAYS_TRUE  : std_logic_vector(2 downto 0) := "010";    -- Causes the comparator to overload the PC without any condition.

        -- By default this variable always holds 0x3 value, which allows the comparator to see
        -- that there is no need to overload the PC. Together with 'p_write' flag it is used to
        -- parse the branch type and compare values. It is also used to parse the width of
        -- memory data for load/store operation. Even though most of the operation won't cause the
        -- 'p_write' flag to be set, it will still be FALSE by default.
        variable funct3  : std_logic_vector(2 downto 0);
        -- Variables below will change while parsing the instruciton.
        variable alu_src, pc_write, mem_read: std_logic;                 -- Additional CPU flags
        variable dbus_en : std_logic                   ;                 -- Disabled for branch, store and system instruction.
        variable opsel   : std_logic_vector(3 downto 0);                 -- Operation number for ALU
        variable imm     : t_word                      ;                 -- Parsed immediate value
        variable bad     : std_logic                   ;                 -- Indicates bad instruction and environment call

        -- Aliases below are used to address certain instruction bits.
        alias a_imm_bottom: std_logic_vector is i_instr(11 downto 7);             -- S/B-type format top bits immediate.
        alias a_imm_top   : std_logic_vector is i_instr(31 downto 25);            -- S/B-type format top bits immediate.
        alias a_imm_5bit  : std_logic_vector is i_instr(24 downto 20);            -- 5-bits used in shift immediate instructions.
        alias a_imm_ujtype: std_logic_vector is i_instr(31 downto 12);            -- U/J-type format 20-bit immediate.
        alias a_imm_itype : std_logic_vector is i_instr(31 downto 20);            -- I-type format 12-bit immediate.
        alias a_funct7    : std_logic_vector is i_instr(31 downto 25);            -- FUNCT7 fields.
        alias a_funct3    : std_logic_vector is i_instr(14 downto 12);            -- FUNCT3 fields.
        alias a_op_code   : std_logic_vector is i_instr(6 downto 0);              -- Defines the instruction format.

        -- Aliases for source and destination registers addresses.
        alias ars1      : std_logic_vector is i_instr(19 downto 15);            -- Source 1 register address.
        alias ars2      : std_logic_vector is i_instr(24 downto 20);            -- Source 2 register address.
        alias ard       : std_logic_vector is i_instr(11 downto 7);             -- Destination address

        -- Those are always forwarded even when some of them are not valid.
        variable rs1  : std_logic_vector(4 downto 0);          -- Source 1 register address.
        variable rs2  : std_logic_vector(4 downto 0);          -- Source 2 register address.
        variable rd   : std_logic_vector(4 downto 0);           -- Destination register address.
    begin
        -- Starting values.
        alu_src     := '0';
        pc_write    := '0';
        mem_read    := '0';
        bad         := '0';
        dbus_en     := '1';
        funct3      := BRANCH_ALWAYS_FALSE;
        rs1         := ars1;
        imm         := (others => '0');
        opsel       := (others => '0');

        rs1 := ars1;
        rs2 := ars2;
        rd  := ard;

        case a_op_code is
            -- ALU rs1, rs2 operations.
            when "0110011" =>  -- R-Type
                case a_funct3 is
                    when "000" =>  -- ADD, SUB
                        case a_funct7 is
                            when "0000000" =>  -- ADD
                                opsel := x"0";
                            when "0100000" =>  -- SUB
                                opsel := x"1";
                            when others =>
                                bad := '1';
                        end case;
                    when "111" =>  -- AND
                        case a_funct7 is
                            when "0000000" =>
                                opsel := x"2";
                            when others =>
                                bad := '1';
                        end case;
                    when "110" =>  -- OR
                        case a_funct7 is
                            when "0000000" =>
                                opsel := x"3";
                            when others =>
                                bad := '1';
                        end case;
                    when "100" =>  -- XOR
                        case a_funct7 is
                            when "0000000" =>
                                opsel := x"4";
                            when others =>
                                bad := '1';
                        end case;
                    when "001" =>  -- SLL
                        case a_funct7 is
                            when "0000000" =>
                                opsel := x"5";
                            when others =>
                                bad := '1';
                        end case;
                    when "101" =>  -- SRL, SRA
                        case a_funct7 is
                            when "0000000" =>
                                opsel := x"6";
                            when "0100000" =>
                                opsel := x"7";
                            when others =>
                                bad := '1';
                        end case;
                    when "010" =>  -- SLT
                        case a_funct7 is
                            when "0000000" =>
                                opsel := x"8";
                            when others =>
                                bad := '1';
                        end case;
                    when "011" =>  -- SLTU
                        case a_funct7 is
                            when "0000000" =>
                                opsel := x"9";
                            when others =>
                                bad := '1';
                        end case;
                    when others =>
                        bad := '1';
                end case;

            -- ALU rs1, imm operations.
            when "0010011" =>  -- I-Type
                case a_funct3 is
                    when "000" =>  -- ADDI
                        opsel := x"0";
                        alu_src := '1';
                        imm(11 downto 0) := a_imm_itype;
                    when "111" =>  -- ANDI
                        opsel := x"2";
                        alu_src := '1';
                        imm(11 downto 0) := a_imm_itype;
                    when "110" =>  -- ORI
                        opsel := x"3";
                        alu_src := '1';
                        imm(11 downto 0) := a_imm_itype;
                    when "100" =>  -- XORI
                        opsel := x"4";
                        alu_src := '1';
                        imm(11 downto 0) := a_imm_itype;
                    when "001" =>  -- SLLI
                        opsel := x"5";
                        alu_src := '1';
                        imm(4 downto 0) := a_imm_5bit;
                    when "010" =>  -- SLTI
                        opsel := x"8";
                        alu_src := '1';
                        imm(11 downto 0) := a_imm_itype;
                    when "011" =>  -- SLTIU
                        opsel := x"9";
                        alu_src := '1';
                        imm(11 downto 0) := a_imm_itype;
                    when "101" =>  -- SRLI/SRAI
                        case a_funct7 is
                            when "0000000" =>  -- SRLI
                                opsel := x"6";
                                alu_src := '1';
                                imm(4 downto 0) := a_imm_5bit;
                            when "0100000" =>  -- SRAI
                                opsel := x"7";
                                alu_src := '1';
                                imm(4 downto 0) := a_imm_5bit;
                            when others =>
                                bad := '1';
                        end case;
                    when others =>
                        bad := '1';
                end case;

            -- Reading from memory. Data width is resized within the memory.
            when "0000011" =>  -- Load (I-Type)
                case a_funct3 is
                    when "000" | "001" | "010" | "100" | "101" =>  -- LB, LH, LW, LBU, LHU
                        funct3 := a_funct3;
                        mem_read := '0';
                        alu_src := '1';
                        imm(11 downto 0) := a_imm_itype;
                    when others =>
                        bad := '1';
                end case;

            -- Writing to memory. Data width is resized within the memory.
            when "0100011" =>  -- Store (S-Type)
                case a_funct3 is
                    -- During store operations, the following is true: rd = imm.
                    when "000" | "001" | "010" =>  -- SB, SH, SW
                        funct3 := a_funct3;
                        dbus_en := '0';
                        opsel := x"f";
                    when others =>
                        bad := '1';
                end case;

            -- Branch operation.
            when "1100011" =>  -- Branch (B-Type)
                case a_funct3 is
                    when "000" | "001" | "100" | "101" | "110" | "111" =>  -- BEQ, BNE, BLT, BGE, BLTU, BGEU
                        funct3 := a_funct3;
                        imm(11 downto 0) := a_imm_top & a_imm_bottom;
                        dbus_en := '0';
                        pc_write := '1';
                        alu_src := '1';
                    when others =>
                        bad := '1';
                end case;

            -- Will perform PC = PC + imm. Will also cause rd = PC + 4
            when "1101111" =>  -- JAL (J-Type)
                imm(19 downto 0) := a_imm_ujtype;  -- 20-bit immediate
                funct3 := BRANCH_ALWAYS_TRUE;    -- This tells the comparator to overload the PC.
                alu_src := '1';
                pc_write := '1';

            -- Will perform PC = rs1 + imm. Will also cause rd = PC + 4
            when "1100111" =>  -- JALR (I-Type)
                -- pc_write is not used here since we are forwarding rs1 and imm
                imm(11 downto 0) := a_imm_itype;  -- 12-bit immediate
                funct3 := BRANCH_ALWAYS_TRUE;    -- This tells the comparator to overload the PC.
                alu_src := '1';

            -- Basically using add operation to add zero and upper immediate.
            when "0110111" =>  -- LUI (U-Type)
                rs1 := (others => '0');
                imm(31 downto 12) := a_imm_ujtype;  -- 20-bit immediate

            -- Basically using add operation to add PC and upper immediate.
            when "0010111" =>  -- AUIPC (U-Type)
                pc_write := '1';
                imm(31 downto 12) := a_imm_ujtype;  -- 20-bit immediate

            -- Environment commands are obtained by the debugger chip.
            when "1110011" =>  -- System (ECALL/EBREAK)
                case funct3 is
                    when "000" =>  -- ECALL
                        r_env <= '0';
                    when "001" =>  -- EBREAK
                        r_env <= '1';
                    when others =>
                        bad := '1';
                end case;

            when others =>
                bad := '1';
        end case;
        
        -- Assignment of record values
        o_decode.dbus <= rd;
        o_decode.rs1 <= rs1;
        o_decode.rs2 <= rs2;
        o_decode.funct3 <= funct3;
        o_decode.opsel <= opsel;
        o_decode.dbus_en <= dbus_en;
        o_decode.alu_src <= alu_src;
        o_decode.pc_write <= pc_write;
        o_decode.mem_read <= mem_read;
        o_decode.bad <= bad;
        o_decode.env <= r_env;
        -- Forwarded immediate.
        o_imm <= imm;
    end process;
end architecture;
