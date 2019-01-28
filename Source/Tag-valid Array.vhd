LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TagValid is
    port(clk:in STD_LOGIC;
         reset_n:in STD_LOGIC;
         address:in STD_LOGIC_VECTOR(5 downto 0);         
         wren:in STD_LOGIC;
         invalidate:in STD_LOGIC;
         wrdata:in STD_LOGIC_VECTOR(3 downto 0); 
         output:out STD_LOGIC_VECTOR(4 downto 0));
end TagValid;

architecture behavioral of TagValid is
  
  type valid is array (63 downto 0) of std_logic ;  
	type tag is array (63 downto 0) of std_logic_vector (3 downto 0);
	
	
	signal tagArray : tag:= (others=>"0000");
	signal validArray : valid := (others=>'1');
	
begin
    process(clk)
    begin
      
		if(reset_n='1')then
			validArray <= (others=> '0');
		elsif (clk='1' and clk'event) then
	
        if(wren = '1') then
            tagArray(to_integer(unsigned(address))) <= wrdata;
			validArray(to_integer(unsigned(address)))<='1';
			output <= validArray(to_integer(unsigned(address)))&tagArray(to_integer(unsigned(address)));
		end if;

		if(invalidate = '1') then
            validArray(to_integer(unsigned(address))) <= '0';
			output <= validArray(to_integer(unsigned(address)))&tagArray(to_integer(unsigned(address)));
        end if;
		
        output <= validArray(to_integer(unsigned(address)))&tagArray(to_integer(unsigned(address)));
    
    end if;
    end process;
end behavioral;
