library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sign_extend is -- sign extender for 16 bits to 31 bits
    port(
        a: in  std_logic_vector(15 downto 0);
        y: out std_logic_vector(31 downto 0)
    );
 end;

architecture arch of sign_extend is

begin
    y <= x"0000" & a when a(15) = '0' else x"ffff" & a;

end arch;
