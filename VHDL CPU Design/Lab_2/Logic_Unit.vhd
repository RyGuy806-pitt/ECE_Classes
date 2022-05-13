----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2021 12:00:26 PM
-- Design Name: 
-- Module Name: Logic_Unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Logic_Unit is
Port( A : in std_logic_vector(31 downto 0);
      B : in std_logic_vector(31 downto 0);
      Op : in std_logic_vector(1 downto 0);
      R : out std_logic_vector(31 downto 0));

end Logic_Unit;

architecture Behavioral of Logic_Unit is

begin


with Op Select
R <= (A and B) when "00",
     (A or B) when "01",
     (A xor B) when "10",
     (A nor B) when "11",
     (others=>'0') when others;
end Behavioral;
