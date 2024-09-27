-- ============================================================
-- File Name: tb_general_reg.vhd
-- Desc: Test bench for CPU general purpose register. Exhaustivly tests the component for
--      different possible states.
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
use friscv.general_reg;
use friscv.tb.all;

entity tb_general_reg is
    type t_dut is record
        i_clk       : t_clock;
        na_clr      : std_logic; 
        i_enable    : std_logic;
        i_data      : t_word;
        o_data      : t_word;
    end record;

    -- Writes all 2^32 combinations to the input port.
    procedure TestIO(signal data : out t_word) is
    begin
        report "Enter: TestIO";
        for val in t_word'LOW to t_word'HIGH loop
            -- Writes all bits possibilities into the data port.
            data <= t_word(to_unsigned(val, t_word'LENGTH));
            wait for 1 ns;
        end loop;
        report "Done: TestIO";
    end procedure;
end entity;

architecture behavioral of tb_general_reg is
    signal sigs : t_dut := (
        i_clk       => '0', 
        na_clr      => 'X', 
        i_enable    => 'X', 
        i_data      => (others => 'X'),
        o_data      => (others => 'X')
    );
    signal freq : real := 50.000e6;

    constant c_WZERO : t_word := (others => '0');
begin
    GENERAL_REG_Inst: entity general_reg
    port map(
        i_clk => sigs.i_clk,
        na_clr => sigs.na_clr,
        i_enable => sigs.i_enable,
        i_data => sigs.i_data,
        o_data => sigs.o_data
    );

    -- Clock tick.
    p_CLK : tick(sigs.i_clk, freq);  

    -- Performs all tests below, with different parameters. --
    p_MAIN : process is
        variable last_output : t_word;
    begin
        report "Enter: p_MAIN";

        wait on sigs.na_clr;
        last_output := sigs.o_data;
        
        -- Checks if the output is zeroed. --
        assert last_output /= c_WZERO 
            report "Output data should be zeroes after reset: " 
            & to_string(to_integer(unsigned(last_output))) 
            severity error;

        -- Write <- enable
        sigs.i_enable <= '1';
        -- Testing with different clock frequencies. --
        TestIO(sigs.i_data);
        freq <= 100.000e6;
        TestIO(sigs.i_data);
        freq <= 150.000e6;
        TestIO(sigs.i_data);
        freq <= 200.000e6;
        TestIO(sigs.i_data);
        wait for 2 ns;

        ---- Write <- disable
        sigs.i_enable <= '0';
        last_output := sigs.o_data; 
        TestIO(sigs.i_data);

        -- Checks if the output left unchanged. --
        assert sigs.o_data = last_output 
            report "Output data do not match, expected: " 
            & to_string(to_integer(unsigned(last_output)))
            & ". Got: "
            & to_string(to_integer(unsigned(sigs.o_data)))
            severity error;

        report "Done: p_MAIN";
        freq <= 0.0;
        wait;
    end process;

    -- Sets the reset (active low).
    p_RESET : process begin
        report "Enter: p_RESET";
        sigs.na_clr <= '1' after 5 ns; 
        report "Done: p_RESET";
        wait;
    end process;
end architecture;
