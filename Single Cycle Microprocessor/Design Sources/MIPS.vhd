----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/12/2024 01:41:03 PM
-- Design Name: 
-- Module Name: MIPS - struct
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
  use IEEE.STD_LOGIC_1164.all;

entity MIPS is
  port (
    clk, rst          : in  std_logic;
    readdata          : in  std_logic_vector(31 downto 0); -- this will go to datapath
    instr             : in  std_logic_vector(31 downto 0);
    memwrite          : out std_logic;
    pc                : out std_logic_vector(31 downto 0);
    aluout, writedata : out std_logic_vector(31 downto 0)
  );
end entity;

architecture arch of MIPS is
  component controller
    port (
      op, funct          : in  std_logic_vector(5 downto 0);
      zero               : in  std_logic;
      memtoreg, memwrite : out std_logic;
      pcsrc, alusrc      : out std_logic;
      regdst, regwrite   : out std_logic;
      jump               : out std_logic;
      alucontrol         : out std_logic_vector(2 downto 0)
    );
  end component;
  component datapath
    port (
      clk, rst          : in     std_logic;
      readdata          : in     std_logic_vector(31 downto 0);
      instr             : in     std_logic_vector(31 downto 0);

      -- result of ALU (final calculated address), result of rd2
      -- don't understand why we can't just declare these as signals though 
      aluout, writedata : buffer std_logic_vector(31 downto 0);

      -- control signals
      pcsrc             : in     std_logic;
      memtoreg          : in     std_logic;
      alusrc            : in     std_logic;
      regwrite          : in     std_logic;
      regdst            : in     std_logic;
      alucontrol        : in     std_logic_vector(2 downto 0);
      jump              : in     std_logic;

      -- output
      zero              : out    std_logic;

      -- program counter
      pc                : buffer std_logic_vector(31 downto 0)
    );
  end component;
  signal memtoreg, alusrc, regdst, regwrite, jump, pcsrc : std_logic;
  signal zero                                            : std_logic;
  signal alucontrol                                      : std_logic_vector(2 downto 0);

begin
  cont: controller
    port map (
      op         => instr(31 downto 26),
      funct      => instr(5 downto 0),
      zero       => zero,
      memtoreg   => memtoreg,
      memwrite   => memwrite,
      pcsrc      => pcsrc,
      alusrc     => alusrc,
      regdst     => regdst,
      regwrite   => regwrite,
      jump       => jump,
      alucontrol => alucontrol);

  dp: datapath
    port map (
      clk        => clk,
      rst        => rst,
      readdata   => readdata,
      instr      => instr,
      aluout     => aluout,
      writedata  => writedata,
      pcsrc      => pcsrc,
      memtoreg   => memtoreg,
      alusrc     => alusrc,
      regwrite   => regwrite,
      regdst     => regdst,
      alucontrol => alucontrol,
      jump       => jump,
      zero       => zero,
      pc         => pc);
end architecture;
