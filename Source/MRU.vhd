LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MRU is
    port(clk:in STD_LOGIC;
         write,read,data_sel:in STD_LOGIC;
         address:in STD_LOGIC_VECTOR(5 downto 0);
         v0,v1:in STD_LOGIC;
		     sel:out STD_LOGIC);
end MRU;

architecture behavioral of MRU is
  type mruA is array (63 downto 0) of std_logic;
  signal mruArray : mruA := (others=>'0');
  signal output :STD_LOGIC:='0';
begin
	process(clk)
	begin
  if (clk='0' and clk'event) then
    if write='1' and v0='1' and v1='1' then
    output<=mruArray(to_integer(unsigned(address)));
  elsif write='1' and v0='1' and v1='0' then
    output<='1';
    mruArray(to_integer(unsigned(address)))<='1';
    
      elsif write='1' and v0='0' and v1='0' then
    output<='0';
    mruArray(to_integer(unsigned(address)))<='0';
  
    elsif write='1' and v0='0' and v1='1' then
     
    output<='0';
     mruArray(to_integer(unsigned(address)))<='0';
  
  elsif read='0' and data_sel='1' then
      mruArray(to_integer(unsigned(address)))<='1';
   elsif read='0' and data_sel='0' then
      mruArray(to_integer(unsigned(address)))<='0';   
    else
      null;
  end if;
end if;
	end process;
sel<=output;
end behavioral;



