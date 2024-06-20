library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;
  use IEEE.NUMERIC_STD.ALL;

entity alu is
 port(
            srca: in std_logic_vector(31 downto 0);
            srcb: in std_logic_vector(31 downto 0);
            alucontrol: in std_logic_vector(2 downto 0);
            aluout: out std_logic_vector(31 downto 0);
            -- x: out std_logic_vector(31 downto 0);
            zero: out std_logic
        );
end entity;

architecture synth of alu is
  signal S, minus_srcb, aluout_buf : STD_LOGIC_VECTOR(31 downto 0);
  signal zero_buf: std_logic;
begin
  minus_srcb <= (not srcb) when (alucontrol(2) = '1') else srcb;
  S    <= srca + minus_srcb + alucontrol(2);
  zero <= zero_buf;
  -- x <= minus_srcb;
  process (alucontrol, srca, minus_srcb, S, aluout_buf, zero_buf)
  begin
    case alucontrol(1 downto 0) is
      when "00" => aluout_buf <= srca and minus_srcb;
      when "01" => aluout_buf <= srca or minus_srcb;
      when "10" => aluout_buf <= S;
      when "11" => aluout_buf <= ("0000000000000000000000000000000" & S(31)); -- if srca < srcb, set rd, or bits 15:11, equal to 1
      when others => aluout_buf <= X"00000000";
    end case;
    
 
    
     if aluout_buf = X"00000000" then
            zero_buf <= '1';
        else
            zero_buf <= '0';
        end if;    
    aluout <= aluout_buf;
  end process;

end architecture;
