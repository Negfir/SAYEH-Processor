
library IEEE;
use IEEE.std_logic_1164.all;

entity IR is 
  port(d: in std_logic_vector (15 downto 0);
    load: in std_logic ;
    clk: in std_logic;
    q: out std_logic_vector (15 downto 0));
  end entity;
  
  architecture behavior of IR is 
   begin
     process(clk)
       begin
    if clk = '1' and clk'event then
    if load = '1' then
        q <= d;
      
    
      end if;
    end if;

  end process;
end behavior;





