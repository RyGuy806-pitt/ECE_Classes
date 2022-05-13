library IEEE;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ALU_Controller_CPU is
	PORT(
		ALUOp_Four	: in std_logic_vector(3 downto 0);	
		Instruct		: in std_logic_vector(5 downto 0);	
		ALUOp_Two	: out std_logic_vector(3 downto 0);
		Shift_One 	: out std_logic;
		Shift_Two 	: out std_logic;
		CLO     	: out std_logic
	);
end ALU_Controller_CPU;

architecture behavioral of ALU_Controller_CPU is
begin
	process(ALUOp_Four)
	   begin

	  	CLO <= '0';
	  	Shift_Two <= '0';
		Shift_One <= '0';

if(ALUOp_Four = "0000") then
			if(Instruct = "100001") then --ADDU
				ALUOp_Two <= "0101";
			elsif(Instruct = "100010") then --SUB
				ALUOp_Two <= "0110";
			elsif(Instruct = "100100") then --AND
				ALUOp_Two <= "0000";
			elsif(Instruct = "000000") then --SLL
			  ALUOp_Two <= "1100";
			  Shift_One <= '0';
			  Shift_Two <= '1';
			elsif(Instruct = "000010") then --J
			  ALUOp_Two <= "1110";
			  Shift_One <= '0';
			elsif(Instruct = "000011") then --SRA
			  ALUOp_Two <= "1111";
			  Shift_One <= '0';
			  Shift_Two <= '1';
			elsif(Instruct = "000100") then --SLLV
			  ALUOp_Two <= "1100";
			  Shift_One <= '1';
			  Shift_Two <= '1';
			end if;
		
		elsif(ALUOp_Four = "1111") then
		  if(Instruct = "100001") then --CLO
			CLO <= '1';
		  end if;
		
		else
			
			if(ALUOp_Four = "0001") then
				ALUOp_Two <= "0100";
			elsif(ALUOp_Four = "0010") then
				ALUOp_Two <= "0101";
			elsif(ALUOp_Four = "0011") then
				ALUOp_Two <= "1010";
			elsif(ALUOp_Four = "0100") then
				ALUOp_Two <= "1011";
			elsif(ALUOp_Four = "0101") then
				ALUOp_Two <= "0000";
			elsif(ALUOp_Four = "0110") then
				ALUOp_Two <= "0001";
			elsif(ALUOp_Four = "0111") then
				ALUOp_Two <= "0010";
			elsif(ALUOp_Four = "1000") then
				ALUOp_Two <= "0000"; 	
		    elsif(ALUOp_Four = "0101") then
			    ALUOp_Two <= "0110";
			end if;
		end if;

	end process;

end behavioral;