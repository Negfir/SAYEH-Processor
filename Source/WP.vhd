library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity WP is 
  port(d: in std_logic_vector (5 downto 0);
    WPadd: in std_logic ;
    clk: in std_logic;
    WPreset: in std_logic;
    q: out std_logic_vector (5 downto 0));
  end entity;
  
  architecture behavior of WP is 
   signal qd: std_logic_vector (5 downto 0) ;
   begin
     process(clk)
       begin
    if clk = '1' and clk'event then
      if WPreset='1' then
        qd<="000000";
      elsif WPadd = '1' then
        qd <= d+qd;  
      end if;
    end if;
   q<=qd;
  end process;
end behavior;


