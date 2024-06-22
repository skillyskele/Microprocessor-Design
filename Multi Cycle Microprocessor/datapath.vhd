library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
  Port (clk, rst: in    std_logic; 
        instr_data: in std_logic_vector(31 downto 0);
        pc: out std_logic_vector(31 downto 0);
        
        -- Incoming Control Signals
        IorD, IRwrite, RegWrite, ALUSrcA, PCwrite, RegDst, MemWrite, MemtoReg: in std_logic;
        ALUSrcB: in std_logic_vector(1 downto 0);
        ALUControl: in std_logic_vector(2 downto 0)
        
        -- idk what to do with branch, PCEn, PCSrc
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
    component en_register generic(width: integer);
        port(
            clk, rst, enable: in std_logic;
            d:  in std_logic_vector(width-1 downto 0);
            q: out std_logic_vector(width-1 downto 0)
        );
    end component;
    component ab_register generic(width: integer);
        port(
            clk, rst: in std_logic;
            d0, d1: in std_logic_vector(width-1 downto 0);
            q0, q1: out std_logic_vector(width-1 downto 0)
        );
    end component;
    signal instr, data: std_logic_vector(31 downto 0);
    signal a3_input: std_logic_vector(4 downto 0);
    signal wd3_input: std_logic_vector(31 downto 0);
    signal ALUOut, ALUResult: std_logic_vector(31 downto 0);
    signal rd1_buf, rd2_buf, A_buf, B_buf: std_logic_vector(31 downto 0);
    
begin

    -- Instructions Logic
    IRWrite_reg: en_register generic map(32) port map (
        clk=>clk, rst=>rst, enable=>IRWrite, d=>instr_data, q=>instr);
    data_reg: sync_ff generic map(32) port map(
        clk=>clk, rst=>rst, d=>instr_data, q=>data);
        
    -- Register File
    rf: regfile port map(
            clk=>clk, we3=>regwrite, ra1=>instr(25 downto 21), ra2=>instr(20 downto 16),
            wa3=>a3_input, 
            wd3=>wd3_input,
            rd1=>rd1_buf,
            rd2=>rd2_buf);
            
    RegDst_mux: mux2 generic map(5) port map(
        d0=>instr(20 downto 16), d1=>instr(15 downto 11), s=>RegDst, y=>a3_input);
    MemtoReg_mux: mux2 generic map(32) port map(
        d0=>ALUOut, d1=>data, s=>MemtoReg, y=>wd3_input);
    AB_reg: ab_register generic map(32) port map(
        clk=>clk, rst=>rst, d0=>rd1_buf, d1=>rd2_buf, q0=>A_buf, q1=>B_buf);  
    


end arch;
