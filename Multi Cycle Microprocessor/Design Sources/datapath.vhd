library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
  Port (clk, rst: in    std_logic; 
        instr_data: in std_logic_vector(31 downto 0);
        address: out std_logic_vector(31 downto 0);
        
        -- Incoming Control Signals
        IorD, IRwrite, RegWrite, ALUSrcA, PCwrite, RegDst, MemtoReg, PCEn: in std_logic;
        ALUSrcB, PCSrc: in std_logic_vector(1 downto 0);
        ALUControl: in std_logic_vector(2 downto 0)
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
    component mux4 generic(width: integer);
    port(
        d0, d1, d2, d3: in std_logic_vector(width-1 downto 0);
        s:  in std_logic_vector(1 downto 0);
        y:  out std_logic_vector(width-1 downto 0)
    );
    end component;
    component mux3 generic(width: integer);
    port(
        d0, d1, d2: in std_logic_vector(width-1 downto 0);
        s:  in std_logic_vector(1 downto 0);
        y:  out std_logic_vector(width-1 downto 0)
    );
    end component;
    signal instr, data: std_logic_vector(31 downto 0);
    signal a3_input: std_logic_vector(4 downto 0);
    signal wd3_input: std_logic_vector(31 downto 0);
    signal ALUOut, ALUResult: std_logic_vector(31 downto 0);
    signal rd1_buf, rd2_buf, A_buf, B_buf: std_logic_vector(31 downto 0);
    signal signimm, signimm_sl2: std_logic_vector(31 downto 0);
    signal srcA, srcB: std_logic_vector(31 downto 0);
    signal zero: std_logic; --THIS MIGHT NEED TO BE OUTPUT FROM DATAPATH
    signal pc, pc_next, pc_jump: std_logic_vector(31 downto 0);
    signal jta_26: std_logic_vector(27 downto 0);
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
    
    
    -- Sign Extension Offset Logic
    sign_extender: sign_extend port map(
        a=>instr(15 downto 0),
        y=>signimm
    );
    sl_2: sl2 port map(
        a=>signimm,
        y=>signimm_sl2
    );
    
    -- ALU Logic
    ALUSrcA_mux: mux2 generic map(32) port map(
        d0=>pc, d1=>A_buf, s=>ALUSrcA, y=>srcA
    );
    ALUSrcB_mux: mux4 generic map(32) port map(
        d0=>A_buf, d1=>x"00000004", d2=>signimm, d3=>signimm_sl2,
        s=>ALUSrcB, y=>srcB);
    main_alu: alu port map(
        srca=>srcA, srcb=>srcB, alucontrol=>ALUControl, aluout=>ALUResult);
    alu_reg: sync_ff generic map(32) port map(
        clk=>clk, rst=>rst, d=>ALUResult, q=>ALUOut);
        
    -- PC Logic
    PCSrc_mux: mux3 generic map(32) port map(
        d0=>ALUResult, d1=>ALUOut, d2=>pc_jump, s=>PCSrc, y=>pc_next);
    PC_reg: en_register generic map(32) port map (
        clk=>clk, rst=>rst, enable=>PCEn, d=>pc_next, q=>pc);
    IorD_mux: mux2 generic map(32) port map(
        d0=>pc, d1=>ALUOut, s=>IorD, y=>address);
    pc_jump <= pc(31 downto 28) & instr(25 downto 0) & "00";
    
 end arch;
