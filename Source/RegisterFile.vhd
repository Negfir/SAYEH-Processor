 library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity RegisterFile is 
  port(WP: in std_logic_vector (5 downto 0);
    o_Sel1: in std_logic_vector (1 downto 0);
    o_Sel2: in std_logic_vector (1 downto 0);
    i_Sel: in std_logic_vector (1 downto 0);
    clk: in std_logic;
    WE: in std_logic ;
    RFLwrite: in std_logic ;
    RFRwrite: in std_logic ;
    Data: in std_logic_vector (15 downto 0);
    Rs: out std_logic_vector (15 downto 0);
    Rd: out std_logic_vector (15 downto 0));
  end entity;
  
  
  architecture dataflow of RegisterFile is
    

  
  type reg_file is array (63 downto 0) of std_logic_vector(15 downto 0);
  signal regs: reg_file := ((others=> (others=>'0')));
    
begin
  
  
  process(clk)
begin
  
  if clk='1' and clk'event then
    Rs <= regs(to_integer(unsigned(o_Sel2+WP)));
    Rd <= regs(to_integer(unsigned(o_Sel1+WP)));

    if (RFLwrite = '1' and RFRwrite = '1') then
      regs(to_integer(unsigned(i_Sel+WP)))(15 downto 0) <= Data(15 downto 0);
    elsif (RFLwrite = '1' and RFRwrite = '0') then
      regs(to_integer(unsigned(i_Sel+WP)))(15 downto 0) <= Data(15 downto 8)&regs(to_integer(unsigned(i_Sel+WP)))(7 downto 0);
    elsif (RFLwrite = '0' and RFRwrite = '1') then
      regs(to_integer(unsigned(i_Sel+WP)))(15 downto 0) <=regs(to_integer(unsigned(i_Sel+WP)))(15 downto 8)& Data(7 downto 0);
    else null;
  end if;
end if;
end process;
  
end architecture;


