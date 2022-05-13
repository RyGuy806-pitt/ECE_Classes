----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2021 11:03:41 PM
-- Design Name: 
-- Module Name: CPU_TB - Behavioral
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

entity CPU_TB is
end CPU_TB;

architecture Behavioral of CPU_TB is
    component CPU is
    Port (Clk: in std_logic;
        Rst: in std_logic;
        Instruction: in std_logic_vector(31 downto 0);
        PC_Reg: out std_logic_vector(31 downto 0);
        write_back_data: out std_logic_vector(31 downto 0);
        mem_write: out std_logic );
    end component;
    
    component Memory_CPU IS
    PORT( 
      Clk      : IN     std_logic;
      MemWrite : IN     std_logic;
      addr     : IN     std_logic_vector (31 DOWNTO 0);
      dataIn   : IN     std_logic_vector (31 DOWNTO 0);
      dataOut  : OUT    std_logic_vector (31 DOWNTO 0)
     );
    END component;
    
    signal Clock, Reset, MemWrite: std_logic;
    signal PC_Reg, Instruction, write_back_data: std_logic_vector(31 downto 0);
    
begin
    mem_0: Memory_CPU port map(Clk=>Clock, MemWrite=>MemWrite, addr => PC_Reg, DataIn=> write_back_data, DataOut=>Instruction);
    CPU_Unit: CPU port map(Clk=>Clock, Rst=>Reset, Instruction=>Instruction, PC_Reg=>PC_Reg, write_back_data=>write_back_data, mem_write=>MemWrite);

end Behavioral;
