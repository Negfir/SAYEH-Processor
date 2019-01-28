--------------------
library IEEE;
use IEEE.std_logic_1164.all;
--------------------
--1 AND Component:
--------------------
entity ANDgate is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
    res: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of ANDgate is
begin
  m: for i in 0 to 15 generate
     begin
       res(i)<=Rd(i) and Rs(i);
     end generate;
end architecture;


--------------------
library IEEE;
use IEEE.std_logic_1164.all;
--------------------
--2 OR Component:
--------------------

entity ORgate is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
    res: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of ORgate is
begin
  m: for i in 0 to 15 generate
     begin
       res(i)<=Rd(i) or Rs(i);
     end generate;
end architecture;


----------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------
--3 Shift-Right Component:
----------------------------
entity ShrB is 
  port(Rs: in std_logic_vector(15 downto 0);
    C: out std_logic;
    Rd: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of ShrB is
  signal q:  std_logic_vector(15 downto 0);
begin
   q<= '0'&Rs(15 downto 1);
   C<=Rs(0);
   Rd<=q;
end architecture;



----------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------
--4 Shift-Left Component:
----------------------------
entity ShlB is 
  port(Rs: in std_logic_vector(15 downto 0);
    C: out std_logic;
    Rd: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of ShlB is
  signal q:  std_logic_vector(15 downto 0);
begin
   q<= Rs(14 downto 0)&'0';
   C<=Rs(15);
   Rd<=q;
end architecture;


----------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------
--5 Comparison Component:
----------------------------
entity cmp is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
     Z: out std_logic;
     C: out std_logic);
end entity;

architecture behavioral of cmp is
begin
  process (Rs,Rd)
    begin
   if Rs=Rd then
     z<='1';
     c<='0';
   elsif Rs>Rd then
     c<='1';
     z<='0';
   else
     c<='0'; 
     z<='0';  
     end if;
     end process;
end architecture;


--------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;
--------------------
--6 Addition Component:
--------------------

entity add is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
    cin: in std_logic;
    cout: out std_logic;
    res: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of add is
  signal s:std_logic_vector(16 downto 0);
begin 
 s<=('0'&Rd)+Rs+cin;
 res<=s(15 downto 0);
 cout<=s(16);
end architecture;


--------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
--------------------
--7 Subtraction Component:
--------------------

entity sub is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
    bin: in std_logic;
    bout: out std_logic;
    z: out std_logic;
    res: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of sub is
  signal s:std_logic_vector(16 downto 0);
  
begin
 
 s<=('0'&Rd)-Rs;
 --s<= s-bin;
 res<=s(15 downto 0)-bin;
 bout<=s(16);
 
 Z<='1' when s(15 downto 0)="0000000000000000"
 else '0'; 
     
end architecture;

--------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
--------------------
--8 Multiplication Component:
--------------------

entity mul is 
  port(Rs: in std_logic_vector(7 downto 0);
    Rd: in std_logic_vector(7 downto 0);
    res: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of mul is
  type twoD is array (7 downto 0) of std_logic_vector(7 downto 0);
  signal tmp: twoD := ((others=> (others=>'0')));
  signal t0,t1,t2,t3,t4,t5,t6,t7: std_logic_vector(7 downto 0);
begin 


	 U0: for i in 0  to 7 generate
     begin
          t0(i)<=Rs(i) and Rd(0);
     end generate;
 tmp(0)<=t0;
 
 	 U1: for i in 0 to 7 generate
     begin
          t1(i)<=Rs(i) and Rd(1);
     end generate;
 tmp(1)<=t1;
 
 	 U2: for i in 0 to 7 generate
     begin
          t2(i)<=Rs(i) and Rd(2);
     end generate;
 tmp(2)<=t2;
 
	 U3: for i in 0 to 7 generate
     begin
          t3(i)<=Rs(i) and Rd(3);
     end generate;
 tmp(3)<=t3;
 
 	 U4: for i in 0 to 7 generate
     begin
          t4(i)<=Rs(i) and Rd(4);
     end generate;
 tmp(4)<=t4;
 
 	 U5: for i in 0 to 7 generate
     begin
          t5(i)<=Rs(i) and Rd(5);
     end generate;
 tmp(5)<=t5;
 
 	 U6: for i in 0 to 7 generate
     begin
          t6(i)<=Rs(i) and Rd(6);
     end generate;
 tmp(6)<=t6;
 
 	 U7: for i in 0 to 7 generate
     begin
          t7(i)<=Rs(i) and Rd(7);
     end generate;
 tmp(7)<=t7;
 
res<=tmp(0)+(tmp(1)&'0')+(tmp(2)&"00")+(tmp(3)&"000")+(tmp(4)&"0000")+(tmp(5)&"00000")+(tmp(6)&"000000")+('0'&tmp(7)&"0000000");
end architecture;



--------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
--------------------
--9 Division Component:
--------------------

entity div is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(7 downto 0);
    res: out std_logic_vector(7 downto 0));
end entity;

architecture behavioral of div is
  

begin 

process(Rs,Rd)
    variable A: std_logic_vector(15 downto 0);
    variable B,C: std_logic_vector(7 downto 0):="00000000";
 begin
  A:=Rs;
  B:=Rd;
  C:="00000000";
	 for i in to_integer(unsigned(Rs))  downto 0 loop   
          if A>B or A=B then           
            A:=A-rd;
            C:=C+1;
          end if;
     end loop;
  res<=C;    
     
end process;

end architecture;




----------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------
--10 Complement Component:
----------------------------
entity notB is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of notB is
begin
   m: for i in 0 to 15 generate
     begin
       Rd(i)<=not Rs(i);
     end generate;
end architecture;

----------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------
--11 Complement Component:
----------------------------
entity Rand is 
  port(
  clk: in std_logic;
  RND: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of Rand is

  signal tmp : std_logic_vector(15 downto 0):="1001000000000000";
  signal b: std_logic;
begin

 --  b<= inp(15) xor inp(14) xor inp(13) xor inp(11);
   process (clk) begin
   if clk = '1' and clk'event then 
   tmp<= tmp (14 downto 0) & '0';
   end if;
   end process;
 --  RND<=tmp;
end architecture;

----------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------
--11 Random Component:
----------------------------

entity RND is
  port (
    cout   :out std_logic_vector (15 downto 0);-- Output of the counter
    enable :in  std_logic;                    -- Enable counting
    clk    :in  std_logic;                    -- Input rlock
    reset  :in  std_logic                     -- Input reset
  );
end entity;

architecture rtl of RND is
    signal count           :std_logic_vector (15 downto 0):="0000000000000000";
    signal linear_feedback :std_logic;

begin
    linear_feedback <= not(count(14) xor count(3));


    process (clk) begin
        if clk = '1' and clk'event then
        count <= ('0'&count(13) & count(12) & count(11) & count(10) 
                          & count(9) & count(8) & count(7) & count(6) & count(5) & count(4) & count(3) 
                          & count(2) & count(1) & count(0) & 
                          linear_feedback);
        end if;
    end process;
    --count(15)<='0';
    cout <= count;
end architecture;


----------------------------
library ieee; 
use ieee.std_logic_1164.all; 
use IEEE.STD_LOGIC_unsigned.ALL;
----------------------------
--12 Squart Component:
----------------------------

entity squart is port( data_in    : in std_logic_vector(7 downto 0); 
data_out   : out std_logic_vector(3 downto 0)); 
end squart;

architecture behaviour of squart is

signal part_done  : std_logic := '0';
signal part_count : integer := 3; 
signal result     : std_logic_vector(4 downto 0) := "00000"; 
signal partialq   : std_logic_vector(5 downto 0) := "000000";

begin   
    part_done_1: process( data_in, part_done)  
    begin
       
            if(part_done='0')then
                if(part_count>=0)then
                    partialq(1 downto 0)  <= data_in((part_count*2)+ 1 downto part_count*2);
                    part_done <= '1';    else
                    data_out <= result(3 downto 0);    
                end if;    
                part_count <= part_count - 1;
                elsif(part_done='1')then
                    if((result(3 downto 0) & "01") <= partialq)then
                        result   <= result(3 downto 0) & '1';
                        partialq(5 downto 2) <= partialq(3 downto 0) - (result(1 downto 0)&"01");    
                    else 
                        result   <= result(3 downto 0) & '0';
                        partialq(5 downto 2) <= partialq(3 downto 0);                     
                    end if;   
                    part_done  <= '0';
                
            end if;  
        end process;   
    end behaviour;
    
    
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
----------------------------
--13 Two's complement Component:
----------------------------
entity twos_complement is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of twos_complement is
  signal tmp: std_logic_vector(15 downto 0);
begin
   m: for i in 0 to 15 generate
     begin
       tmp(i)<=not Rs(i);
     end generate;
     Rd<=tmp+1;
end architecture;    


--------------------
library IEEE;
use IEEE.std_logic_1164.all;
--------------------
--14 XOR Component:
--------------------
entity XORgate is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
    res: out std_logic_vector(15 downto 0));
end entity;

architecture behavioral of XORgate is
begin
  m: for i in 0 to 15 generate
     begin
       res(i)<=(Rd(i) and  (not Rs(i))) or ((not Rd(i)) and  Rs(i));
     end generate;
end architecture;


----------------------------
----------------------------
----------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------
----------------------------
-- ALU:
----------------------------
----------------------------
----------------------------
entity ALU is 
  port(Rs: in std_logic_vector(15 downto 0);    
    Rd: in std_logic_vector(15 downto 0);
    sel: in std_logic_vector(4 downto 0);
    Cin: in std_logic;
    Zin: in std_logic;
    clk: in std_logic;
    Cout: out std_logic;
    Zout: out std_logic;
    res: out std_logic_vector(15 downto 0));
end entity;

architecture arc of ALU is
  
  component ANDgate is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
    res: out std_logic_vector(15 downto 0));
end component;

component ORgate is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
    res: out std_logic_vector(15 downto 0));
end component;

component ShrB is 
  port(Rs: in std_logic_vector(15 downto 0);
    C: out std_logic;
    Rd: out std_logic_vector(15 downto 0));
end component;

component ShlB is 
  port(Rs: in std_logic_vector(15 downto 0);
    C: out std_logic;
    Rd: out std_logic_vector(15 downto 0));
end component;

component cmp is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
     Z: out std_logic;
     C: out std_logic);
end component;

component add is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
    cin: in std_logic;
    cout: out std_logic;
    res: out std_logic_vector(15 downto 0));
end component;

component sub is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
    bin: in std_logic;
    bout: out std_logic;
    z: out std_logic;
    res: out std_logic_vector(15 downto 0));
end component;

component mul is 
  port(Rs: in std_logic_vector(7 downto 0);
    Rd: in std_logic_vector(7 downto 0);
    res: out std_logic_vector(15 downto 0));
end component;

component notB is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: out std_logic_vector(15 downto 0));
end component;

component twos_complement is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: out std_logic_vector(15 downto 0));
end component;

component RND is
  port (
    cout   :out std_logic_vector (15 downto 0);
    enable :in  std_logic;                    
    clk    :in  std_logic;                    
    reset  :in  std_logic                     
  );
end component;


 component Squart is port( data_in    : in std_logic_vector(7 downto 0); 
data_out   : out std_logic_vector(3 downto 0)); 
end component;

component XORgate is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(15 downto 0);
    res: out std_logic_vector(15 downto 0));
end component;

component div is 
  port(Rs: in std_logic_vector(15 downto 0);
    Rd: in std_logic_vector(7 downto 0);
    res: out std_logic_vector(7 downto 0));
end component;

signal r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r11,r12,r13,r14,r15,r16,r17: std_logic_vector(15 downto 0):="0000000000000000";
signal c2,c3,c4,z4,c5,c6,z6: std_logic:='0';
begin
  A0: ANDgate port map (Rs,Rd,r0);
  A1: ORgate port map (Rs,Rd,r1); 
  A2: ShrB port map (Rs,c2,r2);
  A3: ShlB port map (Rs,c3,r3);
  A4: cmp port map (Rs,Rd,z4,c4);
  A5: add port map (Rs,Rd,Cin,c5,r5);
  A6: sub port map (Rs,Rd,Cin,c6,z6,r6);
  A7: mul port map (Rs(7 downto 0) ,Rd(7 downto 0),r7); 
  A9: notB port map (Rd,r9); 
  A11: twos_complement port map (Rs,r11);  
  A12: RND port map (r12,'1',clk,'0'); 
--  A13: Squart port map (Rs,r13); 
  A14: XORgate port map (Rs,Rd,r14);
  A15: div port map (Rd,Rs(7 downto 0),r15(7 downto 0));    
   process(sel,Rs,Rd,Zin,Cin,clk)
     begin
       case sel is
           when "00000" => res <=r0;
           when "00001" => res <=r1;
           when "00010" => res <=r2; Cout<=c2;
           when "00011" => res <=r3; Cout<=c3;
           when "00100" => res <=r4; Cout<=c4; Zout<=Z4;  
           when "00101" => res <=r5; Cout<=c5;
           when "00110" => res <=r6; Cout<=c6; Zout<=Z6;
           when "00111" => res <=r7;
           when "01001" => res <=r9;
           when "01010" => res <=Rs; 
           when "01011" => res <=r11;
           when "01100" => res <=r12;
           when "01101" => res <=r13; 
           when "01110" => res <=r14;
           when "01111" => res <=r15;
           when others => null; 
   end case;
   end process;
end architecture;








