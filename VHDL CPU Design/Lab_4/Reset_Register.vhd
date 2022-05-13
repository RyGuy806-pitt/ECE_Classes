library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Reset_Register is
	port(
		Clk : in std_logic;
		Load : in std_logic;
		Rst : in std_logic;
		Rin : in std_logic_vector(31 downto 0);
		Rout : out std_logic_vector(31 downto 0)
	);
end Reset_Register;

--USE FOR: PC_Reg, High, Low--

architecture behavioral of Reset_Register is
begin
	process(Clk, Rst)
		begin
			if(Rst = '1') then
				Rout <= X"00000000";
			elsif(Clk'event and Clk = '1' and Load = '1') then
				Rout <= Rin;
			end if;
	end process;
end behavioral;