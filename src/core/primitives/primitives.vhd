-- ============================================================
-- File Name: primitives.vhd
-- Desc: Defines CPU primitive datatypes, subtypes and functions.
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

package primitives is
    subtype t_word is std_logic_vector(31 downto 0);    -- 32-bit CPU word line.
    subtype t_hword is std_logic_vector(15 downto 0);   -- 16-bit half-word.
    subtype t_byte is std_logic_vector(7 downto 0);     -- A byte of data, defined as one octet.

    -- Type definition for an array of std_logic_vectors. Used in mutexes and other primitives.
    type t_line_array is array (natural range <>) of std_logic_vector;
    -- A pair of CPU words, that traverse between the register file and the ALU.
    type t_sbus is array (0 to 1) of t_word;
    -- Subtype, which defines 32 general purpose register output lines.
    subtype t_regs is t_line_array(0 to 31)(31 downto 0);

    -- Type definition for a decoder record.
    type t_DecoderRecord is record
        rs1     : std_logic_vector(4 downto 0);                 -- Source 1 register address.
        rs2     : std_logic_vector(4 downto 0);                 -- Source 2 register address.
        dbus    : std_logic_vector(4 downto 0);                 -- Destination register address.
        opsel   : std_logic_vector(3 downto 0);                 -- Operation number for ALU.
        funct3  : std_logic_vector(2 downto 0);                 -- Forwarding funct3type.
        alu_src, pc_write, mem_read, dbus_en: std_logic;        -- Additional CPU flags.
        bad, env : std_logic;                                   -- Indicates bad instruction and environment call.
    end record;

    -- Type definition for comparator output record.
    type t_ComparatorRecord is record
        branch_match : std_logic;                               -- Branch operation success.
        eq, lt, ltu  : std_logic;                               -- Three additional forwarded signals. 
    end record;

    -- Constant for initializing the decoder record.
    constant c_DECODER_RECORD_INIT : t_DecoderRecord := (
        rs1 => (others => '0'),
        rs2 => (others => '0'),
        dbus   => (others => '0'),
        opsel  => (others => '0'),
        funct3 => (others => '0'),
        dbus_en => '1',
        alu_src => '0',
        pc_write => '0',
        mem_read => '0',
        bad => '0',
        env => '1'
    );

    -- Constant for initializing the decoder record.
    constant c_COMPARATOR_RECORD_INIT : t_ComparatorRecord := (
        branch_match => '0', eq => '0', lt => '0', ltu => '0'
    );

    -- Two zeroed line for SBUS wire instances.
    constant c_CLEAR_SBUS : t_sbus := (others => (others => '0'));

    -- Function to increment a given 'std_logic_vector' by four. The input signal is expected to be unsigned.
    function pc_incr(v: t_word) return t_word;
    -- Defines an unreachable case statement combination.
    procedure unreachable;

    -- Pipeline procedure declarations --
    procedure pipeline (
        signal i_clk  : in std_logic;                      -- Input clock.
        signal na_clr : in std_logic;                      -- Asynchronous clear (Active Low).
        signal i_word   : in t_word;                       -- Free-sized input vector.
        signal o_word   : out t_word                       -- Corresponding output vector.
    );

    -- Helper procedure to pipeline any type of data for one clock cycle with stalling ability.
    procedure pipeline_stall (
        signal i_clk    : in std_logic;                    -- Input clock.
        signal na_clr   : in std_logic;                    -- Asynchronous clear (Active Low).
        signal i_stall  : in std_logic;                    -- Synchronous clear. Will hold the clear and ignore any input.
        signal i_word   : in t_word;                       -- Free-sized input vector.
        signal o_word   : out t_word                       -- Corresponding output vector.
    );

    procedure pipeline (
        signal i_clk  : in std_logic;     
        signal na_clr : in std_logic;     
        signal i_word : in t_ComparatorRecord;
        signal o_word : out t_ComparatorRecord
    );

    procedure pipeline (
        signal i_clk  : in std_logic;
        signal na_clr : in std_logic;
        signal i_word : in t_DecoderRecord;
        signal o_word : out t_DecoderRecord
    );
end package;

package body primitives is
    -- Function to increment a given 'std_logic_vector' by four. The input signal is expected to be unsigned.
    function pc_incr(v: t_word) return t_word is
    begin
        return t_word(unsigned(v) + 4);
    end function;

    procedure unreachable is 
    begin
        report "Unreachable case statement reached" severity failure;
    end procedure;

    -- Helper procedure to initialize an instance of a buffer register to pipeline a word of data.
    procedure pipeline (
        signal i_clk  : in std_logic;                       -- Input clock.
        signal na_clr : in std_logic;                       -- Asynchronous clear (Active Low).
        signal i_word : in t_word;                          -- Free-sized input vector.
        signal o_word : out t_word                          -- Corresponding output vector.
    ) is
    begin
        if na_clr = '0' then
            o_word <= (others => '0');
        elsif rising_edge(i_clk) then
            o_word <= i_word;
        end if;
    end procedure;


    -- Helper procedure to pipeline any type of data for one clock cycle with stalling ability.
    procedure pipeline_stall (
        signal i_clk    : in std_logic;                         -- Input clock.
        signal na_clr   : in std_logic;                         -- Asynchronous clear (Active Low).
        signal i_stall  : in std_logic;                         -- Synchronous clear. Will hold the clear and ignore any input.
        signal i_word   : in t_word;                            -- Free-sized input vector.
        signal o_word   : out t_word                            -- Corresponding output vector.
    ) is
        constant c_NOP  : t_word := x"0000_0013";               -- Constant value of NOP operation instruction code.
    begin
        if na_clr = '0' then
            o_word <= c_NOP;
        elsif rising_edge(i_clk) then
            if i_stall = '1' then
                o_word <= c_NOP;
            else 
                o_word <= i_word;
            end if;
        end if;
    end procedure;

    -- Helper procedure to initialize an instance of a buffer register to pipeline a word of data.
    procedure pipeline (
        signal i_clk  : in std_logic;                           -- Input clock.
        signal na_clr : in std_logic;                           -- Asynchronous clear (Active Low).
        signal i_word : in t_ComparatorRecord;                  -- Free-sized input vector.
        signal o_word : out t_ComparatorRecord                  -- Corresponding output vector.
    ) is
    begin
        if na_clr = '0' then
            o_word <= c_COMPARATOR_RECORD_INIT;
        elsif rising_edge(i_clk) then
            o_word <= i_word;
        end if;
    end procedure;

    -- Helper procedure to initialize an instance of a buffer register to pipeline a word of data.
    procedure pipeline (
        signal i_clk  : in std_logic;                       -- Input clock.
        signal na_clr : in std_logic;                       -- Asynchronous clear (Active Low).
        signal i_word : in t_DecoderRecord;                 -- Free-sized input vector.
        signal o_word : out t_DecoderRecord                 -- Corresponding output vector.
    ) is
    begin
        if na_clr = '0' then
            o_word <= c_DECODER_RECORD_INIT;
        elsif rising_edge(i_clk) then
            o_word <= i_word;
        end if;
    end procedure;
end package body;
