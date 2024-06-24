library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_decoder is
  Port (
      clk, rst: in std_logic;
      opcode: in std_logic_vector(5 downto 0);
      aluop: out std_logic_vector(1 downto 0);
      
      -- Multiplexer Selects
      MemtoReg, RegDst, IorD, ALUSrcA: out std_logic;
      PCSrc, ALUSrcB: out std_logic_vector(1 downto 0);
      
      -- Register Enables
      IRwrite, MemWrite, PCwrite, Branch, RegWrite: out std_logic
 );
end main_decoder;

architecture Behavioral of main_decoder is
    type FSM_type is (reset, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11);
    signal FSM: FSM_type;
begin
    process (clk, rst)
    begin
        -- you can register select signals, but not enables
        if rising_edge(clk) then
            case FSM is
                when reset =>
                    if rst='1' then
                        FSM <= s0;
                    else
                        FSM <= reset;
                    end if;
                when s0 =>
                    -- Enables
                    IRwrite <= '1';
                    PCwrite <= '1';
                    Branch <= '0';
                    MemWrite <= '0';
                    RegWrite <= '0';
                    
                    -- Selects
                    IorD <= '0';
                    ALUSrcA <= '0';
                    ALUSrcB <= b"01";
                    PCSrc <= b"00";
                    
                    aluop <= b"00";
                    FSM <= s1;
                when s1 =>
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '0';
                    Branch <= '0';
                    MemWrite <= '0';
                    RegWrite <= '0';
                    
                    -- Selects
                    ALUSrcA <= '0';
                    ALUSrcB <= b"11";
                    aluop <= b"00";
                    
                    case opcode is
                        when "000000" => -- R type
                            FSM <= s6;
                        when "100011" => -- lw
                            FSM <= s2;
                        when "101011" => -- sw
                            FSM <= s2;
                        when "000100" => -- beq
                            FSM <= s8;
                        when "001000" => -- addi
                            FSM <= s9;
                        when "000010" => -- j
                            FSM <= s11;
                        when others => 
                            null;
                    end case;
                when s2 => -- Calculate Memory Address
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '0';
                    Branch <= '0';
                    MemWrite <= '0';
                    RegWrite <= '0';
                    
                    -- Selects
                    ALUSrcA <= '0';
                    ALUSrcB <= b"10";
                    aluop <= b"00";
                    case opcode is
                        
                        when "100011" => -- lw
                            FSM <= s3;
                        when "101011" => -- sw
                            FSM <= s5;
                        when others => 
                            null;
                    end case;
                when s3 => -- Reading from data & writing into register: reading
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '0';
                    Branch <= '0';
                    MemWrite <= '0';
                    RegWrite <= '0';
                    
                    -- Selects
                    IorD <= '1';
                    
                    FSM <= s4;
                when s4 => -- Reading from data & writing into register: writing
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '0';
                    Branch <= '0';
                    MemWrite <= '0';
                    RegWrite <= '1';
                    
                    -- Selects
                    RegDst <= '0';
                    MemtoReg <= '1';
                    
                    FSM <= s0;
                when s5 => -- Write content in register into data memory
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '0';
                    Branch <= '0';
                    MemWrite <= '1';
                    RegWrite <= '0';
                    
                    -- Selects
                    IorD <= '1';
                    
                    FSM <= s0;
                when s6 => -- Execute R-type operation
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '0';
                    Branch <= '0';
                    MemWrite <= '0';
                    RegWrite <= '0';
                    
                    -- Selects
                    ALUSrcA <= '1';
                    ALUSrcB <= b"00";
                    
                    aluop <= b"10"; -- As soon as this happens, ALU_decoder outputs 010, and the ALU outputs ALUResult
                    
                    FSM <= s7;
               when s7 => -- Write result of R type instruction into destination register
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '0';
                    Branch <= '0';
                    MemWrite <= '0';
                    RegWrite <= '1';
                    
                    -- Selects
                    RegDst <= '1';
                    
                    FSM <= s0;
               when s8 => -- Branch
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '0';
                    Branch <= '1';
                    MemWrite <= '0';
                    RegWrite <= '0';
                    
                    -- Selects
                    ALUSrcA <= '1';
                    ALUSrcB <= b"00";
                    aluop <= b"01";
                    PCSrc <= b"01";
                    
                    FSM <= s0;
               when s9 => -- Add immediate
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '0';
                    Branch <= '0';
                    MemWrite <= '0';
                    RegWrite <= '0';
                    
                    -- Selects
                    ALUSrcA <= '1';
                    ALUSrcB <= b"10";
                    aluop <= b"00";
                    
                    FSM <= s10;
               when s10 =>
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '0';
                    Branch <= '0';
                    MemWrite <= '0';
                    RegWrite <= '1';
                    
                    -- Selects
                    RegDst <= '0';
                    MemtoReg <= '0';
                    
                    FSM <= s0;
              when s11 =>
                    -- Enables
                    IRwrite <= '0';
                    PCwrite <= '1';
                    Branch <= '0';
                    MemWrite <= '0';
                    RegWrite <= '0';
                    
                    -- Selects
                    PCSrc <= b"10";
                    
                    FSM <= s0;
             when others =>
                null;                    
                    
            end case;
        end if;
    end process;
end Behavioral;
