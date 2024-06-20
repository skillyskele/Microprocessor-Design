----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/11/2024 10:00:47 PM
-- Design Name: 
-- Module Name: controller - arch
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


entity controller is
  port (
    op, funct: in std_logic_vector(5 downto 0);
    zero: in std_logic;
    memtoreg, memwrite: out std_logic;
    pcsrc, alusrc: out std_logic;
    regdst, regwrite: out std_logic;
    jump: out std_logic;
    alucontrol: out std_logic_vector(2 downto 0)
  );
end controller;

architecture arch of controller is
    component main_decoder
        port(
            opcode:    in std_logic_vector(5 downto 0);
            memtoreg, memwrite: out std_logic;
            branch, alusrc: out std_logic;
            regdst, regwrite: out std_logic;
            jump: out std_logic;
            aluop: out std_logic_vector(1 downto 0)
       );
    end component;
    component alu_decoder
        port(
            funct: in std_logic_vector(5 downto 0);
            aluop: in std_logic_vector(1 downto 0);
            alucontrol: out std_logic_vector(2 downto 0)
        );
    end component;
    signal aluop: std_logic_vector(1 downto 0);  
    signal branch: std_logic;  

begin
    maindec: main_decoder port map(
        opcode=>op,
        memtoreg=>memtoreg,
        memwrite=>memwrite,
        branch=>branch,
        alusrc=>alusrc,
        regdst=>regdst,
        regwrite=>regwrite,
        jump=>jump,
        aluop=>aluop);
        
    aludec: alu_decoder port map(
        funct=>funct,
        aluop=>aluop,
        alucontrol=>alucontrol);
            
            
    pcsrc <= branch and zero;

end arch;
