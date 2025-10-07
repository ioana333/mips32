----------------------------------------------------------------------------------
-- Company: Technical University of Cluj-Napoca 
-- Engineer: Cristian Vancea
-- 
-- Module Name: IFetch - Behavioral
-- Description: 
--      Instruction Fecth Unit
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
    Port (clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          en : in STD_LOGIC;
          BranchAddress : in STD_LOGIC_VECTOR(31 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(31 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(31 downto 0);
          PCp4 : out STD_LOGIC_VECTOR(31 downto 0));
end IFetch;

architecture Behavioral of IFetch is

-- Memorie ROM
type tROM is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
signal ROM : tROM := (

--------------FIBONACCI------------------		
-- Acest program calculeaza sirului lui Fibonacci
-- incarcand initial 0 si 1 in 2 registre.
-- Se efectueaza scrierea in memorie la 2 adrese diferite
-- si apoi citirea de la aceleasi adrese pentru a verifica 
-- corectitudinea.
-- Calculul elementelor din sir se face intr-o bucla, folosind
-- instructiunea J.

    B"001000_00000_00001_0000000000000000",     -- X"20010000", 00: ADDI $1, $0, 0
    B"001000_00000_00010_0000000000000001",     -- X"20020001", 01: ADDI $2, $0, 1    
    B"001000_00000_00011_0000000000000000",     -- X"20030000", 02: ADDI $3, $0, 0    
    X"00000000",
    B"001000_00000_00100_0000000000000100",     -- X"20040004", 03: ADDI $4, $0, 4
    X"00000000",
    B"101011_00011_00001_0000000000000000",     -- X"AC610000", 04: SW $1, 0($3)
    X"00000000",
    B"101011_00100_00010_0000000000000000",     -- X"AC820000", 05: SW $2, 0($4)
    X"00000000",
    B"100011_00011_00001_0000000000000000",     -- X"8C610000", 06: LW $1, 0($3)
    X"00000000",
    B"100011_00100_00010_0000000000000000",     -- X"8C820000", 07: LW $2, 0($4)
    X"00000000",
    X"00000000",
    B"000000_00001_00010_00101_00000_100000",   -- X"00222820", 08: ADD $5, $1, $2
    X"00000000",
    B"000000_00000_00010_00001_00000_100000",   -- X"00020820", 09: ADD $1, $0, $2
    B"000000_00000_00101_00010_00000_100000",   -- X"00051020", 10: ADD $2, $0, $5
    B"000010_00000000000000000000001000",       -- X"08000008", 11: J 8
    X"00000000",
    
-----------------------------------------
    others => X"00000000");                     -- X"00000000", NOOP (SLL $0, $0, 0)
-----------------------------------------

signal PC : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal PCAux, NextAddr, AuxSgn : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- Program Counter
    process(clk, rst)
    begin
        if rst = '1' then
            PC <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                PC <= NextAddr;
            end if;
        end if;
    end process;

    -- Instruction OUT
    Instruction <= ROM(conv_integer(PC(6 downto 2)));

    -- PC + 4
    PCAux <= PC + 4;
    PCp4 <= PCAux;

    -- MUX for branch
    AuxSgn <= BranchAddress when PCSrc = '1' else PCAux;  
    
    -- MUX for jump
    NextAddr <= JumpAddress when Jump = '1' else AuxSgn;
    
end Behavioral;