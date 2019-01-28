library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX4 is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (3 downto 0);
           B   : in  STD_LOGIC_VECTOR (3 downto 0);
           X   : out STD_LOGIC_VECTOR (3 downto 0));
end MUX4;

architecture Behavioral of MUX4 is
begin
  process(A,B,SEL)
    begin
    if  SEL='1' then
      X<=A;
    elsif SEL='0' then 
      X<=B;
    else
      X<=A;
    end if;
  end process; 
end Behavioral;


