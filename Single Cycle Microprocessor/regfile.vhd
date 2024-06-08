library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- This memory has 32 registers. To access a register, use the 5 bit address signals ra1, ra2, or wa3
entity regfile is
    port(
		clk: in  std_logic;
		we3:  in  std_logic;
		ra1, ra2, wa3:  in std_logic_vector(4 downto 0);
		wd3: in  std_logic_vector(31 downto 0);
		rd1, rd2: out std_logic_vector(31 downto 0)
	);
end;

architecture arch of regfile is 
    type ramtype is array(31 downto 0) of std_logic_vector(31 downto 0);
    signal mem: ramtype;
begin
    process(clk) begin
        --- allow word wd3 to be written to memory at address wa3
        if rising_edge(clk) then
            if we3 = '1' then 
                mem(conv_integer(wa3)) <= wd3;
            end if;
        end if; 
    end process;
    process(ra1, ra2) begin
        if (ra1 = 0) then
            rd1 <= X"00000000";
        else 
            rd1 <= mem(conv_integer(ra1));
        end if;
        
        if (ra2 = 0) then
            rd2 <= X"00000000";
        else 
            rd2 <= mem(conv_integer(ra1));
        end if;
    end process;
end;
