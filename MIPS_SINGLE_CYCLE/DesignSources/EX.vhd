----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2025 07:17:38 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
    Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           nextPC : in STD_LOGIC_VECTOR (31 downto 0);
           Br_ne : out STD_LOGIC;
           Zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           BranchAdress : out STD_LOGIC_VECTOR (31 downto 0));
end EX;

architecture Behavioral of EX is

signal ALUCtrl: std_logic_vector (2 downto 0);
signal A, B, C: std_logic_vector (31 downto 0);

begin

--MUX
B <= RD2 when ALUSrc = '0' else Ext_Imm;
A <= RD1;

ALUControl: process(ALUOp, func)
begin
    case ALUOp is
        when "10" => 
            case func is
                when "100000" => ALUCtrl <= "000";
                when "100010" => ALUCtrl <= "100";
                when "000000" => ALUCtrl <= "011";
                when "000010" => ALUCtrl <= "101";
                when "100100" => ALUCtrl <= "001";
                when "100101" => ALUCtrl <= "010";
                when "000011" => ALUCtrl <= "110";
                when "100110" => ALUCtrl <= "111";
                when others => ALUCtrl <= (others => 'X');
            end case;
        when "00" => ALUCtrl <= "000";
        when "01" => ALUCtrl <= "100";
        when "11" => ALUCtrl <= "010";
        when others => ALUCtrl <= (others => 'X');
    end case;
end process;

ALU: process(A, B, ALUCtrl, sa)
begin
    case ALUCtrl is
        when "000" => C <= A + B;
        when "100" => C <= A - B;
        when "011" => C <= to_stdlogicvector(to_bitvector(B) sll conv_integer(sa));
        when "101" => C <= to_stdlogicvector(to_bitvector(B) srl conv_integer(sa));
        when "001" => C <= A and B;
        when "010" => C <= A or B;
        when "110" => C <= to_stdlogicvector(to_bitvector(B) sra conv_integer(sa));
        when "111" => C <= A xor B;
        when others => C <=(others=>'X');
    end case;
end process;

Zero <= '1' when C = x"00000000" else '0';
Br_ne <= '0' when C = x"00000000" else '1';

BranchAdress <= (Ext_Imm(28 downto 0) & "00") + nextPC;

ALURes <= C;

end Behavioral;
