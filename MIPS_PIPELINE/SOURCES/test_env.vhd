----------------------------------------------------------------------------------
-- Company: Technical University of Cluj-Napoca 
-- Engineer: Cristian Vancea
-- 
-- Module Name: test_env - Behavioral
-- Description: 
--      MIPS 32, single-cycle
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component IFetch
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR(31 downto 0);
           JumpAddress : in STD_LOGIC_VECTOR(31 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR(31 downto 0);
           PCp4 : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component ID is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;    
           Instr : in STD_LOGIC_VECTOR(25 downto 0);
           WD : in STD_LOGIC_VECTOR(31 downto 0);
           RegWrite : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           WA: in STD_LOGIC_VECTOR(4 downto 0);
           RD1 : out STD_LOGIC_VECTOR(31 downto 0);
           RD2 : out STD_LOGIC_VECTOR(31 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR(31 downto 0);
           func : out STD_LOGIC_VECTOR(5 downto 0);
           sa : out STD_LOGIC_VECTOR(4 downto 0);
           rt : out STD_LOGIC_VECTOR(4 downto 0);
           rd : out STD_LOGIC_VECTOR(4 downto 0)
           );
end component ;

component UC
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
end component;

component EX is
    Port ( PCp4 : in STD_LOGIC_VECTOR(31 downto 0);
           RD1 : in STD_LOGIC_VECTOR(31 downto 0);
           RD2 : in STD_LOGIC_VECTOR(31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR(31 downto 0);
           func : in STD_LOGIC_VECTOR(5 downto 0);
           sa : in STD_LOGIC_VECTOR(4 downto 0);
           rd : in STD_LOGIC_VECTOR(4 downto 0);
           rt : in STD_LOGIC_VECTOR(4 downto 0);
           ALUSrc : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR(31 downto 0);
           ALURes : out STD_LOGIC_VECTOR(31 downto 0);
           rWA : out STD_LOGIC_VECTOR(4 downto 0);
           Zero : out STD_LOGIC);
end component;

component MEM
    port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR(31 downto 0);
           RD2 : in STD_LOGIC_VECTOR(31 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component view_instructions_on_basys is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           sw : in STD_LOGIC);
end component;

signal Instruction, PCp4, RD1, RD2, WD, Ext_imm : STD_LOGIC_VECTOR(31 downto 0); 
signal JumpAddress, BranchAddress, ALURes, ALURes1, MemData : STD_LOGIC_VECTOR(31 downto 0);
signal func : STD_LOGIC_VECTOR(5 downto 0);
signal sa, rt, rd, rWA : STD_LOGIC_VECTOR(4 downto 0);
signal zero : STD_LOGIC;
signal digits : STD_LOGIC_VECTOR(31 downto 0);
signal en, PCSrc, rst: STD_LOGIC; 

-- main controls 
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(2 downto 0);

-- REG noi
signal REG_IF_ID: std_logic_vector (63 downto 0); 
signal REG_ID_EX: std_logic_vector (151 downto 0); 
signal REG_EX_MEM: std_logic_vector (103 downto 0); 
signal REG_MEM_WB: std_logic_vector (96 downto 0); 

begin

    --IF_ID
    process(clk)
    begin
        if rising_edge(clk) and en = '1' then
            REG_IF_ID(31 downto 0) <= PCp4;
            REG_IF_ID(63 downto 32) <= Instruction;
        end if;
    end process;
    
    --ID_EX
    process(clk)
    begin
        if rising_edge(clk) and en = '1' then
            REG_ID_EX(0) <= RegDst;
            REG_ID_EX(1) <= Branch;
            REG_ID_EX(2) <= RegWrite;
            REG_ID_EX(34 downto 3) <= RD1;
            REG_ID_EX(66 downto 35) <= RD2;
            REG_ID_EX(98 downto 67) <= Ext_Imm;
            REG_ID_EX(104 downto 99) <= func;
            REG_ID_EX(109 downto 105) <= sa;
            REG_ID_EX(114 downto 110) <= rt;
            REG_ID_EX(119 downto 115) <= rd;
            REG_ID_EX(151 downto 120) <= REG_IF_ID(31 downto 0);
        end if;
    end process;
    
    --EX_MEM
    process(clk)
    begin
        if rising_edge(clk) and en = '1' then
            REG_EX_MEM(0) <= REG_ID_EX(1);
            REG_EX_MEM(1) <= REG_ID_EX(1);
            REG_EX_MEM(2) <= Zero;
            REG_EX_MEM(34 downto 3) <= BranchAddress;
            REG_EX_MEM(66 downto 35) <= ALURes;
            REG_EX_MEM(71 downto 67) <= rWA;
            REG_EX_MEM(103 downto 72) <= REG_ID_EX(66 downto 35);
        end if;
    end process;
    
    --MEM_WB
    process(clk)
    begin
        if rising_edge(clk) and en = '1' then
            REG_MEM_WB(0) <= REG_EX_MEM(1);
            REG_MEM_WB(32 downto 1) <= ALURes1;
            REG_MEM_WB(64 downto 33) <= MemData;
            REG_MEM_WB(69 downto 65) <= REG_EX_MEM(71 downto 67);
        end if;
    end process;
    

    monopulse : MPG port map(en, btn(0), clk);
    
    -- main units
    inst_IFetch : IFetch port map(clk, btn(1), en, REG_EX_MEM(34 downto 3), JumpAddress, Jump, PCSrc, Instruction, PCp4);
   
    inst_ID : ID port map(clk, en, REG_IF_ID(57 downto 32), WD, REG_MEM_WB(0), ExtOp, REG_MEM_WB(69 downto 65), RD1, RD2, Ext_imm, func, sa, rt, rd);
    
    inst_UC : UC port map(REG_IF_ID(63 downto 58), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
    
    inst_EX : EX port map(REG_ID_EX(151 downto 120), REG_ID_EX(34 downto 3), REG_ID_EX(66 downto 35), REG_ID_EX(98 downto 67), REG_ID_EX(104 downto 99), REG_ID_EX(109 downto 105), REG_ID_EX(119 downto 115), REG_ID_EX(114 downto 110), ALUSrc, REG_ID_EX(0), ALUOp, BranchAddress, ALURes, rWA, Zero); 
    
    inst_MEM : MEM port map(clk, en, REG_EX_MEM(66 downto 35), REG_EX_MEM(103 downto 72), MemWrite, MemData, ALURes1);

    -- Write-Back unit 
    WD <= REG_MEM_WB(64 downto 33) when MemtoReg = '1' else REG_MEM_WB(32 downto 1); 

    -- branch control
    PCSrc <= REG_EX_MEM(2) and REG_EX_MEM(0);

    -- jump address
    JumpAddress <= REG_IF_ID(31 downto 28) & REG_IF_ID(57 downto 32) & "00";

   -- SSD display MUX
    with sw(7 downto 5) select
        digits <=  Instruction when "000", 
                   PCp4 when "001",
                   REG_ID_EX(34 downto 3) when "010",
                   REG_ID_EX(66 downto 35) when "011",
                   REG_ID_EX(98 downto 67) when "100",
                   ALURes when "101",
                   MemData when "110",
                   WD when "111",
                   (others => 'X') when others; 

    display : view_instructions_on_basys port map(clk, digits, an, cat, sw(15));
    
    -- main controls on the leds
    led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;
    
end Behavioral;