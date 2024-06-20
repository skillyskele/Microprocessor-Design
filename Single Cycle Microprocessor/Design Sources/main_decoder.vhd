----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/11/2024 02:17:03 PM
-- Design Name: 
-- Module Name: main_decoder - arch
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main_decoder is
    port(
        opcode: in  std_logic_vector(5 downto 0);
        memtoreg, memwrite, branch, alusrc, regdst, regwrite: out std_logic;
        jump: out std_logic;
        aluop: out std_logic_vector(1 downto 0)
    );
end main_decoder;

architecture arch of main_decoder is
signal controls: std_logic_vector(6 downto 0);
signal aluop_control: std_logic_vector(1 downto 0);

begin

    -- when opcode is all 0s, output 1 to regwrite and regdst, and 0 to branch, memwrite, memtoreg, and 10 to aluop
process(opcode) begin
    
    case opcode is
        when "000000" => controls <= "1100000";
                         aluop_control <= "10";
        when "100011" => controls <= "1010010";
                         aluop_control <= "00";
        when "101011" => controls <= "0010100";
                         aluop_control <= "00";
        when "000100" => controls <= "0001000";
                         aluop_control <= "01"; 
        when "001000" => controls <= "1010000";
                         aluop_control <= "00";
        when "000010" => controls <= "0000001";
                         aluop_control <= "00";  
        when others => controls <= "-------";
                         aluop_control <= "--";
              
    end case;
end process;

regwrite <= controls(6);
regdst <= controls(5);
alusrc <= controls(4);
branch <= controls(3);
memwrite <= controls(2);
memtoreg <= controls(1);
jump <= controls(0);
aluop <= aluop_control;

end arch;
