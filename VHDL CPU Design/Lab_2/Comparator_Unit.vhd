library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Comparator_Unit is
  Port (A_31, B_31, CO, S_31: in std_logic;
        ALUOp: in std_logic_vector(1 downto 0);
        R: out std_logic_vector(31 downto 0)
        );
        end Comparator_Unit;

architecture Behavioral of Comparator_Unit is
signal temp : std_logic_vector(5 downto 0);
begin 
temp <= (ALUOp & A_31 & B_31 & S_31 & CO); 
R <= X"00000001" when std_match(temp, "10001-") else
     X"00000001" when std_match(temp, "10111-") else
     X"00000001" when std_match(temp, "1010--") else
     X"00000001" when std_match(temp, "11---0") else
     X"00000000";
end Behavioral;
