library ieee;
use ieee.std_logic_1164.all;

entity mux16l is
port ( a,b : in  std_logic_vector(15 downto 0);
       s : in  std_logic;
       o : out std_logic_vector(15 downto 0));
end mux16l;
architecture m of mux16l is


begin

process(s,a,b)
begin
	case s is
	when '0'=>o<=a;
	when '1'=>o<=b;
	when others=> o<=a;
	end case ;
end process;



end m;
