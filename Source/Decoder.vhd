library ieee;
use ieee.std_logic_1164.all;

entity decoder is
    port (input   :in  std_logic_vector (3 downto 0); 
          output :out std_logic_vector (15 downto 0));
end entity;

architecture behavior of decoder is

begin
    process (input) begin
        output <= X"0000";
            case (input) is
                when X"0"   => output <= X"0001";
                when X"1"   => output <= X"0002";
                when X"2"   => output <= X"0004";
                when X"3"   => output <= X"0008";
                when X"4"   => output <= X"0010";
                when X"5"   => output <= X"0020";
                when X"6"   => output <= X"0040";
                when X"7"   => output <= X"0080";
                when X"8"   => output <= X"0100";
                when X"9"   => output <= X"0200";
                when X"A"   => output <= X"0400";
                when X"B"   => output <= X"0800";
                when X"C"   => output <= X"1000";
                when X"D"   => output <= X"2000";
                when X"E"   => output <= X"4000";
                when X"F"   => output <= X"8000";
                when others => output <= X"0000";
            end case;
    end process;
end architecture;
