library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX16 is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (15 downto 0);
           B   : in  STD_LOGIC_VECTOR (15 downto 0);
           X   : out STD_LOGIC_VECTOR (15 downto 0));
end MUX16;

architecture Behavioral of MUX16 is
begin
    process(A,B,SEL)
      begin
    if(SEL='1') then
      X<=A;
    else 
      X<=B;
    end if;
  end process; 
end Behavioral;


