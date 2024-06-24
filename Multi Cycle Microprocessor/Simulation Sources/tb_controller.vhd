library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_controller is
end tb_controller;

architecture Behavioral of tb_controller is

    -- Component declaration
    component controller is
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
    end component;
    
     -- Signals for the DUT (Device Under Test)
    signal clk: std_logic := '0';
    signal rst: std_logic := '0';
    signal op: std_logic_vector(5 downto 0);
    signal funct: std_logic_vector(5 downto 0);
    
    -- Output signals
    signal MemtoReg, RegDst, IorD, ALUSrcA: std_logic;
    signal PCSrc, ALUSrcB: std_logic_vector(1 downto 0);
    signal IRwrite, MemWrite, PCwrite, Branch, RegWrite: std_logic;
    signal ALUControl: std_logic_vector(2 downto 0);

    -- Clock period
    constant clk_period: time := 10 ns;

begin
    uut: controller
            Port map (
                clk => clk,
                rst => rst,
                op => op,
                funct => funct,
                MemtoReg => MemtoReg,
                RegDst => RegDst,
                IorD => IorD,
                ALUSrcA => ALUSrcA,
                PCSrc => PCSrc,
                ALUSrcB => ALUSrcB,
                IRwrite => IRwrite,
                MemWrite => MemWrite,
                PCwrite => PCwrite,
                Branch => Branch,
                RegWrite => RegWrite,
                ALUControl => ALUControl
            );
     clk_process :process
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;
        
     -- Stimulus process
    stim_proc: process
    begin
        -- Reset the controller
        rst <= '1';
        wait for clk_period; -- when you reset for too long, it will start cycling through states early on, before op and funct are provided
        rst <= '0'; -- if you go too far ahead, then op and funct won't be provided in time. only reset for 1 cycle.

        -- Test sequence
        op <= "000000"; -- R-type
        funct <= "100000"; -- ADD 
        wait for clk_period*5; -- add actually should take 5 cycles s0->s1->s6->s7->s0
        
        
        op <= "100011"; -- lw
        funct <= "------"; -- don't care
        wait for clk_period*5; -- lw takes 5 cycles s0->s1->s2->s3->s4->s0
        
        op <= "101011"; -- sw
        funct <= "------"; -- don't care
        wait for clk_period*4; -- sw takes 4 clock cycles s0->s1->s2->s5->s0
        
        op <= "000100"; -- beq
        funct <= "------"; -- don't care
        wait for clk_period*5; -- s0->s1->s8->s0
        
        op <= "001000"; -- addi
        funct <= "------"; -- don't care
        wait for clk_period*5;
        
        op <= "000010"; -- j
        funct <= "------"; -- don't care
        wait for clk_period*5;
        
        wait;
    end process;
        
     
end Behavioral;
