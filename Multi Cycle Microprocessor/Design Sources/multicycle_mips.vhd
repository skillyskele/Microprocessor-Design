library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity multicycle_mips is
  Port (
  clk, rst : in std_logic;
  readdata : std_logic_vector(31 downto 0); --decomposes into funct, opcode, instr
  memwrite          : out std_logic;
  instr_data_adr, writedata : out std_logic_vector(31 downto 0)
  );
end multicycle_mips;

architecture Behavioral of multicycle_mips is
    component controller port (
      clk, rst: in std_logic;
      op, funct: in std_logic_vector(5 downto 0);
      -- Multiplexer Selects
      MemtoReg, RegDst, IorD, ALUSrcA: out std_logic;
      PCSrc, ALUSrcB: out std_logic_vector(1 downto 0);
      
      -- Register Enables
      IRwrite, MemWrite, PCwrite, Branch, RegWrite: out std_logic;
      ALUControl: out std_logic_vector(2 downto 0)
      );
    end component;
    component datapath port (
        clk, rst: in    std_logic; 
        instr_data: in std_logic_vector(31 downto 0);
        address: out std_logic_vector(31 downto 0);
        
        -- Incoming Control Signals
        IorD, IRwrite, RegWrite, ALUSrcA, PCwrite, RegDst, MemtoReg, PCEn: in std_logic;
        ALUSrcB, PCSrc: in std_logic_vector(1 downto 0);
        ALUControl: in std_logic_vector(2 downto 0)
        );
    end component;
    signal instr: std_logic_vector(31 downto 0); -- output of datapath -> instr -> controller 
    
    -- controller outputs -> datapath inputs
    signal MemtoReg, RegDst, IorD, ALUSrcA: std_logic;
    signal PCSrc, ALUSrcB: std_logic_vector(1 downto 0);
    signal IRwrite, PCwrite, Branch, RegWrite: std_logic;
    signal ALUControl: std_logic_vector(2 downto 0);
    signal PCEn: std_logic;
    signal zero: std_logic;
begin
    
   control: controller port map(
       clk => clk, 
       rst => rst, 
       op => instr(31 downto 26), 
       funct => instr(5 downto 0),
       MemtoReg => MemtoReg, 
       RegDst => RegDst, 
       IorD => IorD, 
       ALUSrcA => ALUSrcA, 
       PCSrc => PCSrc, 
       ALUSrcB => ALUSrcB, 
       IRwrite => IRwrite, 
       MemWrite => memwrite, 
       PCwrite => PCwrite, 
       Branch => Branch, 
       RegWrite => RegWrite, 
       ALUControl => ALUControl
   );
   
      dp: datapath port map(
        clk => clk, 
        rst => rst, 
        instr_data => readdata, 
        address => instr_data_adr, 
        IorD => IorD, 
        IRwrite => IRwrite, 
        RegWrite => RegWrite, 
        ALUSrcA => ALUSrcA, 
        PCwrite => PCwrite, 
        RegDst => RegDst, 
        MemtoReg => MemtoReg, 
        PCEn => PCEn,  -- Assuming PCEn is always enabled, adjust as needed
        ALUSrcB => ALUSrcB, 
        PCSrc => PCSrc, 
        ALUControl => ALUControl
    );
    
    PCEn <= (Branch and zero) or PCWrite;
end Behavioral;
