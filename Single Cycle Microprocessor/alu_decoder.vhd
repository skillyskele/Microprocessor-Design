----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/11/2024 02:17:03 PM
-- Design Name: 
-- Module Name: alu_decoder - arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity alu_decoder is
  port(
    aluop: in std_logic_vector(1 downto 0);
    funct: in std_logic_vector(5 downto 0);
    alucontrol: out std_logic_vector(2 downto 0)
  );
end alu_decoder;

architecture arch of alu_decoder is
    
begin
    process(aluop, funct) begin
        case aluop is 
            when "00" => alucontrol <="010";
            when "01" => alucontrol <="110";
            when others => case funct(3 downto 0) is 
                when "0000" => alucontrol <= "010";
                when "0010" => alucontrol <= "110";
                when "0100" => alucontrol <= "000";
                when "0101" => alucontrol <= "001";
                when "1010" => alucontrol <= "111";
                when others => alucontrol <= "---"; -- perhaps I could say 'null'?
            end case;
        end case;
    end process;
end arch;
