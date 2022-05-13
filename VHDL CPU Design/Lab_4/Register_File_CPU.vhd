library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;


entity Register_File_CPU is
Generic(N:integer:=32);
Port (Read_One: in std_logic_vector(4 downto 0);
      Read_Two: in std_logic_vector(4 downto 0);
      Write_Reg: in std_logic_vector(4 downto 0);
      Write_data: in std_logic_vector(N-1 downto 0);
      Reg_Write: in std_logic;
      Clk: in std_logic;
      Rst: in std_logic;
      Out_One: out std_logic_vector(N-1 downto 0);
      Out_Two: out std_logic_vector(N-1 downto 0));
end Register_File_CPU;
    
architecture Behavioral of Register_File_CPU is

component Register_CPU is
Generic(N:integer:=32);
Port (D: in std_logic_vector(N-1 downto 0);
      Clk: in std_logic;
      En: in std_logic;
      Rst: in std_logic;
      Q: out std_logic_vector(N-1 downto 0);
      load: in std_logic
      );
end component;

component Five_Bit_Decoder is --Breaks down 5 bit inputs --> DID NOT WORK, USE CONV INT
Port ( Reg_Select: in std_logic_vector(4 downto 0);
       Reg_data: out std_logic_vector(31 downto 0)
       );
end component;
--signals

	type register_array is array (0 to 31) of std_logic_vector(31 DOWNTO 0);
	signal registers: register_array := (--All 32 registers intialized to 0, Us confuse system
		X"00000000",X"00000000",X"00000000",X"00000000",
		X"00000000",X"00000000",X"00000000",X"00000000",
		X"00000000",X"00000000",X"00000000",X"00000000",
		X"00000000",X"00000000",X"00000000",X"00000000",
		X"00000000",X"00000000",X"00000000",X"00000000",
		X"00000000",X"00000000",X"00000000",X"00000000",
		X"00000000",X"00000000",X"00000000",X"00000000",
		X"00000000",X"00000000",X"00000000",X"00000000" 
	);
	begin

		Out_One <= registers(conv_integer(unsigned(Read_One)));
		Out_Two <= registers(conv_integer(unsigned(Read_Two)));

		REGISTER_PROC: Process(Clk)
		begin

			if RISING_EDGE(Clk) AND Reg_Write = '1' THEN
				registers(conv_integer(unsigned(Write_Reg))) <= Write_data;
			end if;
		end process;
end behavioral;