----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2025 11:50:12 AM
-- Design Name: 
-- Module Name: MEM - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALUResIN : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           EN : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUResOUT : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC);
end MEM;

architecture Behavioral of MEM is

type DataMemory is array(0 to 31) of std_logic_vector(31 downto 0);
signal MEM: DataMemory := (X"00000040", X"00000018" , others => (others => '0'));

begin

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' and MemWrite = '1' then
            MEM(to_integer(unsigned(ALUResIN(7 downto 2)))) <= RD2;
        end if;
    end if;
end process;

MemData <= MEM(to_integer(unsigned(ALUResIN(7 downto 2))));
ALUResOUT <= ALUResIN;

end Behavioral;
