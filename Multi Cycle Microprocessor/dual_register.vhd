library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity ab_register is
    generic (width: integer := 32);
    port(
        clk, rst: in std_logic;
        d0, d1: in std_logic_vector(width-1 downto 0);
        q0, q1: out std_logic_vector(width-1 downto 0)
    );
end ab_register;

architecture arch of ab_register is
    signal q0_reg, q1_reg : std_logic_vector(width-1 downto 0);
begin
    process(clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q0_reg <= (others => '0');
                q1_reg <= (others => '0');
            else
                q0_reg <= d0;
                q1_reg <= d1;
            end if;
        end if;
    end process;

    q0 <= q0_reg;
    q1 <= q1_reg;
end arch;
