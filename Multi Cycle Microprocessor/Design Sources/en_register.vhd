library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity en_register is
    generic (width: integer);
    port(
        clk, rst, enable: in std_logic;
        d:  in std_logic_vector(width-1 downto 0);
        q: out std_logic_vector(width-1 downto 0)
    );
end en_register;

architecture arch of en_register is
    signal q_reg : STD_LOGIC_VECTOR(width-1 downto 0);
begin
    process(clk, rst, enable)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                q_reg <= conv_std_logic_vector(0, width);
            elsif enable = '1' then
                q_reg <= d;
            end if;
        end if;
    end process;
    
    q <= q_reg;
end arch;