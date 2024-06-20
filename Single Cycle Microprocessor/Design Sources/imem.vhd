library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use STD.TEXTIO.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use IEEE.STD_LOGIC_ARITH.all;

entity imem is
  port (a  : in  STD_LOGIC_VECTOR(5 downto 0);
        rd : out STD_LOGIC_VECTOR(31 downto 0));
end entity;

architecture behave of imem is
begin
  process is
    file mem_file : TEXT;
    variable L             : line;
    variable ch            : character;
    variable index, result : integer;
    type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    variable mem : ramtype;
  begin
    for i in 0 to 63 loop
      mem(conv_integer(i)) := CONV_STD_LOGIC_VECTOR(0, 32);
    end loop;
    index := 0;
    FILE_OPEN(mem_file, "C:\Users\natha\Desktop\Digital Design Portfolio\Microprocessor-Design\memfile.dat", READ_MODE);
    while not endfile(mem_file) loop
      readline(mem_file, L);
      result := 0;
      for i in 1 to 8 loop
        read(L, ch);
        if '0' <= ch and ch <= '9' then
          result := result * 16 + character'pos(ch) - character'pos('0');
        elsif 'a' <= ch and ch <= 'f' then
          result:= result * 16 + character'pos(ch) - character'pos('a') + 10;
        else

            report "Format error on line" & integer'image(index)
            severity error;
        end if;
      end loop;
      mem(index) := CONV_STD_LOGIC_VECTOR(result, 32);
      index := index + 1;
    end loop;

    loop
      rd <= mem(CONV_INTEGER(a));
      wait on a;
    end loop;
  end process;
end architecture;
