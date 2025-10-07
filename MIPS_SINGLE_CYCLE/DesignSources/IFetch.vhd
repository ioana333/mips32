----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2025 06:33:09 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
    Port ( Jump : in STD_LOGIC;
           JumpAdress : in STD_LOGIC_VECTOR (31 downto 0);
           PCSrc : in STD_LOGIC;
           BranchAdress : in STD_LOGIC_VECTOR (31 downto 0);
           EN : in STD_LOGIC;
           RST : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR (31 downto 0);
           finalPC : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC);
end IFetch;

architecture Behavioral of IFetch is

type memROM is array(0 to 31) of std_logic_vector(31 downto 0);
signal ROM: memROM:=(
                     -- 0
                     -- $1 <- MEM[&zero + SE(0)]    PC<-PC+4
                     -- lw $1, 0($zero)
                     b"100011_00000_00001_0000000000000000",     -- 8C01_0000
                     -- 1
                     -- $2 <- MEM[&zero + SE(4)]    PC<-PC+4
                     -- lw $2, 4($zero)
                     b"100011_00000_00010_0000000000000100",    -- 8C01_0004
                     -- 2
                     -- $3<-$zero+SE(8)     PC<-PC+4
                     -- addi $3, $zero, 8
                     b"001000_00000_00011_0000000000001000",    -- 2003_0008
                     
                     -- 3
                     -- MEM[$3 + SE(0)] <- $1
                     --sw $1, 0($3)
                     b"101011_00011_00001_0000000000000000",    -- AC61_0000
                     -- 4
                     -- $3<-$3+SE(4)    PC<-PC+4
                     -- addi $3, $3, 4
                     b"001000_00011_00011_0000000000000100",    -- 2063_0004
                     -- 5
                     -- MEM[$3 + SE(0)] <- $2
                     -- sw $2, 0($3)
                     b"101011_00011_00010_0000000000000000",    -- AC62_0000
                     -- 6
                     -- $3<-$3+SE(4)    PC<-PC+4
                     -- addi $3, $3, 4
                     b"001000_00011_00011_0000000000000100",    -- 2063_0004
                     
                 -- euclid
                     -- 7
                     -- if $2 = $2 then PC<-PC+4+SE(11) else PC<-PC+4
                     -- beq $1, $2, done
                     b"000100_00001_00010_0000000000001011",   -- 1022_000B
                     -- 8
                     -- $4 <- $1 - $2
                     -- sub $4, $1, $2
                     b"000000_00001_00010_00100_00000_100010",  -- 0022_2022
                     -- 9
                     -- $5 <- $4>>31
                     -- sra $5, $4, 31
                     b"000000_00000_00100_00101_11111_000011",  -- 0004_2FC3
                     -- 10
                     -- if $5 = $zero then PC<-PC+4+SE(4) else PC<-PC+4
                     -- beq $5, $zero, update_x
                     b"000100_00101_00000_0000000000000100",    -- 10A0_0004
                 -- update_y
                     -- 11
                     -- $2 <- $2 - $1
                     -- sub $2, $2, $1
                     b"000000_00010_00001_00010_00000_100010",  -- 0041_1022
                     -- 12
                     -- MEM[$3 + SE(0)] <- $2
                     -- sw $2, 0($3)
                     b"101011_00011_00010_0000000000000000",    -- AC62_0000
                     -- 13
                     -- $3<-$3+SE(4)    PC<-PC+4
                     -- addi $3, $3, 4
                     b"001000_00011_00011_0000000000000100",    -- 2063_0004
                     -- 14
                     -- PC <-(PC+4)[31:22]||(7<<2)
                     -- j euclid
                     b"000010_00000000000000000000000111",      -- 0800_0007
                 -- update_x
                     -- 15
                     -- $1 <- $1 - $2
                     -- sub $1, $1, $2
                     b"000000_00001_00010_00001_00000_100010",  -- 0022_0822
                     -- 16
                     -- MEM[$3 + SE(0)] <- $1
                     -- sw $1, 0($3)
                     b"101011_00011_00001_0000000000000000",    -- AC61_0000
                     -- 17
                     -- $3<-$3+SE(4)    PC<-PC+4
                     -- addi $3, $3, 4
                     b"001000_00011_00011_0000000000000100",    -- 2063_0004
                     -- 18
                     -- PC <-(PC+4)[31:22]||(7<<2)
                     -- j euclid
                     b"000010_00000000000000000000000111",      -- 0800_0007
                     
                     -- 19
                     -- MEM[$3 + SE(0)] <- $1
                     -- sw $1, 0($3)
                     b"101011_00011_00001_0000000000000000",    -- AC61_0000
                     -- 20
                     -- $3<-$3+SE(4)    PC<-PC+4
                     -- addi $3, $3, 4
                     b"001000_00011_00011_0000000000000100",    -- 2063_0004
                     
                   others=>X"00000000");

signal inter: std_logic_vector (31 downto 0);
signal Q: std_logic_vector (31 downto 0);
signal nextPC: std_logic_vector (31 downto 0);
signal D: std_logic_vector (31 downto 0);
signal reg: std_logic_vector (31 downto 0);

begin

--MUX1
inter <= BranchAdress when PCSrc = '1' else nextPC;

--MUX2
D <= JumpAdress when Jump = '1' else inter;

-- PC
process(clk)
    begin
        if RST = '1' then 
            reg<=(others=>'0');
        elsif rising_edge (clk) then
            if EN = '1' then 
                reg<=D;
            end if;
        end if;
end process;

Q <= reg;

nextPC <= std_logic_vector(unsigned(Q) + 4);
finalPC <= nextPC;

Instruction <= ROM(to_integer(unsigned(reg(6 downto 2))));

end Behavioral;
