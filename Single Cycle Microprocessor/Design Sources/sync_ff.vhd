library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity sync_ff is
    generic (width: integer);
    port(
        clk, rst: in std_logic;
        d:  in std_logic_vector(width-1 downto 0);
        q: out std_logic_vector(width-1 downto 0)
    );
end sync_ff;

architecture arch of sync_ff is
begin
    process(clk, rst)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                q <= conv_std_logic_vector(0, width);
            else
                q <= d;
            end if;
        end if;
    end process;

end arch;