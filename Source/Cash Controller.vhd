 LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY cache_controller IS
	PORT (clk,External_Reset,read,write,hit : IN std_logic;
		reset_n,wren,invalidate,readmem, writemem,data_ready,sel,cacheIn: OUT std_logic);
END ENTITY;

ARCHITECTURE rtl OF cache_controller IS
	TYPE state IS (first,reset,readm,writem,memoryData,reset2);
	SIGNAL current_state : state:=reset;
	SIGNAL next_state : state;
	SIGNAL ShadowE,ENIR : std_logic := '0';

	
	
begin

PROCESS (clk, External_Reset)
	BEGIN
		IF External_Reset = '1' THEN
			current_state <= Reset;
		ELSIF clk'EVENT AND clk = '1' THEN
			current_state <= next_state;
		END IF;
	END PROCESS;

	PROCESS (current_state)

		BEGIN
		  
       
      reset_n<= '0';
      wren<= '0';
      invalidate<= '0';
      readmem<= '0';
      writemem<= '0';
      data_ready<= '0';
      sel<= '0';
      cacheIn<= '0';
			CASE current_state IS
			  when reset =>
			    reset_n<='1';
			    next_state<=first;
			    
				WHEN first => 
					if read='1' then
					  next_state<=readm;
					  elsif write='1' then 
					    next_state<=writem;
					    else
					      next_state<=reset2;
					      end if;
					  WHEN reset2=>
					     next_state<=first; 

				when writem=> 
				  writemem<='1';
				  --invalidate<='1';
				  wren<='1';
				  next_state<=first;

       when readm=>
						if hit='1' then
						  sel<='1';
						  data_ready<= '1';
						  next_state<=first;
						  else
						    readmem<='1';
						   -- data_ready<= '1';
						    
						    next_state<=memoryData;
						  end if;
			--iiiiiiii			  
						  
							when memoryData=>
							  wren<='1';
							  cacheIn<= '1';
							  data_ready<= '1';
				        next_state<=first;

						WHEN OTHERS => next_state <= reset;
				END CASE;
			END PROCESS;
		END ARCHITECTURE;
