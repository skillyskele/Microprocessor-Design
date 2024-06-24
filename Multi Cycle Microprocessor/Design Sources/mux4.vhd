
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4 is
generic(width: integer);
    port(
        d0, d1, d2, d3: in std_logic_vector(width-1 downto 0);
        s:  in std_logic_vector(1 downto 0);
        y:  out std_logic_vector(width-1 downto 0)
    );
    end mux4;

architecture Behavioral of mux4 is

begin
process(s) 
    begin
    case s is
        when "00" => y <= d0;
        when "01" => y <= d1;
        when "10" => y <= d2;
        when "11" => y <= d3;
        when others=> y <= (others => '0');
    end case;
    end process;
end Behavioral;
