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
        reset               : in  std_logic;
        switch_state        : in  std_logic                    := '1';
        number_input        : in  std_logic_vector(7 downto 0);
        op                  : out alu_ops;
        a, b                : out std_logic_vector(7 downto 0) := "00000000";
        state_led           : out std_logic_vector(3 downto 0) := "1000"
    );
end entity fsm;

architecture state_switcher of fsm is
    signal current_state    : fsm_states := ALU_SUB;
begin
    update: process(number_input, current_state)
    begin
        if    current_state = INPUT_A then
            a <= number_input;
        elsif current_state = INPUT_B then
            b <= number_input;
        end if;
    end process update;

    on_button: process(reset, switch_state)
    begin
        if reset = '1' then
            current_state     <= ALU_SUB;
        elsif switch_state = '0' then
            case current_state is
                when INPUT_A => current_state <= INPUT_B;
                when INPUT_B => current_state <= ALU_ADD;
                when ALU_ADD => current_state <= ALU_SUB;
                when others  => current_state <= INPUT_A;
            end case;
        else
            current_state <= current_state;
        end if;
    end process on_button;

    set_ALU_op: process(current_state)
    begin
        case current_state is
            when INPUT_A => op <= SHOW_A;
            when INPUT_B => op <= SHOW_B;
            when ALU_ADD => op <= SUM;
            when others  => op <= DIFF;
        end case;
    end process set_ALU_op;

    set_LED: process(reset, current_state)
    begin
        if reset = '1' then
            state_led <= "0000";
        else
            case current_state is
                when INPUT_A => state_led <= "1000";
                when INPUT_B => state_led <= "0100";
                when ALU_ADD => state_led <= "0010";
                when others  => state_led <= "0001";
            end case;
        end if;
    end process set_LED;
    
end architecture state_switcher;