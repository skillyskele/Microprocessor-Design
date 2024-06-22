library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.NUMERIC_STD.ALL;
  use IEEE.std_logic_unsigned.ALL;
  use STD.TEXTIO.all;

entity testbench is
end entity;

architecture test of testbench is
  component top
    port (clk, reset         : in  STD_LOGIC;
          writedata, dataadr : out STD_LOGIC_VECTOR(31 downto 0);
          instructions: out std_logic_vector(31 downto 0);
          memwrite           : out STD_LOGIC);
  end component;
  signal writedata, dataadr, instructions   : STD_LOGIC_VECTOR(31 downto 0);
  signal clk, reset, memwrite : STD_LOGIC;
  
  file output_file : text open write_mode is "C:\Users\natha\Desktop\Digital Design Portfolio\Microprocessor-Design\simulation_output.txt";

begin

  dut: top port map (clk, reset, writedata, dataadr, instructions, memwrite); -- we want to see clk, reset, writedata, dataadr, memwrite as we test

process (instructions)
    variable row : line;
    variable instr_bit : integer;
begin
    instr_bit := TO_INTEGER(unsigned(instructions));
    write(row, instr_bit);
    writeline(output_file, row);  -- Optionally write to a file
end process;

  process
  begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
  end process;

  process
  begin
    reset <= '1';
    wait for 22 ns;
    reset <= '0';
    wait;
  end process;

  process (clk)
  begin
    if (clk'event and clk = '0' and memwrite = '1') then
      if (conv_integer(dataadr) = 84 and conv_integer(writedata) = 7) then
        report "Simulation succeeded";
      elsif (dataadr /= 80) then
        report "Simulation failed";
      end if;
    end if;
  end process;
end architecture;
