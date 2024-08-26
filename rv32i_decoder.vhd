-- ============================================================
-- File Name: rv32i_decoder.vhd
-- Desc: Instruction decoder block for RV32I ISA with updated ALU_OP and BRANCH formats.
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- ################### RV32I DECODER #####################
-- Parses the obtained 32-bit instruction code into a 4-bit alu and 3-bit branch signals with
-- 1-bit signals. Immediate values are forwarded through into the ALU substituting a second 
-- operand register.
-- ################### OUTPUT STATES ###################
--
-- | Instruction    | Opcode   | Funct3 | Funct7   | ALU_OP | BRANCH | MEM_READ | MEM_WRITE | PC_WRITE  | ALU_SRC | IMM_OUT        |
-- |----------------|----------|--------|----------|--------|--------|----------|-----------|-----------|---------|----------------|
-- | ADD (R-Type)   | 0110011  | 000    | 0000000  | 0x0    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | ADDI (I-Type)  | 0010011  | 000    | N/A      | 0x0    | 000    | 0        | 0         | 0         | 1       | 12-bit Imm     |
-- | SUB (R-Type)   | 0110011  | 000    | 0100000  | 0x1    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | AND (R-Type)   | 0110011  | 111    | 0000000  | 0x2    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | ANDI (I-Type)  | 0010011  | 111    | N/A      | 0x2    | 000    | 0        | 0         | 0         | 1       | 12-bit Imm     |
-- | OR (R-Type)    | 0110011  | 110    | 0000000  | 0x3    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | ORI (I-Type)   | 0010011  | 110    | N/A      | 0x3    | 000    | 0        | 0         | 0         | 1       | 12-bit Imm     |
-- | XOR (R-Type)   | 0110011  | 100    | 0000000  | 0x4    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | XORI (I-Type)  | 0010011  | 100    | N/A      | 0x4    | 000    | 0        | 0         | 0         | 1       | 12-bit Imm     |
-- | SLL (R-Type)   | 0110011  | 001    | 0000000  | 0x5    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | SLLI (I-Type)  | 0010011  | 001    | 0000000  | 0x5    | 000    | 0        | 0         | 0         | 1       | 5-bit Imm      |
-- | SRL (R-Type)   | 0110011  | 101    | 0000000  | 0x6    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | SRLI (I-Type)  | 0010011  | 101    | 0000000  | 0x6    | 000    | 0        | 0         | 0         | 1       | 5-bit Imm      |
-- | SRA (R-Type)   | 0110011  | 101    | 0100000  | 0x7    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | SRAI (I-Type)  | 0010011  | 101    | 0100000  | 0x7    | 000    | 0        | 0         | 0         | 1       | 5-bit Imm      |
-- | SLT (R-Type)   | 0110011  | 010    | 0000000  | 0x8    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | SLTI (I-Type)  | 0010011  | 010    | N/A      | 0x8    | 000    | 0        | 0         | 0         | 1       | 12-bit Imm     |
-- | SLTU (R-Type)  | 0110011  | 011    | 0000000  | 0x9    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | SLTIU (I-Type) | 0010011  | 011    | N/A      | 0x9    | 000    | 0        | 0         | 0         | 1       | 12-bit Imm     |
-- | LB (I-Type)    | 0000011  | 000    | N/A      | 0x0    | 000    | 1        | 0         | 0         | 1       | 12-bit Imm     |
-- | LH (I-Type)    | 0000011  | 001    | N/A      | 0x0    | 000    | 1        | 0         | 0         | 1       | 12-bit Imm     |
-- | LW (I-Type)    | 0000011  | 010    | N/A      | 0x0    | 000    | 1        | 0         | 0         | 1       | 12-bit Imm     |
-- | LBU (I-Type)   | 0000011  | 100    | N/A      | 0x0    | 000    | 1        | 0         | 0         | 1       | 12-bit Imm     |
-- | LHU (I-Type)   | 0000011  | 101    | N/A      | 0x0    | 000    | 1        | 0         | 0         | 1       | 12-bit Imm     |
-- | SB (S-Type)    | 0100011  | 000    | N/A      | 0x0    | 000    | 0        | 1         | 0         | 1       | 12-bit Imm     |
-- | SH (S-Type)    | 0100011  | 001    | N/A      | 0x0    | 000    | 0        | 1         | 0         | 1       | 12-bit Imm     |
-- | SW (S-Type)    | 0100011  | 010    | N/A      | 0x0    | 000    | 0        | 1         | 0         | 1       | 12-bit Imm     |
-- | BEQ (B-Type)   | 1100011  | 000    | N/A      | 0x0    | 000    | 0        | 0         | 1         | 0       | 13-bit Imm     |
-- | BNE (B-Type)   | 1100011  | 001    | N/A      | 0x0    | 001    | 0        | 0         | 1         | 0       | 13-bit Imm     |
-- | BLT (B-Type)   | 1100011  | 100    | N/A      | 0x0    | 100    | 0        | 0         | 1         | 0       | 13-bit Imm     |
-- | BGE (B-Type)   | 1100011  | 101    | N/A      | 0x0    | 101    | 0        | 0         | 1         | 0       | 13-bit Imm     |
-- | BLTU (B-Type)  | 1100011  | 110    | N/A      | 0x0    | 110    | 0        | 0         | 1         | 0       | 13-bit Imm     |
-- | BGEU (B-Type)  | 1100011  | 111    | N/A      | 0x0    | 111    | 0        | 0         | 1         | 0       | 13-bit Imm     |
-- | JAL (J-Type)   | 1101111  | N/A    | N/A      | 0xA    | 000    | 0        | 0         | 1         | 1       | 20-bit Imm     |
-- | JALR (I-Type)  | 1100111  | 000    | N/A      | 0xB    | 000    | 0        | 0         | 1         | 1       | 12-bit Imm     |
-- | LUI (U-Type)   | 0110111  | N/A    | N/A      | 0xC    | 000    | 0        | 0         | 0         | 1       | 20-bit Imm     |
-- | AUIPC (U-Type) | 0010111  | N/A    | N/A      | 0xD    | 000    | 0        | 0         | 1         | 1       | 20-bit Imm     |
-- | ECALL          | 1110011  | 000    | N/A      | 0xE    | 000    | 0        | 0         | 0         | 0       | N/A            |
-- | EBREAK         | 1110011  | 001    | N/A      | 0xF    | 000    | 0        | 0         | 0         | 0       | N/A            |

entity rv32i_decoder is
    port (
        instruction : in std_logic_vector(31 downto 0);
        alu_op      : out std_logic_vector(3 downto 0);
        branch      : out std_logic_vector(2 downto 0);
        mem_read    : out std_logic;
        mem_write   : out std_logic;
        pc_write    : out std_logic;
        alu_src     : out std_logic;
        imm_out     : out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of rv32i_decoder is
begin
    process (instruction)
        variable op_code   : std_logic_vector(6 downto 0);
        variable funct3    : std_logic_vector(2 downto 0);
        variable funct7    : std_logic_vector(6 downto 0);
        variable imm       : std_logic_vector(31 downto 0);
    begin
        -- Default values
        alu_op     <= x"0";  -- Default ALU operation code
        branch     <= "000";  -- Default branch code
        mem_read   <= '0';  -- Default memory read
        mem_write  <= '0';  -- Default memory write
        pc_write  <= '0';  -- Default register write
        alu_src    <= '0';  -- Default ALU source
        imm_out    <= (others => '0');  -- Default immediate output
        
        -- Extract fields
        op_code   := instruction(6 downto 0);
        funct3    := instruction(14 downto 12);
        funct7    := instruction(31 downto 25);
        
        case op_code is
            when "0110011" =>  -- R-Type
                case funct3 is
                    when "000" =>
                        case funct7 is
                            when "0000000" =>  -- ADD
                                alu_op <= x"0";
                            when "0100000" =>  -- SUB
                                alu_op <= x"1";
                            when others =>
                                null;
                        end case;
                    when "111" =>
                        case funct7 is
                            when "0000000" =>  -- AND
                                alu_op <= x"2";
                            when others =>
                                null;
                        end case;
                    when "110" =>
                        case funct7 is
                            when "0000000" =>  -- OR
                                alu_op <= x"3";
                            when others =>
                                null;
                        end case;
                    when "100" =>
                        case funct7 is
                            when "0000000" =>  -- XOR
                                alu_op <= x"4";
                            when others =>
                                null;
                        end case;
                    when "001" =>
                        case funct7 is
                            when "0000000" =>  -- SLL
                                alu_op <= x"5";
                            when others =>
                                null;
                        end case;
                    when "101" =>
                        case funct7 is
                            when "0000000" =>  -- SRL
                                alu_op <= x"6";
                            when "0100000" =>  -- SRA
                                alu_op <= x"7";
                            when others =>
                                null;
                        end case;
                    when "010" =>
                        case funct7 is
                            when "0000000" =>  -- SLT
                                alu_op <= x"8";
                            when others =>
                                null;
                        end case;
                    when "011" =>
                        case funct7 is
                            when "0000000" =>  -- SLTU
                                alu_op <= x"9";
                            when others =>
                                null;
                        end case;
                    when others =>
                        null;
                end case;
            when "0010011" =>  -- I-Type
                case funct3 is
                    when "000" =>  -- ADDI
                        alu_op <= x"0";
                        alu_src <= '1';
                        imm_out <= instruction(31 downto 20);
                    when "111" =>  -- ANDI
                        alu_op <= x"2";
                        alu_src <= '1';
                        imm_out <= instruction(31 downto 20);
                    when "110" =>  -- ORI
                        alu_op <= x"3";
                        alu_src <= '1';
                        imm_out <= instruction(31 downto 20);
                    when "100" =>  -- XORI
                        alu_op <= x"4";
                        alu_src <= '1';
                        imm_out <= instruction(31 downto 20);
                    when "001" =>  -- SLLI
                        alu_op <= x"5";
                        alu_src <= '1';
                        imm_out <= instruction(24 downto 20);  -- 5-bit immediate
                    when "010" =>  -- SLTI
                        alu_op <= x"8";
                        alu_src <= '1';
                        imm_out <= instruction(31 downto 20);
                    when "011" =>  -- SLTIU
                        alu_op <= x"9";
                        alu_src <= '1';
                        imm_out <= instruction(31 downto 20);
                    when "101" =>  -- SRLI/SRAI
                        case funct7 is
                            when "0000000" =>  -- SRLI
                                alu_op <= x"6";
                                alu_src <= '1';
                                imm_out <= instruction(24 downto 20);  -- 5-bit immediate
                            when "0100000" =>  -- SRAI
                                alu_op <= x"7";
                                alu_src <= '1';
                                imm_out <= instruction(24 downto 20);  -- 5-bit immediate
                            when others =>
                                null;
                        end case;
                    when others =>
                        null;
                end case;
            when "0000011" =>  -- Load (I-Type)
                case funct3 is
                    when "000" | "001" | "010" | "100" | "101" =>  -- LB, LH, LW, LBU, LHU
                        mem_read <= '1';
                        alu_src <= '1';
                        imm_out <= instruction(31 downto 20);
                    when others =>
                        null;
                end case;
            when "0100011" =>  -- Store (S-Type)
                case funct3 is
                    when "000" | "001" | "010" =>  -- SB, SH, SW
                        mem_write <= '1';
                        alu_src <= '1';
                        imm_out <= instruction(31 downto 25) & instruction(11 downto 7);  -- 12-bit immediate
                    when others =>
                        null;
                end case;
            when "1100011" =>  -- Branch (B-Type)
                case funct3 is
                    when "000" | "001" | "100" | "101" | "110" | "111" =>  -- BEQ, BNE, BLT, BGE, BLTU, BGEU
                        branch <= funct3;
                        imm_out <= instruction(31 downto 20);  -- 13-bit immediate
                        pc_write <= '1';
                    when others =>
                        null;
                end case;
            when "1101111" =>  -- JAL (J-Type)
                alu_op <= x"A";
                imm_out <= instruction(31 downto 12) & (others => '0');  -- 20-bit immediate
                pc_write <= '1';
            when "1100111" =>  -- JALR (I-Type)
                alu_op <= x"B";
                imm_out <= instruction(31 downto 20);  -- 12-bit immediate
                pc_write <= '1';
                alu_src <= '1';
            when "0110111" =>  -- LUI (U-Type)
                alu_op <= x"C";
                imm_out <= instruction(31 downto 12) & (others => '0');  -- 20-bit immediate
            when "0010111" =>  -- AUIPC (U-Type)
                alu_op <= x"D";
                imm_out <= instruction(31 downto 12) & (others => '0');  -- 20-bit immediate
                pc_write <= '1';
            when "1110011" =>  -- System (ECALL/EBREAK)
                case funct3 is
                    when "000" =>  -- ECALL
                        alu_op <= x"E";
                    when "001" =>  -- EBREAK
                        alu_op <= x"F";
                    when others =>
                        null;
                end case;
            when others =>
                null;
        end case;
    end process;
end architecture;


