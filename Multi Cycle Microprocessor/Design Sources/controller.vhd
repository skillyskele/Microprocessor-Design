library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- THIS CONTROLLER DOES NOT HAVE LOGIC TO HANDLE ZERO AND OUTPUT PCEN
entity controller is
  Port (
  clk, rst: in std_logic;
  op, funct: in std_logic_vector(5 downto 0);
  -- Multiplexer Selects
  MemtoReg, RegDst, IorD, ALUSrcA: out std_logic;
  PCSrc, ALUSrcB: out std_logic_vector(1 downto 0);
  
  -- Register Enables
  IRwrite, MemWrite, PCwrite, Branch, RegWrite: out std_logic;
  ALUControl: out std_logic_vector(2 downto 0)
  );
end controller;

architecture Behavioral of controller is
    component alu_decoder port(
    aluop: in std_logic_vector(1 downto 0);
    funct: in std_logic_vector(5 downto 0);
    alucontrol: out std_logic_vector(2 downto 0)
  );
  end component;
  component main_decoder port(
      clk, rst: in std_logic;
      opcode: in std_logic_vector(5 downto 0);
      aluop: out std_logic_vector(1 downto 0);
      
      -- Multiplexer Selects
      MemtoReg, RegDst, IorD, ALUSrcA: out std_logic;
      PCSrc, ALUSrcB: out std_logic_vector(1 downto 0);
      
      -- Register Enables
      IRwrite, MemWrite, PCwrite, Branch, RegWrite: out std_logic
      
  );
  end component;
  signal aluop: std_logic_vector(1 downto 0);

begin

    alu_dec: alu_decoder port map(
        aluop=>aluop, funct=>funct, alucontrol=>ALUControl);
    main_dec: main_decoder port map(
        clk=>clk, rst=>rst, opcode=>op, aluop=>aluop, 
        MemtoReg=>MemtoReg, RegDst=>RegDst, IorD=>IorD, ALUSrcA=>ALUSrcA,
        PCSrc=>PCSrc, ALUSrcB=>ALUSrcB, IRwrite=>IRwrite, MemWrite=>MemWrite,
        PCwrite=>PCwrite, Branch=>Branch, RegWrite=>RegWrite
    );
end Behavioral;
