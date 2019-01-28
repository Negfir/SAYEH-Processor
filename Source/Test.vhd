library IEEE;
use IEEE.std_logic_1164.ALL;
ENTITY test is
END test;
ARCHITECTURE simulate OF test IS
  
COMPONENT memory is

	port (clk, External_Reset,readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databus : out std_logic_vector (15 downto 0);
		databusIn : in std_logic_vector (15 downto 0);
		memdataready : out std_logic);

	  end COMPONENT;  

signal clk, reset,readmem, writemem ,memdataready: std_logic := '0';
signal addressbus,databus,databusIn:  std_logic_vector (15 downto 0);
BEGIN

Sayeh : memory port map (clk, reset,readmem, writemem,addressbus,databus,databusIn,memdataready);
  readmem<='1';
  addressbus<="0000000000000001";
	reset <= '1', '0' after 10 ns;
	clk <= not clk after 50 ns;
	
END simulate;
