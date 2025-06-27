/* 

Author: John Schulz
Date:   06/26/2025

State machine entity for lab 6.

*/
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity fsm is
    port (
        reset, switch_state : in  std_logic;
        number_input        : in  std_logic_vector(7 downto 0);
        op                  : out alu_ops;
        a, b                : out std_logic_vector(7 downto 0) := "00000000";
        state_led           : out std_logic_vector(3 downto 0) := "1000"
    );
end entity fsm;

architecture state_switcher of fsm is
    signal state     : fsm_states                   := INPUT_A;
begin
    update: process(number_input, state)
    begin
        if    state = INPUT_A then
            a <= number_input;
        elsif state = INPUT_B then
            b <= number_input;
        end if;
    end process update;

    on_state_change: process(reset, switch_state)
    begin
        if (reset = '1') then
            op    <= SHOW_A;
            state <= INPUT_A;
        elsif (falling_edge(switch_state)) then
            case state is
                when INPUT_A => 
                    op        <= SHOW_B;
                    state     <= INPUT_B;
                    state_led <= "0100";
                when INPUT_B => 
                    op        <= SUM;
                    state     <= ALU_ADD;
                    state_led <= "0010";
                when ALU_ADD => 
                    op        <= DIFF;
                    state     <= ALU_SUB;
                    state_led <= "0001";
                when others  => 
                    op        <= SHOW_A;
                    state     <= INPUT_A;
                    state_led <= "1000";
            end case;
        end if;
    end process on_state_change;
    
end architecture state_switcher;