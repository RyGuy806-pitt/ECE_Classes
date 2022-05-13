library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Shifter is
  Port ( A: in std_logic_vector(31 downto 0);
         SHAMT: in std_logic_vector(4 downto 0);
         ALUOp: in std_logic_vector(1 downto 0);
         R: out std_logic_vector(31 downto 0))  ;
end Shifter;
    

architecture Behavioral of Shifter is
signal L_0, L_1, L_2, L_3, L_4 : std_logic_vector(31 downto 0);
signal R_0, R_1, R_2, R_3, R_4 : std_logic_vector(31 downto 0);
signal Fill :std_logic_vector(31 downto 0);
begin
Fill <= (others => ALUOp(0) and A(31));
with SHAMT(0) select
    L_0 <= A when '0',
           A(30 downto 0) & '0' when '1',
           X"0F0F0F0F" when others;
with SHAMT(1) select
    L_1 <= L_0 when '0',
           L_0(29 downto 0) & "00" when '1',
           X"0F0F0F0F" when others;
with SHAMT(2) select
    L_2 <= L_1 when '0',
           L_1(27 downto 0) & "0000" when '1',
           X"0F0F0F0F" when others;
with SHAMT(3) select
    L_3 <= L_2 when '0',
           L_2(23 downto 0) & "00000000" when '1',
           X"0F0F0F0F" when others;
with SHAMT(4) select
    L_4 <= L_3 when '0',
           L_3(15 downto 0) & "0000000000000000" when '1',
           X"0F0F0F0F" when others;
with SHAMT(0) select
    R_0 <= A when '0',
           Fill(0) & A(31 downto 1) when '1',
           X"0F0F0F0F" when others;
with SHAMT(1) select
    R_1 <= R_0 when '0',
           Fill(1 downto 0) & R_0(31 downto 2) when '1',
           X"0F0F0F0F" when others;
with SHAMT(2) select
    R_2 <= R_1 when '0',
           Fill(3 downto 0) & R_1(31 downto 4) when '1',
           X"0F0F0F0F" when others;
with SHAMT(3) select
    R_3 <= R_2 when '0',
           Fill(7 downto 0) & R_2(31 downto 8) when '1',
           X"0F0F0F0F" when others;
with SHAMT(4) select
    R_4 <= R_3 when '0',
           Fill(15 downto 0) & R_3(31 downto 16) when '1',
           X"0F0F0F0F" when others;
           
   with ALUOp(1) select
    R <= L_4 when '0',
        R_4 when '1',
        X"0F0F0F0F" when others;
        
end Behavioral;
