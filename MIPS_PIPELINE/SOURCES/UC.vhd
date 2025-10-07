----------------------------------------------------------------------------------
-- Company: Technical University of Cluj-Napoca 
-- Engineer: Cristian Vancea
-- 
-- Module Name: UC - Behavioral
-- Description: 
--      Main Control Unit
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is
    Port ( Instr : in STD_LOGIC_VECTOR(5 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end UC;

architecture Behavioral of UC is
begin

    process(Instr)
    begin
        RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0'; 
        Branch <= '0'; Jump <= '0'; MemWrite <= '0';
        MemtoReg <= '0'; RegWrite <= '0';
        ALUOp <= "000";
        case (Instr) is 
            when "000000" => -- R type
                RegDst <= '1';
                RegWrite <= '1';
                ALUOp <= "010";
            when "001000" => -- ADDI
                ExtOp <= '1';
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "000";
            when "100011" => -- LW
                ExtOp <= '1';
                ALUSrc <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
                ALUOp <= "000";
            when "101011" => -- SW
                ExtOp <= '1';
                ALUSrc <= '1';
                MemWrite <= '1';
                ALUOp <= "000";
            when "000100" => -- BEQ
                ExtOp <= '1';
                Branch <= '1';
                ALUOp <= "001";
            when "001100" => -- ANDI
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "100";
            when "001101" => -- ORI
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "011";
            when "000010" => -- J
                Jump <= '1';
            when others => 
                RegDst <= 'X'; ExtOp <= 'X'; ALUSrc <= 'X'; 
                Branch <= 'X'; Jump <= 'X'; MemWrite <= 'X';
                MemtoReg <= 'X'; RegWrite <= 'X';
                ALUOp <= "XXX";
        end case;
    end process;		

end Behavioral;