
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DRAM is
	port (clk, readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databusIn : in std_logic_vector (15 downto 0);
				databus : out std_logic_vector (15 downto 0);
		memdataready : out std_logic);
end entity DRAM;

architecture behavioral of DRAM is
	type mem is array (0 to 1023) of std_logic_vector (15 downto 0);
begin
	process (clk)
		variable buffermem : mem := (others => (others => '0'));
		variable ad : integer;
		variable init : boolean := true;
	begin
		if init = true then
		  
		  
		  
	
--buffermem(0) := "0011001100110110";	
	--buffermem(1) := "0011011000000000";	

--- set one	
--buffermem(0) := "0010001100000000";	
--buffermem(1) := "0010011000000000";	
--buffermem(2) := "1100000100000000";
--buffermem(15) := "1010101010101011";	
--buffermem(14) := "1010101010101010";		

--set 2:
buffermem(0) := "0000000000000000";
buffermem(64) := "0000000001000000";

buffermem(128) := "0000000010000000";


--buffermem(5) := "0000100000000011";
--buffermem(9) := "0000101000001000";
--buffermem(10) := "1111000000000111";

-----Done





			init := false;
		end if;

		memdataready <= '0';

		if  clk'event and clk = '1' then
			ad := to_integer(unsigned(addressbus));

			if readmem = '1' then -- Readiing :)
				memdataready <= '1';
				if ad >= 1023 then
					databus <= (others => 'Z');
				else
					databus <= buffermem(ad);
				end if;
			elsif writemem = '1' then -- Writing :)
				memdataready <= '1';
				if ad < 1023 then
					buffermem(ad) := databusIn;
				end if;
			elsif readmem = '0' then
				databus <= (others => 'Z');
			end if;
		end if;
	end process;
end architecture behavioral;

