library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TRI8 is
    Port ( IR_on_LOpndBus : in  STD_LOGIC;
           IR_on_HOpndBus : in  STD_LOGIC;
           Low   : in  STD_LOGIC_VECTOR (15 downto 0);
           High   : in  STD_LOGIC_VECTOR (15 downto 0);
           X   : out STD_LOGIC_VECTOR (15 downto 0));
end TRI8;

architecture Behavioral of TRI8 is
begin
     process(IR_on_LOpndBus,IR_on_HOpndBus,Low,High)
    begin
    if  IR_on_LOpndBus='1' then
      X<=Low;
    elsif IR_on_HOpndBus='1' then
      X<=High;
    else
      X<=(others => 'Z');

    end if;
  end process; 
  

end Behavioral;



