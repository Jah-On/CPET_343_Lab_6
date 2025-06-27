/* 

Author: John Schulz
Date:   06/26/2025

ALU entity for lab 6.

*/
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity alu is
    port (
        a, b : in  std_logic_vector(7 downto 0);
        op   : in  alu_ops;
        res  : out std_logic_vector(8 downto 0)
    );
end entity alu;

architecture mafs of alu is
begin
    update: process(a, b, op)
        variable int_a, int_b, int_res : integer;
    begin
        int_a   := to_integer(unsigned(a));
        int_b   := to_integer(unsigned(b));

        case op is
            when SHOW_B =>
                res <= '0' & b;
            when SUM    =>
                int_res := int_a + int_b;
                res     <= std_logic_vector(to_unsigned(int_res, res'length));
            when DIFF   =>
                int_res := int_a - int_b;
                res     <= std_logic_vector(to_signed(int_res, res'length));
            when others => -- SHOW_A state
                res <= '0' & a;
        end case;
    end process update;
end architecture mafs;