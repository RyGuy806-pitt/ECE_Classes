----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2021 06:21:08 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU_ISA is
  Port (A, B : in std_logic_vector(31 downto 0);
        SHAMT : in std_logic_vector(4 downto 0);
        ALUOP: in std_logic_vector(3 downto 0);
        R : out std_logic_vector(31 downto 0);
        OVERFLOW : out std_logic;
        ZERO : out std_logic );
end ALU_ISA;

architecture Behavioral of ALU_ISA is
signal CO :std_logic;
signal LogicR, ArithR, CompR, ShiftR :std_logic_vector(31 downto 0);
component Logical is
Port( A : in std_logic_vector(31 downto 0);
      B : in std_logic_vector(31 downto 0);
      Op : in std_logic_vector(1 downto 0);
      R : out std_logic_vector(31 downto 0));
end component;
component Shifter is
Port ( A: in std_logic_vector(31 downto 0);
         SHAMT: in std_logic_vector(4 downto 0);
         ALUOp: in std_logic_vector(1 downto 0);
         R: out std_logic_vector(31 downto 0))  ;
end component;
component Arithmetic is
GENERIC (
      n       : positive := 32);
   PORT( 
      A       : IN     std_logic_vector (n-1 DOWNTO 0);
      B       : IN     std_logic_vector (n-1 DOWNTO 0);
      C_op    : IN     std_logic_vector (1 DOWNTO 0);
      CO      : OUT    std_logic;
      OFL     : OUT    std_logic;
      S       : OUT    std_logic_vector (n-1 DOWNTO 0);
      Z       : OUT    std_logic
   );
end component;
component Comparison is
Port (A_31, B_31, CO, S_31: in std_logic;
        ALUOP: in std_logic_vector(1 downto 0);
        R: out std_logic_vector(31 downto 0)
        );
end component;
begin
LU: Logical port map(A=>A, B=>B, Op=>ALUOP(1 downto 0), R=>LogicR);
SU: Shifter port map(A=>A, SHAMT=>SHAMT, ALUOp=>ALUOP(1 downto 0), R=> ShiftR);
AU: Arithmetic port map(A=>A, B=>B, C_Op=>ALUOP(1 downto 0), CO => CO, OFL=>OVERFLOW, S=>ArithR, Z=>ZERO);
CU: Comparison port map(A_31=>A(31), B_31=>B(31), CO=>CO, S_31=>ArithR(31), ALUOp=>ALUOP(1 downto 0), R=>CompR);
with ALUOp(3 downto 2) select
R<=LogicR when "00",
   ArithR when "01",
    CompR when "10",
    ShiftR when "11",
    X"0F0F0F0F" when others;
end Behavioral;
