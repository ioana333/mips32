----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2025 07:01:46 PM
-- Design Name: 
-- Module Name: RegFile - Behavioral
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegFile is
    Port ( ReadAdress1 : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           ReadAdress2 : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           WriteAdress : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           WriteData : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           RD1 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           RD2 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           EN : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           clk : in STD_LOGIC);
end RegFile;

architecture Behavioral of RegFile is

type mem_ROM is array (31 downto 0) of std_logic_vector (31 downto 0);
signal RF: mem_ROM := (others => (others => '0'));

begin

process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' and RegWrite = '1' then
                RF(to_integer(unsigned(WriteAdress)))<=WriteData;
            end if;
        end if;
end process;

RD1 <= RF(to_integer(unsigned(ReadAdress1)));
RD2 <= RF(to_integer(unsigned(ReadAdress2)));

end Behavioral;
