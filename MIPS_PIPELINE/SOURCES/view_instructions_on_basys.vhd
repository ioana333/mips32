----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2025 08:19:55 PM
-- Design Name: 
-- Module Name: view_instructions_on_basys - Behavioral
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

entity view_instructions_on_basys is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           sw : in STD_LOGIC);
end view_instructions_on_basys;

architecture Behavioral of view_instructions_on_basys is

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

signal afisare : STD_LOGIC_VECTOR(31 downto 0);

begin

    process(clk, sw)
        begin
            if sw = '1' then
                afisare <= x"0000" &  digits(15 downto 0);
            else
                afisare <= x"0000" &  digits(31 downto 16);
            end if;
    end process;
    
SSD_COMP: ssd port map (clk, afisare, an, cat);

end Behavioral;
