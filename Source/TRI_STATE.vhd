 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TRI is
    Port ( Memory_in_Databus: in std_logic;
    ALUout_on_Databus: in std_logic;
    Address_on_Databus: in std_logic;
    Port_on_Databus: in std_logic;
 
           MEMout,ALUout,address   : in  STD_LOGIC_VECTOR (15 downto 0);
           y   : in  STD_LOGIC_VECTOR (15 downto 0);
       
           X   : out STD_LOGIC_VECTOR (15 downto 0));
end TRI;

architecture Behavioral of TRI is
 signal q   :  STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";
begin
         process(MEMout,ALUout,Port_on_Databus,address,y,Memory_in_Databus,Address_on_Databus,ALUout_on_Databus)
    begin
    if  Memory_in_Databus='1' then
      q<=MEMout;
    elsif ALUout_on_Databus='1' then
      q<=ALUout;

      elsif Address_on_Databus='1' then
      q<=address;
      elsif Port_on_Databus='1' then
      q<=y;
    else
      null;
    end if;
 

 
  end process; 
  X<=q;
end Behavioral;


