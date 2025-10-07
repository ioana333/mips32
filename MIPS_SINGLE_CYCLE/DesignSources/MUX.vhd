library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux_param is
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
end entity;

architecture Behavioral of mux_param is
begin
    process(sel, din)
        variable index : integer range 0 to N-1;
        variable temp  : std_logic_vector(M-1 downto 0);
    begin
        index := to_integer(unsigned(sel));
        if index < N then
            temp := din((index+1)*M - 1 downto index*M);
        else
            temp := (others => '0');
        end if;

        -- Resize logic
        if M > P then
            dout <= temp(M-1 downto M-P);  -- truncare
        elsif M < P then
            dout <= (P-1 downto M => '0') & temp;  -- zero padding
        else
            dout <= temp;
        end if;
    end process;
end architecture;
