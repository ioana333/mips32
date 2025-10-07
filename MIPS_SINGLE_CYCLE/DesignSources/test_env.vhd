----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2025 03:36:06 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( sw : in STD_LOGIC_VECTOR (4 downto 0);
           btn : in STD_LOGIC_VECTOR (1 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           led : out STD_LOGIC_VECTOR (10 downto 0));
end test_env;

architecture Behavioral of test_env is

signal digits, Instr, PC, RD1, RD2, Ext_Imm, WD, JumpAdress, BranchAdress, ALURes, ALUResOUT, MemData: std_logic_vector (31 downto 0);
signal func: std_logic_vector (5 downto 0);
signal sa: std_logic_vector (4 downto 0);
signal EN: std_logic;

signal Br_ne, RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite, Zero, Br_ne2, PCSrc :  STD_LOGIC;
           
signal ALUOp : STD_LOGIC_VECTOR (1 downto 0);

signal zeroExt1, zeroExt2: std_logic_vector (31 downto 0);
signal mux_in: std_logic_vector ((32*8 - 1) downto 0);

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component IFetch is
    Port ( Jump : in STD_LOGIC;
           JumpAdress : in STD_LOGIC_VECTOR (31 downto 0);
           PCSrc : in STD_LOGIC;
           BranchAdress : in STD_LOGIC_VECTOR (31 downto 0);
           EN : in STD_LOGIC;
           RST : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR (31 downto 0);
           finalPC : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC);
end component;

component UC is
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
end component;

component ID is
    Port ( RegWrite : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR(25 DOWNTO 0);
           RegDst : in STD_LOGIC;
           EN : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           RD2 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           WD : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           Ext_Imm : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           func : out STD_LOGIC_VECTOR(5 DOWNTO 0);
           sa : out STD_LOGIC_VECTOR(4 DOWNTO 0);
           clk : in STD_LOGIC);
end component;

component mux_param is
    generic (
        N : integer := 4;  -- num?rul de intr?ri
        M : integer := 8;  -- bi?i pe fiecare intrare
        P : integer := 8;  -- bi?i la ie?ire
        S : integer := 2   -- bi?i pentru select
    );
    port (
        sel     : in  std_logic_vector(S-1 downto 0);
        din     : in  std_logic_vector(N*M - 1 downto 0);
        dout    : out std_logic_vector(P-1 downto 0)
    );
end component;

component view_instructions_on_basys is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           sw : in STD_LOGIC);
end component;

component EX is
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
end component;

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALUResIN : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           EN : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUResOUT : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC);
end component;

begin

MPG_COMP: MPG port map(EN, btn(0), clk);

IFetch_COMP: IFetch port map(Jump, JumpAdress, PCSrc, BranchAdress, EN, btn(1), Instr, PC, clk);

ID_COMP: ID port map(RegWrite, Instr(25 downto 0), RegDst, EN, ExtOp, RD1, RD2, WD, Ext_Imm, func, sa, clk);

EX_COMP: EX port map(RD1, ALUSrc, RD2, Ext_Imm, sa, func, ALUOp, PC, Br_ne2, Zero, ALURes, BranchAdress);

MEM_COMP: MEM port map(MemWrite, ALURes, RD2, EN, MemData, ALUResOUT, clk);

UC_COMP: UC port map(Instr(31 downto 26), Br_ne, RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);

MUX: WD <= ALUResOUT when MemtoReg = '0' else MemData;

JumpAdress <= PC(31 downto 28) & Instr(25 downto 0) & "00";
PCSrc <= (Br_ne and Br_ne2) or (Branch and Zero);

mux_in <= WD & MemData & ALUResOUT & Ext_Imm & RD2 & RD1 & PC & Instr;

MUX_COMP: mux_param generic map(8, 32, 32, 3) port map(sw(2 downto 0), mux_in , digits);

SSD_COMP: view_instructions_on_basys port map(clk, digits, an, cat, sw(4));

led(10 downto 0) <= AluOp & RegDst & ExtOp & ALUSrc & Branch & Br_ne & Jump & MemWrite & MemtoReg & RegWrite;

end Behavioral;
