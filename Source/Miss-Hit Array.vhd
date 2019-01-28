LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity miss_hit is
    port(tag:in STD_LOGIC_VECTOR(3 downto 0);
         w0,w1:in STD_LOGIC_VECTOR(4 downto 0);
         w0_valid, w1_valid: out STD_LOGIC:='0';
		     hit:out STD_LOGIC);
end miss_hit;

architecture behavioral of miss_hit is
begin
	process(tag(3),tag(2),tag(1),tag(0),w0,w1)
	begin
		hit<='0';
        if(w0(4) = '1' and  tag(3)=w0(3) and tag(2)=w0(2) and tag(1)=w0(1) and tag(0)=w0(0) ) then
            w0_valid <= '1';
			hit<='1';
		else
			w0_valid <= '0';
		end if;
		if(w1(4) = '1' and  tag(3)=w1(3) and tag(2)=w1(2) and tag(1)=w1(1) and tag(0)=w1(0)) then
            w1_valid <= '1';
			hit<='1';
		else
			w1_valid <= '0';
        end if;
	end process;

end behavioral;

