----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Nathan Kim
-- 
-- Create Date: 06/10/2024 09:33:37 PM
-- Design Name: Single-Cycle Microprocessor Datapath
-- Module Name: datapath - arch
-- Project Name: Signle-Cycle Microprocessor
-- Target Devices: FPGA Spartan-7
-- Tool Versions: Vivado 2023.1
-- Description: This VHDL module implements the datapath for a single-cycle
--              microprocessor. The datapath includes components such as
--              the register file, ALU, and control logic to execute instructions
--              in a single clock cycle.
-- 
-- Dependencies: regfile.vhd, adder.vhd, async_ff.vhd, mux2.vhd, sign_extend.vhd, sl2.vhd, sync_ff.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: This project is inspired by Digital Design and Computer Architecture by David and Sarah Harris
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

entity datapath is
    port(
        clk, rst: in   std_logic;
        readdata: in    std_logic_vector(31 downto 0);
        instr: in   std_logic_vector(31 downto 0);
        
        -- result of ALU (final calculated address), result of rd2
        -- don't understand why we can't just declare these as signals though 
        aluout: out std_logic_vector(31 downto 0);
        
        writedata:  out std_logic_vector(31 downto 0);
        
        -- control signals
        pcsrc: in   std_logic;
        memtoreg: in    std_logic;
        alusrc: in  std_logic;
        regwrite: in    std_logic;
        regdst: in  std_logic;
        alucontrol: in  std_logic_vector(2 downto 0);
        jump: in    std_logic;
        
        -- output
        zero: out std_logic;
        
        -- program counter
        pc: out  std_logic_vector(31 downto 0)
   );
        
end datapath;

architecture arch of datapath is
    component alu
        port(
            srca, srcb:  in  std_logic_vector(31 downto 0);
            alucontrol: in  std_logic_vector(2 downto 0);
            aluout: out std_logic_vector(31 downto 0);
            zero:    out std_logic
        );
    end component;
    component regfile
        port(
		clk: in  std_logic;
		we3: in  std_logic;
		ra1, ra2, wa3: in std_logic_vector(4 downto 0);
		wd3: in  std_logic_vector(31 downto 0);
		rd1, rd2: out std_logic_vector(31 downto 0)
	);
	end component;
    component adder
        port(
        a, b: in std_logic_vector(31 downto 0);
        y: out std_logic_vector(31 downto 0)
    );
    end component;
    component sl2
    port(
        a: in std_logic_vector(31 downto 0);
        y: out std_logic_vector(31 downto 0)
    );
    end component;
    component sign_extend
        port(
            a: in  std_logic_vector(15 downto 0);
            y: out std_logic_vector(31 downto 0)
        );
    end component;
    component sync_ff generic(width: integer);
    port(
        clk, rst: in std_logic;
        d:  in std_logic_vector(width-1 downto 0);
        q: out std_logic_vector(width-1 downto 0)
    );
    end component;
    component mux2 generic(width: integer);
        port(
        d0, d1: in std_logic_vector(width-1 downto 0);
        s:  in std_logic;
        y:  out std_logic_vector(width-1 downto 0)
    );
    end component;
    signal writedata_buf, aluout_buf, pc_buf: std_logic_vector(31 downto 0);
    signal writereg: std_logic_vector(4 downto 0);
    signal signimm, signimm_x4: std_logic_vector(31 downto 0);
    signal srca, srcb, result: std_logic_vector(31 downto 0); -- for R type instructions
    signal pc_jump, pc_next, pc_nextbr, pc_plus4, pc_branch: std_logic_vector(31 downto 0);
    

begin
    writedata <= writedata_buf;
    aluout <= aluout_buf;
    pc <= pc_buf;

-- Register file logic
rf: regfile port map(
    clk=>clk, 
    we3=>regwrite, 
    ra1=>instr(25 downto 21), 
    ra2=>instr(20 downto 16),
    wa3=>writereg, 
    wd3=>result,
    rd1=>srca,
    rd2=>writedata_buf); -- writedata will be rd2, while srcb is either rd2 or signimm

wa3_mux: mux2 generic map(5) port map(
    d0=>instr(20 downto 16), -- rt
    d1=>instr(15 downto 11), -- rd
    s=>regdst,
    y=>writereg);

-- this multiplexer helps distinguish R and I instructions, 
-- since R instructions should read aluout directly to the register file, 
-- but I instructions should send readdata
result_mux: mux2 generic map(32) port map(
    d0=>aluout_buf,
    d1=>readdata,
    s=>memtoreg,
    y=>result);
    
sign_extender: sign_extend port map(
    a=>instr(15 downto 0),
    y=>signimm);
   
-- ALU logic
   
srcb_mux: mux2 generic map(32) port map(
    d0=>writedata_buf, -- rt
    d1=>signimm, -- rd
    s=>alusrc,
    y=>srcb);
    
mainalu: alu port map(
    srca=>srca,
    srcb=>srcb,
    alucontrol=>alucontrol,
    aluout=>aluout_buf,
    zero=>zero
);
   
-- next PC logic
pc_jump <= pc_plus4(31 downto 28) & instr(25 downto 0) & "00"; -- shift left by 2

pcreg: sync_ff generic map(32) port map(
    clk=>clk,
    rst=>rst,
    d=>pc_next,
    q=>pc_buf
);

pc_add4: adder port map(
    a=>pc_buf,
    b=>x"00000004", -- hexadecimal for 4
    y=>pc_plus4);
    
signimm_sl2: sl2 port map( -- expect that a[31:30] is unconnected, since they aren't used and are simply shifted out.
    a=>signimm,
    y=>signimm_x4);

pc_branch_addr: adder port map(
    a=>pc_plus4,
    b=>signimm_x4,
    y=>pc_branch);
     
pc_branch_mux: mux2 generic map(32) port map(
    d0=>pc_plus4,
    d1=>pc_branch,
    s=>pcsrc,
    y=>pc_nextbr); --NOT pc_next

pc_mux: mux2 generic map(32) port map(
    d0=>pc_nextbr,
    d1=>pc_jump,
    s=>jump,
    y=>pc_next);  

end arch;
