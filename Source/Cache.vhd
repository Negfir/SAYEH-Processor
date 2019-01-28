 LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cache is
    port(clk:in STD_LOGIC;
         reset_n:in STD_LOGIC;
         address:in STD_LOGIC_VECTOR(9 downto 0);      
         wren,readmem:in STD_LOGIC;
         wrdata:in STD_LOGIC_VECTOR(15 downto 0);
         data:out STD_LOGIC_VECTOR(15 downto 0);
         invalidate:in STD_LOGIC;
         hit:out STD_LOGIC);
end cache;

architecture dataflow of cache is
  
component dataArray is
    port(clk:in STD_LOGIC;
         address:in STD_LOGIC_VECTOR(5 downto 0);      
         wren:in STD_LOGIC;
         wrdata:in STD_LOGIC_VECTOR(15 downto 0);
         data:out STD_LOGIC_VECTOR(15 downto 0));
end component;
	
component miss_hit is
    port(tag:in STD_LOGIC_VECTOR(3 downto 0);
         w0,w1:in STD_LOGIC_VECTOR(4 downto 0);
         w0_valid, w1_valid: out STD_LOGIC;
		     hit:out STD_LOGIC);
end component;

	
component TagValid is
    port(clk:in STD_LOGIC;
         reset_n:in STD_LOGIC;
         address:in STD_LOGIC_VECTOR(5 downto 0);         
         wren:in STD_LOGIC;
         invalidate:in STD_LOGIC;
         wrdata:in STD_LOGIC_VECTOR(3 downto 0); 
         output:out STD_LOGIC_VECTOR(4 downto 0));
end component;
	
	component MRU is
    port(clk:in STD_LOGIC;
         write,read,data_sel:in STD_LOGIC;
         address:in STD_LOGIC_VECTOR(5 downto 0);
         v0,v1:in STD_LOGIC;
		     sel:out STD_LOGIC);
end component;
	
	component mux16l port ( a,b : in  std_logic_vector(15 downto 0);
       s : in  std_logic;
       o : out std_logic_vector(15 downto 0));
	end component;
	
	

	signal sel,v0,v1,wren0,wren1,data_sel,invalidate0,invalidate1:std_logic;
	signal data0,data1 : STD_LOGIC_VECTOR(15 downto 0);
--	signal :std_logic_vector(3 downto 0);
	signal vtag0,vtag1:std_logic_vector(4 downto 0);


begin
  
  data_sel<=(not v0) or v1;
  wren0<=(not sel) and wren;
  wren1<=sel and wren;
  invalidate0<=v0 and invalidate;
  invalidate1<=v1 and invalidate;
	set0: dataArray port map(clk,address(5 downto 0),wren0,wrdata,data0);
	set1: dataArray port map(clk,address(5 downto 0),wren1,wrdata,data1);	
	tag0: TagValid port map(clk,reset_n,address(5 downto 0),wren0,invalidate0,address(9 downto 6),vtag0);
	tag1: TagValid port map(clk,reset_n,address(5 downto 0),wren1,invalidate1,address(9 downto 6),vtag1);	
	mru0 : MRU port map(clk,wren,readmem,data_sel,address(5 downto 0),vtag0(4),vtag1(4),sel);	
	misshit : miss_hit port map (address(9 downto 6),vtag0,vtag1,v0,v1,hit);
	mux16bit : MUX16l port map (data0,data1,data_sel,data);
	
end dataflow;