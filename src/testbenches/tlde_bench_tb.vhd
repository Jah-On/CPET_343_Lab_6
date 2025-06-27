/* 

Author: John Schulz
Date:   06/26/2025

Test bench for level design entity for lab 6.

*/
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tlde_bench is
end entity tlde_bench;

architecture benchy of tlde_bench is
    component tlde is
        port (
            reset, clk, enter_btn : in  std_logic;
            switch                : in  std_logic_vector(7 downto 0);
            state_led             : out std_logic_vector(3 downto 0);
            hex0, hex1, hex2      : out std_logic_vector(6 downto 0)
        );
    end component tlde;

    type switch_arr_t  is array (0     to 3) of std_logic_vector(7 downto 0);
    type ssd_arr_t     is array (2 downto 0) of std_logic_vector(6 downto 0);
    type ssd_res_arr_t is array (0     to 3) of ssd_arr_t;

    constant A_INPUTS : switch_arr_t := (
        "00000101", "00000010", "11001000", "01100100"
    );
    constant B_INPUTS : switch_arr_t := (
        "00000010", "00000101", "01100100", "11001000"
    );
    constant A_DSP    : ssd_res_arr_t := (
        ("1000000", "1000000", "0010010"),
        ("1000000", "1000000", "0100100"),
        ("0100100", "1000000", "1000000"),
        ("1111001", "1000000", "1000000")
    );
    constant B_DSP    : ssd_res_arr_t := (
        ("1000000", "1000000", "0100100"),
        ("1000000", "1000000", "0010010"),
        ("1111001", "1000000", "1000000"),
        ("0100100", "1000000", "1000000")
    );
    constant SUM_DSP  : ssd_res_arr_t := (
        ("1000000", "1000000", "1111000"),
        ("1000000", "1000000", "1111000"),
        ("0110000", "1000000", "1000000"),
        ("0110000", "1000000", "1000000")
    );
    constant DIFF_DSP : ssd_res_arr_t := (
        ("1000000", "1000000", "0110000"),
        ("0010010", "1000000", "0011000"),
        ("1111001", "1000000", "1000000"),
        ("0011001", "1111001", "0100100")
    );

    constant TICK : time := 20ns;

    signal enter_btn : std_logic                    := '1';
    signal switch_in : std_logic_vector(7 downto 0) := "00000000";
    signal state_out : std_logic_vector(3 downto 0);
    signal hex_out   : ssd_arr_t;

    signal done      : std_logic                    := '0';
    signal clock     : std_logic                    := '0';
    signal reset     : std_logic                    := '0';
begin
    proc_name: process
    begin
        report "*** Simulation Starting ***";
        while (done = '0') loop
            clock <= not clock;
            wait for TICK;
        end loop;
        report "*** Simulation Finished ***";

        wait;
    end process proc_name;

    stimulate: process
    begin
        reset <= '1';

        for delay in 0 to 11 loop
            wait until rising_edge(clock);
        end loop;

        reset <= '0';

        for case_num in 0 to 3 loop
            switch_in <= A_INPUTS(case_num);

            for delay in 0 to 3 loop
                wait until rising_edge(clock);
            end loop;

            for ssd in 2 downto 0 loop
                assert hex_out(ssd) = A_DSP(case_num)(ssd) 
                    report "'A' diplay different than expected!" severity error;
            end loop;

            wait until rising_edge(clock);
            enter_btn <= '0';
            wait until rising_edge(clock);
            enter_btn <= '1';

            switch_in <= B_INPUTS(case_num);

            for delay in 0 to 3 loop
                wait until rising_edge(clock);
            end loop;

            for ssd in 2 downto 0 loop
                assert hex_out(ssd) = B_DSP(case_num)(ssd) 
                    report "'B' diplay different than expected!" severity error;
            end loop;

            wait until rising_edge(clock);
            enter_btn <= '0';
            wait until rising_edge(clock);
            enter_btn <= '1';

            for delay in 0 to 3 loop
                wait until rising_edge(clock);
            end loop;

            for ssd in 2 downto 0 loop
                assert hex_out(ssd) = SUM_DSP(case_num)(ssd) 
                    report "'SUM' diplay different than expected!" severity error;
            end loop;

            wait until rising_edge(clock);
            enter_btn <= '0';
            wait until rising_edge(clock);
            enter_btn <= '1';

            for delay in 0 to 3 loop
                wait until rising_edge(clock);
            end loop;

            for ssd in 2 downto 0 loop
                assert hex_out(ssd) = DIFF_DSP(case_num)(ssd) 
                    report "'DIFF' diplay different than expected!" severity error;
            end loop;

            wait until rising_edge(clock);
            enter_btn <= '0';
            wait until rising_edge(clock);
            enter_btn <= '1';

        end loop;

        done <= '1';

        wait;
    end process stimulate;

    uut : tlde
        port map (
            reset        => reset,
            clk          => clock,
            enter_btn    => enter_btn,
            switch       => switch_in,
            state_led    => state_out,
            hex0         => hex_out(0),
            hex1         => hex_out(1),
            hex2         => hex_out(2)
        );

end architecture benchy;