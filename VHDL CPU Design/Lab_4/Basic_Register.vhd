library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Basic_Register is
	port(
		Clk : in std_logic;
		Rin : in std_logic_vector(31 downto 0);
		Rout : out std_logic_vector(31 downto 0)
	);
end Basic_Register;

--USE FOR: RegA, RegB, ALU_Out--

architecture behavioral of Basic_Register is
begin
	process(Clk, Rin)
		begin
			if(Clk'event and Clk = '1') then
				Rout <= Rin;
			end if;
	end process;
end behavioral;