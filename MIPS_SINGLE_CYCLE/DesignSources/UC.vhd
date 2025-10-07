----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2025 12:43:58 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
    Port ( Instr : in STD_LOGIC_VECTOR (5 downto 0);
           Br_ne : out STD_LOGIC;
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end UC;

architecture Behavioral of UC is

begin

process(Instr)
    begin
        Br_ne<='0';
        
        RegDst<='0';
        ExtOp<='0';
        ALUSrc<='0';
        Branch<='0';
        Jump<='0';
        MemWrite<='0';
        MemtoReg<='0';
        RegWrite<='0';
        ALUOp<="00";
        
        case Instr is 
            when "000000" =>    -- operatii de tip R, vezi curs
                RegDst <= '1';
                RegWrite <= '1';
                ALUOp <= "10";    -- din tabel
                
            when "001000" =>    -- ADDI
                ExtOp <= '1';
                ALUSrc <= '1';
                RegWrite <= '1';
                
                ALUOp <= "00";
                
            when "100011" =>    -- LW
                ExtOp <= '1';
                ALUSrc <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
                
                ALUOp <= "00";
                
            when "101011" =>    -- SW
                ExtOp <= '1';
                ALUSrc <= '1';
                MemWrite <= '1';
                
                ALUOp <= "00";
                
            when "000100" =>    -- BEQ
                ExtOp <= '1';
                Branch <= '1';
                
                ALUOp <= "01";
                
            when "001101" =>    -- ORI
                ALUSrc <= '1';
                RegWrite <= '1';
                
                ALUOp <= "11";
                
            when "000101" =>    -- BNE
                ExtOp <= '1';
                Br_ne <= '1';
                
                ALUOp <= "01";
                
            when "000010" =>    -- J
                Jump <= '1';
                
            when others =>
                RegDst <= '1';
                RegWrite <= '1';
                ALUOp <= "10";
                
        end case;
end process;

end Behavioral;
