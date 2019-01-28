LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Main IS
	PORT (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33,P34,P35,P36,P37,P38,P39,P40,P41,P42,P43,P44,P45,P46,P47,P48,P49,P50,P51,P52,P53,P54,P55,P56,P57,P58,P59,P60,P61,P62,P63 : inout std_logic_vector(15 downto 0);
  External_Reset : in std_logic;
	clk: in std_logic);
	
	  end Main;
	  
	  Architecture RTL of Main is
	  
	  COMPONENT Datapath is
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
    
end COMPONENT;

COMPONENT Controller IS
	PORT (
		IR : IN std_logic_vector(15 DOWNTO 0);
		Rd   : in  STD_LOGIC_VECTOR (15 downto 0);
    Rs   : in  STD_LOGIC_VECTOR (15 downto 0);
		clk, External_Reset, Zout, Cout, MemDataReady : IN std_logic;
		IRload : OUT std_logic;
		readmem : OUT std_logic;
		writemem : OUT std_logic;
		WPadd : OUT std_logic;
		WPreset : OUT std_logic;
		Shadow : OUT std_logic;
		RFWE : OUT std_logic;
		RFLwrite : OUT std_logic;
		RFHwrite : OUT std_logic;
		ALUsel : OUT std_logic_vector(4 DOWNTO 0);
		PortSel: OUT std_logic_vector(5 DOWNTO 0);
		CSet : OUT std_logic;
		CReset : OUT std_logic;
		ZSet : OUT std_logic;
		ZReset : OUT std_logic;
		SRload : OUT std_logic;
		Rs_onRside : OUT std_logic;
		EN: OUT std_logic;
		Port_on_Databus: out std_logic;
		
    Data_on_Port: out std_logic;
		IR_on_LOpndBus : OUT std_logic;
		IR_on_HOpndBus : OUT std_logic;
		RFright_on_OpndBus : OUT std_logic;
		Memory_in_Databus: out std_logic;
		Address_on_Databus : OUT std_logic;
		ALUout_on_Databus : OUT std_logic;
		ResetPC, PCplusI, PCplus1 : OUT std_logic;
		RplusI, Rplus0, EnablePC : OUT std_logic);
END COMPONENT;

COMPONENT multiplexer64 is
Port (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33,P34,P35,P36,P37,P38,P39,P40,P41,P42,P43,P44,P45,P46,P47,P48,P49,P50,P51,P52,P53,P54,P55,P56,P57,P58,P59,P60,P61,P62,P63 : inout std_logic_vector(15 downto 0);
      EN: in std_logic;
      Port_on_Databus: in std_logic;
    Data_on_Port: in std_logic;

PortSel:in STD_LOGIC_VECTOR (5 downto 0);
y : out STD_LOGIC_vector(15 downto 0);
yi : in STD_LOGIC_vector(15 downto 0));
end COMPONENT;

signal EN,Port_on_Databus,Data_on_Port,Memory_in_Databus,Zout, Cout, MemDataReady, IRload ,readmem,writemem,WPadd,WPreset,Shadow,RFWE,RFLwrite ,RFHwrite,CSet,CReset,ZSet,ZReset,SRload,Rs_onRside,IR_on_LOpndBus,IR_on_HOpndBus,	RFright_on_OpndBus,Address_on_Databus,ALUout_on_Databus, ResetPC, PCplusI, PCplus1,RplusI, Rplus0, EnablePC : std_logic:='0' ;
signal ALUsel : std_logic_vector(4 DOWNTO 0):="00000";
signal PortSel : std_logic_vector(5 DOWNTO 0):="000000";
signal IR,y,yi,Rd,Rs : std_logic_vector(15 DOWNTO 0):="0000000000000000";
begin
  Cont: Controller port map (IR,Rd,Rs,clk,External_Reset,Zout, Cout, MemDataReady, IRload ,readmem,writemem,WPadd,WPreset,Shadow,RFWE,RFLwrite ,RFHwrite,ALUsel,PortSel,CSet,CReset,ZSet,ZReset,SRload,Rs_onRside,EN,Port_on_Databus,Data_on_Port,IR_on_LOpndBus,IR_on_HOpndBus,	RFright_on_OpndBus,Memory_in_Databus,Address_on_Databus,ALUout_on_Databus, ResetPC, PCplusI, PCplus1,RplusI, Rplus0, EnablePC);
  Path: Datapath port map (clk,External_Reset,y,yi,Rd,Rs,IRload,readmem,writemem,memdataready,IR,WPadd,WPreset,Shadow,RFWE,RFHwrite ,RFLwrite,ALUsel,CSet,CReset,ZSet,ZReset,SRload,Rs_onRside,Port_on_Databus,Data_on_Port,IR_on_LOpndBus,IR_on_HOpndBus,	RFright_on_OpndBus,Memory_in_Databus,Address_on_Databus,ALUout_on_Databus,Cout, Zout, ResetPC, PCplusI, PCplus1,RplusI, Rplus0, EnablePC);
  PortMap: multiplexer64 port map (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33,P34,P35,P36,P37,P38,P39,P40,P41,P42,P43,P44,P45,P46,P47,P48,P49,P50,P51,P52,P53,P54,P55,P56,P57,P58,P59,P60,P61,P62,P63,EN,Port_on_Databus,Data_on_Port,PortSel,y,yi);
end architecture;