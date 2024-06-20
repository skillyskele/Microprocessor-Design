library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
  -- Use this package for arithmetic operations

entity demo is
    port(
        x: in std_logic_vector(2 downto 0);
        y: in std_logic_vector(2 downto 0);
        z: out std_logic_vector(2 downto 0);
        Bout: out std_logic_vector(2 downto 0)
    );
end demo;

architecture arch of demo is
    signal S, b: std_logic_vector(2 downto 0);
begin
    b <= (not x);
    Bout <= b;
    S <= b + y + b"1";
    process(S)
    begin
        z <= S; 
    end process;
end arch;
