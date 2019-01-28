LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dataArray is
    port(clk:in STD_LOGIC;
         address:in STD_LOGIC_VECTOR(5 downto 0);      
         wren:in STD_LOGIC;
         wrdata:in STD_LOGIC_VECTOR(15 downto 0);
         data:out STD_LOGIC_VECTOR(15 downto 0));
end dataArray;

architecture behavioral of dataArray is

    type Darray is array (63 downto 0) of STD_LOGIC_VECTOR (15 downto 0);
    signal data_array : Darray;
begin
    data <= data_array(to_integer(unsigned(address)));
    process(clk)
    begin
      if (clk'event and clk='1') then
        if(wren = '1') then
            data_array(to_integer(unsigned(address))) <= wrdata;
        end if;
end if;
    end process;

end behavioral;

