library IEEE;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Controller_CPU is
	port(
		Op			: in std_logic_vector(5 DOWNTO 0);
		Instruct   		: in std_logic_vector(5 DOWNTO 0);
	    Clock			: in std_logic;
		Reset			: in std_logic;
		RegDst			: out std_logic;
		RegWrite		: out std_logic;
		ALUOp			: out std_logic_vector(3 DOWNTO 0);
		ALUSrcA		: out std_logic;
		ALUSrcB		: out std_logic_vector(1 DOWNTO 0);
		PCSource		: out std_logic_vector(1 DOWNTO 0);
		PCWCond	: out std_logic;
		PCWrite		: out std_logic;
		PCS 		: out std_logic;
		IorD			: out std_logic;
		MemRead		: out std_logic;
		MemWrite		: out std_logic;
		MemToReg		: out std_logic;
		IRWrite		: out std_logic;
		Zero  		: out std_logic;
		Load_I     		: out std_logic;
		LH      		: out std_logic;
		Neg 		: out std_logic;
		ORI 	: out std_logic;
	    Mult 		: out std_logic;
		NewMult 		: out std_logic;
		MultWrite 		: out std_logic;
		Done		: in std_logic;
		Higher 		: out std_logic;
		Lower 		: out std_logic
	);
end Controller_CPU;

architecture behavioral of Controller_CPU is

	type STATE_TYPE IS (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11);
	signal STATE : STATE_TYPE;
	SIGNAL R, I, B, J : std_logic := '0';

begin

	process(Clock, Reset)
	   begin

		if(Reset ='1') then
			STATE <= s0;
		elsif(RISING_EDGE(Clock)) then
			case STATE is
				when s0 =>
					R <= '0';
					I <= '0';
					B <= '0';
					J <= '0';
					STATE <= s1;
					
				when s1 =>
					--L/S--
					if(Op = "101011" or Op = "100011" or Op = "100001") then
						STATE <= s2;
					--R--
					elsif((Op = "000000" and not(Instruct = "001000")) or (Op = "011100")) then					
						R <= '1';
						STATE <= s6;
					--B--
					elsif(Op = "000001" or Op = "000101") then
						B <= '1';
						STATE <= s8;
					--J--
					elsif((Op = "000000" and Instruct = "001000") or (Op = "000010")) then
						J <= '1';
						STATE <= s9;
					--I--
					else
						I <= '1';
						STATE <= s6;
					end if;
				when s2 =>
			            if(Op = "101011") then --store Op
							state <= s5;
						else --all load type
							state <= s3;
						end if;
				when s3 =>
					STATE <= s4;
				when s4 =>
					STATE <= s0;
				when s5 =>
					STATE <= s0;
				when s6 =>
			            if(Op = "000000" and Instruct = "011001") then --go to multiply state
							state <= s10;
						else
							state <= s7; 
						end if;
				when s7 =>
					STATE <= s0;
				when s8 =>
					STATE <= s0;
				when s9 =>
					STATE <= s0;
				when s10 =>
				  if(Done = '1') then
				    STATE <= s11;
				  end if;
				when s11 =>
				   STATE <= s0;
				when others =>
				  STATE <= s0;
			end case;
		end if;
	end process;

	process(STATE)
	begin
		case STATE is
			when s0 =>			
			    ALUOp			<= "0001";
				ALUSrcA		<= '0';
			  	ALUSrcB 		<= "01";
			  	PCSource		<= "00";
			  	IRWrite		<= '1';
			  	PCWrite		<= '1';
				MemRead		<= '1';
				PCWCond	<= '0';											
				IorD			<= '0';
				RegWrite		<= '0';
				MemWrite		<= '0';
				PCS 		<= '0';
			  	LH 				<= '0';
				Higher 		<= '0';
			 	Lower 		<= '0';
			  	MultWrite 		<= '0';

			when s1 =>	
				
			    ALUOp 			<= "0001";
			  	ALUSrcA 		<= '0';
				ALUSrcB 		<= "11";
				MemRead		<= '1';
				MemWrite		<= '0';
				MemToReg		<= '0';	
				IorD			<= '0';
				IRWrite		<= '0';
				RegDst			<= '0';
				RegWrite		<= '0';
				PCS 		<= '0';
				PCSource		<= "00";
				PCWCond	<= '0';
				PCWrite		<= '0';
				
			  if(Op = "000000" and Instruct = "011001") then --mult
			    NewMult <= '1';
			  else
			    NewMult <= '0';
			  end if;

				if(Op = "001101") then--ORI
				    ORI <= '1';
				else
				    ORI <= '0';
				end if;
				
				if(Op = "000000" and Instruct = "010000") then --take multiplication values
					Higher <= '1';
				elsif(Op = "000000" and Instruct = "010010") then 
					Lower <= '0';
				end if;
	    

			
			when s2 =>
				ALUOp 			<= "0001";
				ALUSrcA		<= '1';
				ALUSrcB		<= "10";

				if(Op = "100001") then
				  LH <= '1';
				end if;

			when s3 =>
			    IorD			<= '1';
				MemRead		    <= '1';
				MemToReg		<= '1';
				MemWrite		<= '0';
				RegDst			<= '0';
				RegWrite		<= '0';

			when s4 =>
				RegDst			<= '1';
				RegWrite		<= '1';
				MemToReg		<= '1';
				IRWrite		<= '0';
				IorD			<= '0';
				MemRead		<= '0';

			when s5 =>
				IorD			<= '1';
				MemRead		<= '1';
				MemWrite		<= '1';
				MemToReg		<= '0';
				IRWrite		<= '0';
			
			when s6 =>
			ALUSrcA	<= '1';
			Load_I 	<= '0';			  
			  	if(Op = "000000" and Instruct = "011001") then
			    	NewMult 	<= '0';
					Mult 	<= '1'; --start mult here
				else
					Mult 	<= '0';
				end if;			  
				

				if(I = '1') then
						ALUSrcB <= "10";
							if(Op = "001000") then --ADDI
								ALUOp <= "0001";
							elsif(Op = "001010") then --SLTI
								ALUOp <= "0011";
							elsif(Op = "001101") then --ORI
								ALUOp <= "0110";
							elsif(Op <= "001111") then --LUI
								ALUOp <= "0110"; --rs || imm
								Load_I <= '1';
							end if;
					
				elsif(Op = "000000") then
					ALUOp 		<= "0000"; 	
					ALUSrcB	<= "00";
				elsif(Op = "011100") then --CLO
				  	ALUOp 		<= "1111";  
				  	ALUSrcB 	<= "00";
				end if;

			when s7 =>
			RegWrite	<= '1';
			MemToReg	<= '0';
				if(I = '1') then
					RegDst <= '1';
				else
					RegDst	<= '0';
				end if;

			when s8 =>
				ALUOp 		<= "1001";
				ALUSrcA	<= '1';
				ALUSrcB	<= "00";
			  	PCWCond 	<= '1';
				PCSource 		<= "01";
				
				if(Op = "000101") then
				  Zero <= '1';
				else
				  Zero <= '0';
				end if;
				
				if(Op = "000001") then
				  RegWrite <= '1';
				  PCS <= '1';
				  Neg <= '1';
				else
				  RegWrite <= '0';
				  PCS <= '0';
				  Neg <= '0';
				end if;
						  
			when s9 =>
				
				if(Op = "000010") then
				  	PCSource <= "10";
				  	PCWrite <= '1';
				elsif(Op = "000000" and Instruct = "001000") THEN
				  	PCSource <= "11";
				  	PCWrite <= '1';
				end if;
				
			when s10 =>
			  	Mult <= '0';
				NewMult <= '0';
			when s11 =>
			  	MultWrite <= '1';
			when others =>

		end case;
	end process;

end behavioral;