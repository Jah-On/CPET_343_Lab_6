/* 

Author: John Schulz
Date:   06/26/2025

Package that defines shared enum types for lab 6.

*/
package types is
    
    type alu_ops    is (SHOW_A, SHOW_B, SUM, DIFF);
    type fsm_states is (INPUT_A, INPUT_B, ALU_ADD, ALU_SUB);
    
end package types;