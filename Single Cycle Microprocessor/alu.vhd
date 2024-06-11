----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/11/2024 11:39:33 AM
-- Design Name: 
-- Module Name: alu - arch
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

entity alu is
    port(
        srca: in std_logic_vector(31 downto 0);
        srcb: in std_logic_vector(31 downto 0);
        alucontrol: in std_logic_vector(2 downto 0);
        aluout: out std_logic_vector(31 downto 0);
        zero: out std_logic
    );
end alu;

architecture arch of alu is
    -- when alu control says to add, add. when it say to multiply, then multiply. sum shiiii.

begin


end arch;
