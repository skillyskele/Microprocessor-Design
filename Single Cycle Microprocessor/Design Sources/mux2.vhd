library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux2 is
    generic(width: integer);
    port(
        d0, d1: in std_logic_vector(width-1 downto 0);
        s:  in std_logic;
        y:  out std_logic_vector(width-1 downto 0)
    );
end mux2;

architecture arch of mux2 is

begin
    y <= d0 when s='0' else d1;
end arch;
