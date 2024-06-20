library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- for arithmetic operations on std_logic_vector


entity test_components is
--  Port ( );
end test_components;

architecture test of test_components is
--    signal    srca:  std_logic_vector(31 downto 0);
--    signal    srcb:  std_logic_vector(31 downto 0);
--    signal    alucontrol: std_logic_vector(2 downto 0);
--    signal    aluout: std_logic_vector(31 downto 0);
--    signal    bero:  std_logic;
--    -- signal    x: std_logic_vector(31 downto 0);
--    component alu 
--        port(
--            srca: in std_logic_vector(31 downto 0);
--            srcb: in std_logic_vector(31 downto 0);
--            alucontrol: in std_logic_vector(2 downto 0);
--            aluout: out std_logic_vector(31 downto 0);
--            -- x: out std_logic_vector(31 downto 0);
--            zero: out std_logic
--        );
--    end component;
    
    signal summand_a, summand_b, sum: std_logic_vector(31 downto 0);
    component adder
        port(
            a, b: in std_logic_vector(31 downto 0);
            y: out std_logic_vector(31 downto 0)
        );
    end component;
    
    signal signimm, signimm_sl2: std_logic_vector(31 downto 0);
    component sl2
        port(
            a: in std_logic_vector(31 downto 0);
            y: out std_logic_vector(31 downto 0)
        );
    end component;
    
    signal offset: std_logic_vector(15 downto 0);
    component sign_extend
        port(
            a: in  std_logic_vector(15 downto 0);
            y: out std_logic_vector(31 downto 0)
        );
    end component;
    
begin
--    alu_test: alu port map(srca=>srca, srcb=>srcb, alucontrol=>alucontrol, aluout=>aluout, zero=>bero);
--    srca <= std_logic_vector(to_unsigned(444, 32));
--    srcb <= std_logic_vector(to_unsigned(444, 32));
    
    offset <= std_logic_vector(to_signed(-1, 16));
    sign_extend_test: sign_extend port map(a=>offset, y=>signimm);
    
    sl2_test: sl2 port map(a=>signimm, y=>signimm_sl2);
    
--    adder_test: adder port map(a=>summand_a, b=>summand_b, y=>sum); -- constantly add something where it's been sign extended then shifted by 2, or add 4
--    summand_a <= std_logic_vector(to_unsigned(100, 32));
--    summand_b <= std_logic_vector(to_unsigned(4, 32));
    

-- ALU Control Process
--alucontrol_process: process
--begin
--    -- Increment alucontrol from "000" to "111"
--    alucontrol <= "000";
--    wait for 100 ns;
--    alucontrol <= "001";
--    wait for 100 ns;
--    alucontrol <= "110";
--    wait for 100 ns;
--    alucontrol <= "010";
--    wait for 100 ns;
--    alucontrol <= "111";
--    wait for 100 ns;
    
--    wait;
--end process alucontrol_process;



end test;
