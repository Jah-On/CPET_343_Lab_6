/* 

Author: John Schulz
Date:   06/26/2025

Top level design entity for lab 6.

*/
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity tlde is
    port (
        reset, clk, enter_btn : in  std_logic;
        switch                : in  std_logic_vector(7 downto 0);
        hex0, hex1, hex2      : out std_logic_vector(6 downto 0)
    );
end entity tlde;

architecture interaction of tlde is
    component fsm is
        port (
            reset, switch_state : in  std_logic;
            number_input        : in  std_logic_vector(7 downto 0);
            op                  : out alu_ops;
            a, b                : out std_logic_vector(7 downto 0)
        );
    end component fsm;

    component alu is
        port (
            a, b : in  std_logic_vector(7 downto 0);
            op   : in  alu_ops;
            res  : out std_logic_vector(8 downto 0)
        );
    end component alu;

    component ssd_d3 is
        generic (
            num_bits : integer := 9
        );
        port (
            reset                : in  std_logic;
            val                  : in  std_logic_vector((num_bits - 1) downto 0);
            ones, tens, hundreds : out std_logic_vector(6 downto 0)
        );
    end component ssd_d3;

    signal stable_enter_btn : std_logic;
    signal stable_switch    : std_logic_vector(7 downto 0);
    signal inter_op         : alu_ops;
    signal inter_a, inter_b : std_logic_vector(7 downto 0);
    signal inter_res        : std_logic_vector(8 downto 0);
begin
    clock_vals: process(clk)
    begin
        if rising_edge(clk) then
            stable_enter_btn <= enter_btn;
            stable_switch    <= switch;
        end if;
    end process clock_vals;

    de1 : fsm
        port map (
            reset        => reset,
            switch_state => stable_enter_btn,
            number_input => stable_switch,
            op           => inter_op,
            a            => inter_a,
            b            => inter_b
        );

    de2 : alu
        port map (
            op           => inter_op,
            a            => inter_a,
            b            => inter_b,
            res          => inter_res
        );

    de3 : ssd_d3
        generic map (
            num_bits     => 9
        )
        port map (
            reset        => reset,
            val          => inter_res,
            ones         => hex0,
            tens         => hex1,
            hundreds     => hex2
        );

end architecture interaction;