----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2021 07:37:38 PM
-- Design Name: 
-- Module Name: CPU - Behavioral
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
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU is
  Port (Clk: in std_logic;
        Rst: in std_logic;
        Instruction: in std_logic_vector(31 downto 0);
        PC_Reg: out std_logic_vector(31 downto 0);
        write_back_data: out std_logic_vector(31 downto 0);
        mem_write: out std_logic );
end CPU;

architecture Behavioral of CPU is
--COMPONENTS--
    --Registers--
        component Basic_Register is
	       port(
		      Clk : in std_logic;
		      Rin : in std_logic_vector(31 downto 0);
		      Rout : out std_logic_vector(31 downto 0)
	           );
        end component;
        
        component Load_Register is
	       port(
		      Clk : in std_logic;
		      Load : in std_logic;
		      Rin : in std_logic_vector(31 downto 0);
		      Rout : out std_logic_vector(31 downto 0)
	       );
        end component;
        
        component Reset_Register is
	       port(
		      Clk : in std_logic;
		      Load : in std_logic;
		      Rst : in std_logic;
		      Rin : in std_logic_vector(31 downto 0);
		      Rout : out std_logic_vector(31 downto 0)
	       );
        end component;
    --Arith/Logic operators--
        component ALU_ISA is
            Port (    
                A, B : in std_logic_vector(31 downto 0);
                SHAMT : in std_logic_vector(4 downto 0);
                ALUOP: in std_logic_vector(3 downto 0);
                R : out std_logic_vector(31 downto 0);
                OVERFLOW : out std_logic;
                ZERO : out std_logic 
            );
        end component;
        
        component Multiplier_CPU is
	       generic (WIDTH : positive := 32);
	       port (
		      A     : in  std_logic_vector(WIDTH-1 downto 0);
		      B     : in  std_logic_vector(WIDTH-1 downto 0);
		      R     : out std_logic_vector(2*WIDTH-1 downto 0);
		      clk   : in  std_logic;
		      rst   : in  std_logic;
		      done  : out std_logic
	       );
        end component;
    --Controllers--
        component ALU_Controller_CPU is
	       port(
		      ALUOp_Four	: in std_logic_vector(3 downto 0);	
		      Instruct		: in std_logic_vector(5 downto 0);	
		      ALUOp_Two	: out std_logic_vector(3 downto 0);
		      Shift_One 	: out std_logic;
		      Shift_Two 	: out std_logic;
		      CLO     	: out std_logic
	       );
        end component;
        
        component Controller_CPU is
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
        end component;
    --MISC--
        component Memory_CPU IS
            PORT( 
                Clk      : IN     std_logic;
                MemWrite : IN     std_logic;
                addr     : IN     std_logic_vector (31 DOWNTO 0);
                dataIn   : IN     std_logic_vector (31 DOWNTO 0);
                dataOut  : OUT    std_logic_vector (31 DOWNTO 0)
            );
        end component;
        
        component Register_File_CPU is
            Generic(N:integer:=32);
            Port (Read_One: in std_logic_vector(4 downto 0);
                Read_Two: in std_logic_vector(4 downto 0);
                Write_Reg: in std_logic_vector(4 downto 0);
                Write_data: in std_logic_vector(N-1 downto 0);
                Reg_Write: in std_logic;
                Clk: in std_logic;
                Rst: in std_logic;
                Out_One: out std_logic_vector(N-1 downto 0);
                Out_Two: out std_logic_vector(N-1 downto 0)
            );
        end component;
--Single Bit Signals--        
signal Overflow, Z_Bit, Shift_One, Shift_Two, CLO, PCWL, PCWrite, PCWCond, Zero, RegDst, RegWrite, ALUSrcA, PCS, IorD, MemRead, MemWrite, MemToReg, IRWrite, Load_I, LH, Neg, ORI, Mult, NewMult, MultWrite, Done, Higher, Lower: std_logic;
--32 Bit Signals--
signal Leading_Ones, PC_Shift, Sign_Extend_Shift, Sign_Extend, CLO_In, Mem_In, Multiplier_Low_out, Multiplier_High_out, Mem_Reg_out, MUX_Reg_A, MUX_Reg_B, ALU_Out, ALU_Out_Reg_out, Reg_A_out, Reg_B_out, WriteData, Reg_A_in, Reg_B_in, PC_Reg_in, PC_Reg_out, Instruct: std_logic_vector(31 downto 0);
--4 Bit Signals--
signal ALUOp_Four, ALUOp_Two: std_logic_vector(3 downto 0);
--2 Bit Signals--
signal ALUSrcB, PCSource: std_logic_vector(1 downto 0);
--5 Bit Signals--
signal WriteReg, SHAMT: std_logic_vector(4 downto 0);
--64 Bit Signal--
signal Multiplier_out: std_logic_vector(63 downto 0);
begin
--Controllers First--
    Control_Unit: Controller_CPU port map(Op=>Instruct(31 downto 26), Instruct=>Instruct(5 downto 0), Clock=>Clk, Reset=>Rst, RegDst=>RegDst, RegWrite=>RegWrite, ALUOp=>ALUOp_Four, ALUSrcA=>ALUSrcA, ALUSrcB=>ALUSrcB, PCSource=>PCSource, PCWCond=>PCWCond, PCWrite=>PCWrite, PCS=>PCS, IorD=>IorD, MemRead=>MemRead, MemWrite=>MemWrite, MemToReg=>MemToReg, IRWrite=>IRWrite, Zero=>Zero, Load_I=>Load_I, LH=>LH, Neg=>Neg, ORI=>ORI, Mult=>Mult, NewMult=>NewMult, MultWrite=>MultWrite, Done=>Done, Higher=>Higher, Lower=>Lower);
    ALU_Control_Unit: ALU_Controller_CPU port map(ALUOp_Four=>ALUOp_Four, Instruct=>Instruct(5 downto 0), ALUOp_Two=>ALUOp_Two, Shift_One=>Shift_One, Shift_Two=>Shift_Two, CLO=>CLO);
--Other Blocks--
    PCWL <= PCWrite or (PCWCond and Zero);
    PC_Register: Reset_Register port map(Clk=>Clk, Load=>PCWL, Rst=>Rst, Rin =>PC_Reg_in, Rout=>PC_Reg_out);
    Instruction_Register: Load_Register port map(Clk=>Clk, Load=>IRWrite, Rin=>Instruction, Rout=>Instruct);
    Memory_Register: Load_Register port map(Clk=>Clk, Load=>MemRead, Rin=>Instruction, Rout=>Mem_Reg_out);
    Register_File: Register_File_CPU port map(Read_One=>Instruct(25 downto 21), Read_Two=>Instruct(20 downto 16), Reg_Write=>RegWrite, Write_Reg=>WriteReg, Write_data=>WriteData, Clk=>Clk, Rst=>Rst, Out_One=>Reg_A_in, Out_Two=>Reg_B_in);
    Register_A: Basic_Register port map(Clk=>Clk, Rin=>Reg_A_in, Rout=>Reg_A_out);
    Register_B: Basic_Register port map(Clk=>Clk, Rin=>Reg_B_in, Rout=>Reg_B_out);
    ALU_Unit: ALU_ISA port map(A=>MUX_Reg_A, B=>MUX_Reg_B, SHAMT=>SHAMT, ALUOp=>ALUOp_Two, R=>ALU_Out, OVERFLOW=>Overflow, Zero=>Z_Bit);
    ALU_Out_Register: Basic_Register port map(Clk=>Clk, Rin=>ALU_Out, Rout=>ALU_Out_Reg_out);
    Multiplier: Multiplier_CPU port map(A=>Reg_A_Out, B=>Reg_B_Out, R=>Multiplier_out, clk=>Clk, rst=>Rst, done=>Done);
    Multiplier_High: Reset_Register port map(Clk=>Clk, Load=>Higher, Rst=>NewMult, Rin=>Multiplier_out(63 downto 32), Rout=>Multiplier_High_out);
    Multiplier_Low: Reset_Register port map(Clk=>Clk, Load=>Lower, Rst=>NewMult, Rin=>Multiplier_out(31 downto 0), Rout=>Multiplier_Low_out);
--MUXes--
    --Write_Reg incorrect on BLTZAL command ->SOLUTION: PCS added
    WriteReg <= Instruct(20 downto 16) when RegDst = '1' and PCS = '0' else
                Instruct(15 downto 11) when RegDst = '0' and PCS = '0' else
                "11111";
    
    WriteData <= ALU_Out_Reg_out when (MemToReg = '0' and CLO = '0' and LH = '0' and Load_I = '0' and PCS = '0' and Higher = '0' and Lower = '0') else
                 Mem_Reg_out when (MemToReg = '1' and CLO = '0' and LH = '0' and Load_I = '0' and PCS = '0' and Higher = '0' and Lower = '0') else
                 ALU_Out_Reg_out(15 downto 0) & X"0000" when (Load_I = '1' and CLO = '0' and Higher = '0' and Lower = '0') else
                 Leading_Ones when (CLO = '1' and Higher = '0' and Lower = '0') else
                 PC_Reg_out when (PCS = '1' and Higher = '0' and Lower = '0') else
                 Multiplier_High_out when (Higher = '1' and Lower = '0') else
                 Multiplier_Low_out when (Higher = '0' and Lower = '1') else
                 X"0000" & Mem_Reg_out(31 downto 16) when LH = '1' and (conv_integer(unsigned(Mem_In)) mod 4 = 0) else
                 X"0000" & Mem_Reg_out(15 downto 0);
                 
    Mem_In <= ALU_Out_Reg_out when IorD = '1' else
              PC_Reg_out when IorD = '0';
              
    SHAMT <= Reg_B_out(4 downto 0) when Shift_One = '1' else
             Instruct(10 downto 6) when Shift_One = '0';
             
    MUX_Reg_A <= Reg_A_out when (ALUSrcA = '1' and Shift_Two = '0') else
              PC_Reg_out when (ALUSrcA = '0' and Shift_Two = '0') else
              Reg_B_out; --incorrect without B, shift Two must be accounted for
              
    MUX_Reg_B <= Reg_B_out when ALUSrcB = "00" else
                 "00000000000000000000000000000100" when ALUSrcB = "01" else
                 Sign_Extend when ALUSrcB = "10" else
                 Sign_Extend_Shift when ALUSrcB = "11";
                 
    PC_Reg_in <= ALU_out when PCSource = "00" else
                 ALU_Out_Reg_out when PCSource = "01" else
                 PC_Shift when PCSource = "10" else
                 Reg_A_out; --Also Needed for BLTZAL [refer to above]
                            
                 

--Sign Extend and Shifter--    
    Sign_Extend(15 downto 0) <= Instruct(15 downto 0);
    
    Sign_Extend(31 downto 16) <= "1111111111111111" when Instruct(15) = '1' and ORI = '0' else
                                 "0000000000000000" when Instruct(15) = '0' or ORI = '1';
                                 
    Sign_Extend_Shift <= Sign_Extend(29 downto 0) & "00";
    
    PC_Shift(1 downto 0) <= "00";
    PC_Shift(27 downto 2) <= Instruct(25 downto 0);
    PC_Shift(31 downto 28) <= PC_Reg_out(31 downto 28);
    
    PC_Reg <= Mem_In;
    write_back_data <= Reg_B_out;
    mem_write <= MemWrite;          

--CLO Command--
    process(Clk)
        variable count: integer := 0;
        begin
            count := 0;
            for i in 31 downto 0 loop
                if(MUX_Reg_A(i) = '1') then
                    count := count + 1;
                else
                    exit;
                end if;
            end loop;
            Leading_Ones <= conv_std_logic_vector(count, 32);
    end process;
              
end Behavioral;
