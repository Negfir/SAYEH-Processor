  library IEEE;
use IEEE.std_logic_1164.all;

entity Datapath is
	port (clk,External_Reset : in std_logic;
    y   : in  STD_LOGIC_VECTOR (15 downto 0);
    yi   : out  STD_LOGIC_VECTOR (15 downto 0);
    RdOut   : out  STD_LOGIC_VECTOR (15 downto 0);
    RsOut   : out  STD_LOGIC_VECTOR (15 downto 0);
		IRload : in std_logic;
		readmem : in std_logic;
		writemem : in std_logic;
		memdataready: out std_logic;
		IRdata: out std_logic_vector(15 downto 0);
		WPadd: in std_logic;
		WPreset: in std_logic;
		Shadow: in std_logic;
		RFWE: in std_logic;
		RFLwrite: in std_logic;
		RFRwrite: in std_logic;
		ALUsel: in std_logic_vector(4 downto 0);
		CSet: in std_logic;
    CReset: in std_logic;
    ZSet: in std_logic;
    ZReset: in std_logic;
    SRload: in std_logic;
    Rs_onRside: in std_logic;
    Port_on_Databus: in std_logic;
    Data_on_Port: in std_logic;
    IR_on_LOpndBus: in std_logic;
    IR_on_HOpndBus: in std_logic;
    RFright_on_OpndBus: in std_logic;
    Memory_in_Databus: in std_logic;
    Address_on_Databus: in std_logic;
    ALUout_on_Databus: in std_logic;
    C: out std_logic;
    Z: out std_logic;
    ResetPC, PCplusI, PCplus1 : IN std_logic;
    RplusI, Rplus0, EnablePC : IN std_logic);
    
end entity Datapath;

  architecture RTL of Datapath is 
  
component memory is
	


	port (clk,External_Reset ,readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databus : out std_logic_vector (15 downto 0);
		databusIn : in std_logic_vector (15 downto 0);
		memdataready : out std_logic);
end component memory;
  
  component AddressUnit IS
 PORT (
 Rside : IN std_logic_vector (15 DOWNTO 0);
 Iside : IN std_logic_vector (7 DOWNTO 0);
 Address : OUT std_logic_vector (15 DOWNTO 0);
 clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
 RplusI, Rplus0, EnablePC : IN std_logic);
 END component;
 
 component IR is 
  port(d: in std_logic_vector (15 downto 0);
    load: in std_logic ;
    clk: in std_logic;
    q: out std_logic_vector (15 downto 0));
  end component;
  
  component WP is 
  port(d: in std_logic_vector (5 downto 0);
    WPadd: in std_logic;
    clk: in std_logic;
    WPreset: in std_logic;
    q: out std_logic_vector (5 downto 0));
  end component;
  
  component RegisterFile is 
  port(WP: in std_logic_vector (5 downto 0);
    o_Sel1: in std_logic_vector (1 downto 0); --Rs
    o_Sel2: in std_logic_vector (1 downto 0); --Rd
    i_Sel: in std_logic_vector (1 downto 0);
    clk: in std_logic;
    WE: in std_logic ;
    RFLwrite: in std_logic ;
    RFRwrite: in std_logic ;
    Data: in std_logic_vector (15 downto 0);
    Rs: out std_logic_vector (15 downto 0); 
    Rd: out std_logic_vector (15 downto 0));
  end component;
  
  component ALU is 
  port(Rs: in std_logic_vector(15 downto 0);    
    Rd: in std_logic_vector(15 downto 0);
    sel: in std_logic_vector(4 downto 0);
    Cin: in std_logic;
    Zin: in std_logic;
    clk: in std_logic;
    Cout: out std_logic;
    Zout: out std_logic;
    res: out std_logic_vector(15 downto 0));
end component;

  
 component Flags is 
  port(Cout: in std_logic;
    Zout: in std_logic;
    CSet: in std_logic;
    CReset: in std_logic;
    ZSet: in std_logic;
    ZReset: in std_logic;
    SRload: in std_logic;
    clk: in std_logic;
    C: out std_logic;
    Z: out std_logic);
  end component; 
  
  component MUX16 is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (15 downto 0);
           B   : in  STD_LOGIC_VECTOR (15 downto 0);
           X   : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component MUX4 is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (3 downto 0);
           B   : in  STD_LOGIC_VECTOR (3 downto 0);
           X   : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component TRI is
    Port ( Memory_in_Databus: in std_logic;
    ALUout_on_Databus: in std_logic;
    Address_on_Databus: in std_logic;
    Port_on_Databus: in std_logic;
  
           MEMout,ALUout,address   : in  STD_LOGIC_VECTOR (15 downto 0);
           y   : in  STD_LOGIC_VECTOR (15 downto 0);
           
           X   : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component TRI8 is
     Port ( IR_on_LOpndBus : in  STD_LOGIC;
           IR_on_HOpndBus : in  STD_LOGIC;
           Low   : in  STD_LOGIC_VECTOR (15 downto 0);
           High   : in  STD_LOGIC_VECTOR (15 downto 0);
           X   : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component TRI2 is
    Port ( Data_on_Port: in std_logic;
           Data   : in  STD_LOGIC_VECTOR (15 downto 0);
           yi   : out  STD_LOGIC_VECTOR (15 downto 0));
end component;
  
  signal Low,High,MEMout,DataBus,OpndBus,IRout,MemoryOut,AddressSignal,Rs,Rd,Rsin,ALUout,Rside,Address: std_logic_vector(15 downto 0):="0000000000000000";
  signal WPout: std_logic_vector(5 downto 0);
  signal RFaddress: std_logic_vector(3 downto 0):="0000";
  signal Cin,Zin,Cout,Zout: std_logic:='0';
  
   begin
     Mem: memory port map (clk,External_Reset, readmem, writemem, Address, MEMout,DataBus, memdataready);
     Address0: AddressUnit port map (Rside,IRout(7 downto 0),Address,clk, ResetPC, PCplusI, PCplus1,RplusI, Rplus0, EnablePC);
     InsReg: IR port map(DataBus,IRload,clk,IRout);
     WP0: WP port map (IRout(5 downto 0),WPadd,clk,WPreset,WPout);  
     RF: RegisterFile port map (WPout,RFaddress(3 downto 2),RFaddress(1 downto 0),RFaddress(3 downto 2),clk,RFWE,RFLwrite,RFRwrite,DataBus,Rs,Rd);
     ALU0: ALU port map (Rsin,Rd,ALUsel,Cin,Zin,clk,Cout,Zout,ALUout);
     Flag: Flags port map (Cout,Zout,CSet,CReset,ZSet,ZReset,SRload,clk,Cin,Zin); 
     C<=Cin;
     Z<=Zin; 
     
     Low<=OpndBus(15 downto 8)&IRout(7 downto 0);
     High<=IRout(7 downto 0)&OpndBus(7 downto 0);
     m1: MUX4 port map(shadow,IRout(11 downto 8),IRout(3 downto 0),RFaddress);
     m2: MUX16 port map (Rs_onRside,Rs,Rd,Rside);
     m3: TRI8 port map (IR_on_LOpndBus,IR_on_HOpndBus,Low,High,OpndBus(15 downto 0));
     --m4: TRI8 port map (IR_on_HOpndBus,High,OpndBus(15 downto 0));
     m5: MUX16 port map (RFright_on_OpndBus,Rs,OpndBus,Rsin);
     m6: TRI port map (Memory_in_Databus,ALUout_on_Databus,Address_on_Databus,Port_on_Databus,MEMout,ALUout,address,y,databus);
     m7: TRI2 port map (Data_on_Port,databus,yi);
       
       RsOut<=Rsin;
       RdOut<=Rd;
       
IRdata<= IRout;
end RTL;
