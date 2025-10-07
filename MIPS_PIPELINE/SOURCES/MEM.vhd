----------------------------------------------------------------------------------
-- Company: Technical University of Cluj-Napoca 
-- Engineer: Cristian Vancea
-- 
-- Module Name: MEM - Behavioral
-- Description: 
--      Memory Unit
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
    port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR(31 downto 0);
           RD2 : in STD_LOGIC_VECTOR(31 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR(31 downto 0));
end MEM;

architecture Behavioral of MEM is

type mem_type is array (0 to 63) of STD_LOGIC_VECTOR(31 downto 0);
signal MEM : mem_type := (
    X"0000000A",
    X"0000000B",
    X"0000000C",
    X"0000000D",
    X"0000000E",
    X"0000000F",
    X"00000009",
    X"00000008",
    others => X"00000000");

begin

    -- Data Memory
    process(clk) 			
    begin
        if rising_edge(clk) then
            if en = '1' and MemWrite = '1' then
                MEM(conv_integer(ALUResIn(7 downto 2))) <= RD2;			
            end if;
        end if;
    end process;

    -- outputs
    MemData <= MEM(conv_integer(ALUResIn(7 downto 2)));
    ALUResOut <= ALUResIn;

end Behavioral;