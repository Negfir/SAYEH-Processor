library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is

	port (clk, External_Reset,readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databus : out std_logic_vector (15 downto 0);
		databusIn : in std_logic_vector (15 downto 0);
		memdataready : out std_logic);
end entity memory;

architecture behavioral of memory is
  
	component DRAM is
	port (clk, readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databusIn : in std_logic_vector (15 downto 0);
				databus : out std_logic_vector (15 downto 0);
		memdataready : out std_logic);
end component DRAM;

component cache is
    port(clk:in STD_LOGIC;
         reset_n:in STD_LOGIC;
         address:in STD_LOGIC_VECTOR(9 downto 0);      
         wren,readmem:in STD_LOGIC;
         wrdata:in STD_LOGIC_VECTOR(15 downto 0);
         data:out STD_LOGIC_VECTOR(15 downto 0);
         invalidate:in STD_LOGIC;
         hit:out STD_LOGIC);
end component;


component cache_controller IS
	PORT (clk,External_Reset,read,write,hit : IN std_logic;
		reset_n,wren,invalidate,readmem, writemem,data_ready,sel,cacheIn: OUT std_logic);
END component;


	component mux16l port ( a,b : in  std_logic_vector(15 downto 0);
       s : in  std_logic;
       o : out std_logic_vector(15 downto 0));
	end component;


 
signal         reset_n,wren,invalidate,readmem0, writemem0,sel,read,write,hit,r,cacheIn: STD_LOGIC;    
signal         data_mem,data_cache,input_cache: STD_LOGIC_VECTOR(15 downto 0);


begin

mem: DRAM port map (clk,readmem0, writemem0,addressbus,databusIn,data_mem,r);
cache0: cache port map (clk,reset_n,addressbus(9 downto 0),wren,readmem,input_cache,data_cache,invalidate,hit);
cont: cache_controller port map (clk,External_Reset,readmem, writemem,hit,reset_n,wren,invalidate,readmem0, writemem0,memdataready,sel,cacheIn);  
mux16bit0 : MUX16l port map (data_mem,data_cache,sel,databus);
mux16bit1 : MUX16l port map (databusIn,data_mem,cacheIn,input_cache);
end architecture behavioral;

