library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TRI2 is
    Port ( Data_on_Port: in std_logic;
           Data   : in  STD_LOGIC_VECTOR (15 downto 0);
           yi   : out  STD_LOGIC_VECTOR (15 downto 0));
end TRI2;

architecture Behavioral of TRI2 is
begin
     process(Data_on_Port,Data)
    begin
    if  Data_on_Port='1' then
      yi<=Data;
    else
      yi<=(others => 'Z');

    end if;
  end process;
end architecture;