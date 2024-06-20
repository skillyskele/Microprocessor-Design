library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

entity dmem is
  port(clk, we: in std_logic;
             a, wd: in std_logic_vector(31 downto 0);
             rd: out std_logic_vector(31 downto 0));
end dmem;

architecture Behavioral of dmem is
begin
    process is
        type ramtype is array(63 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
        variable mem: ramtype;
        
        begin
            loop
                if rising_edge(clk) then
                    if (we='1') then
                        mem(conv_integer(a(7 downto 2))) := wd;
                    end if;
                end if;
                rd <= mem(conv_integer(a(7 downto 2)));
                wait on clk, a;
            end loop;
        end process;
end Behavioral;