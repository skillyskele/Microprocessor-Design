library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
  Port (clk, reset:    in std_logic;
        writedata, dataadr: out std_logic_vector(31 downto 0);
        memwrite:   out std_logic);
end top;

architecture test of top is
    component MIPS
        port(clk, rst:     in std_logic;
             pc: out std_logic_vector(31 downto 0);
             instr: in std_logic_vector(31 downto 0);
             memwrite: out std_logic;
             aluout, writedata: out std_logic_vector(31 downto 0);
             readdata: in std_logic_vector(31 downto 0));
    end component;
    component imem
        port(a: in std_logic_vector(5 downto 0);
             rd: out std_logic_vector(31 downto 0));
    end component;
    component dmem
        port(clk, we: in std_logic;
             a, wd: in std_logic_vector(31 downto 0);
             rd: out std_logic_vector(31 downto 0));
    end component;
    signal pc, instr, readdata: std_logic_vector(31 downto 0);
    signal writedata_buf, dataadr_buf: std_logic_vector(31 downto 0);
    signal memwrite_buf: std_logic;
    begin
        mips1: MIPS port map(clk=>clk, rst=>reset, pc=>pc, instr=>instr, memwrite=>memwrite_buf, aluout=>dataadr, 
                             writedata=>writedata_buf, readdata=>readdata);
        imem1: imem port map(a=>pc(7 downto 2), rd=>instr);
        dmem1: dmem port map(clk=>clk, we=>memwrite_buf, a=>dataadr_buf, wd=>writedata_buf, rd=>readdata);
        
        memwrite <= memwrite_buf;
        dataadr <= dataadr_buf;
        writedata <= writedata_buf;
    

end test;
