library IEEE;
use IEEE.std_logic_1164.all;

entity Flags is 
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
  end entity;
  
  architecture rtl of Flags is 
   begin
     process(clk)
       begin
    if clk = '1' and clk'event then
      if SRload='1' then
        C<=Cout;
        Z<=Zout;
      else null;
      end if;
      if CSet='1' then
        C<='1';
        else null;
      end if;
      if CReset='1' then
        C<='0';
        else null;
      end if;
      if ZSet='1' then
        Z<='1';
        else null;
      end if;
      if ZReset='1' then
        Z<='0';
        else null;
      end if;
    end if;

  end process;
end rtl;







