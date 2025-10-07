----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2025 06:51:02 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
    Port ( RegWrite : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR(25 DOWNTO 0);
           RegDst : in STD_LOGIC;
           EN : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           RD2 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           WD : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           Ext_Imm : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           func : out STD_LOGIC_VECTOR(5 DOWNTO 0);
           sa : out STD_LOGIC_VECTOR(4 DOWNTO 0);
           clk : in STD_LOGIC);
end ID;

architecture Behavioral of ID is

component RegFile is
    Port ( ReadAdress1 : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           ReadAdress2 : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           WriteAdress : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           WriteData : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           RD1 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           RD2 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           EN : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

signal WriteAdress : STD_LOGIC_VECTOR(4 DOWNTO 0);

begin

RegFile_COMP: RegFile port map (Instr(25 downto 21),Instr(20 downto 16),WriteAdress, WD, RD1, RD2, EN, RegWrite, clk);

WriteAdress <= Instr(20 downto 16) when RegDst = '0' else Instr(15 downto 11);

--ExtUnit
Ext_Imm(15 downto 0) <= Instr(15 downto 0);
Ext_Imm(31 downto 16) <= (others => Instr(15)) when ExtOp = '1' else (others => '0');

sa <= Instr(10 downto 6);
func <= Instr(5 downto 0);

end Behavioral;
