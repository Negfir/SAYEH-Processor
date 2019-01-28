  LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY controller IS
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
		RplusI, Rplus0, EnablePC : OUT std_logic
	);
END ENTITY;

ARCHITECTURE rtl OF controller IS
	TYPE state IS (Reset, Fetch, Decode,IRoutSet, TMP,Execute,Execute2,Halt,IDA,OP0,OP1,IFP,OTP,sta4,PCplusOne,PortIn,PortOut,fch,IDA1,sta1,sta2,sta3);
	SIGNAL current_state : state;
	SIGNAL next_state : state;
	SIGNAL ShadowE,ENIR : std_logic := '0';
	signal IRout : std_logic_vector(15 DOWNTO 0):= (others=>'0');
	
	
begin
Shadow<=ShadowE;

PROCESS (clk, External_Reset)
	BEGIN
		IF External_Reset = '1' THEN
			current_state <= Reset;
		ELSIF clk'EVENT AND clk = '1' THEN
			current_state <= next_state;
		END IF;
	END PROCESS;

	PROCESS (current_state)
	   --variable IRout : std_logic_vector(15 DOWNTO 0):=(others=>'0');
		BEGIN
		  
	--	 IF NOT (IRout(7 downto 0) = "11110000") THEN
--		ShadowE <= '1';
--	ELSE
--		shadowE <= '0'; 
	--END IF
	
			IRload <= '0';
			readmem <= '0';
			writemem <= '0';
			WPadd <= '0';
			WPreset <= '0';
		
			RFWE <= '0';
			RFLwrite <= '0';
			RFHwrite <= '0';
			ALUsel <= "00000";
			PortSel<="000000";
			CSet <= '0';
			CReset <= '0';
			ZSet <= '0';
			ZReset <= '0';
			SRload <= '0';
			Rs_onRside <= '0';
			Port_on_Databus <='0';
      Data_on_Port <='0';
			IR_on_LOpndBus <= '0';
			IR_on_HOpndBus <= '0';
			RFright_on_OpndBus <= '0';
			Memory_in_Databus<='0';
			Address_on_Databus <= '0';
			ALUout_on_Databus <= '0';
			ResetPC <= '0';
			EN<='0';
			PCplusI <= '0';
			PCplus1 <= '0';
			RplusI <= '0';
			Rplus0 <= '0';
			EnablePC <= '0';
			ENIR<='0';
			CASE current_state IS
				WHEN Reset => 
					ResetPC <= '1';
					EnablePC <= '1';
					WPreset <= '1';
					CReset <= '1';
			    ZReset <= '1';
					next_state <= fetch;

				WHEN Fetch => 
								  readmem <= '1';
				    Memory_in_Databus<='1';
					  next_state <= fch;
					  
					when fch =>

					  				  IF (memDataReady = '0') THEN
				    readmem <= '1';
				    Memory_in_Databus<='1';
				    next_state <= fetch;
				  else 
				    Memory_in_Databus<='1';
				    readmem <= '1';
				  shadowE<='1';
					next_state <= Decode;
					end if;
					
					

				WHEN Decode =>
				Memory_in_Databus<='1'; 
					IRload <= '1';
	        
					next_state <= TMP;
					
					WHEN TMP =>
					  	
					next_state <= IRoutSet; 
					  
					
				WHEN IRoutSet =>
					IRout<=IR;
					next_state <= Execute;

				WHEN Execute => 
				
				  
					CASE (IRout(15 DOWNTO 12)) IS
 
						WHEN "0001" => --Move
							RFright_on_OpndBus <= '1';
							ALUsel <= "01010";
							ALUout_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							--SRload <= '1';
							IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;
 
						WHEN "0010" => --Load Address
							Rs_onRside <= '1';
							Rplus0 <= '1';
							readmem <= '1';
							Memory_in_Databus<='1';
							next_state <= IDA1;
 
						WHEN "0011" => --Store Address
							Rs_onRside <= '0';
							Rplus0 <= '1';
							RFright_on_OpndBus <= '1';
		         	ALUsel <= "01010";
							ALUout_on_Databus <= '1';
							writemem <= '1';
							
								next_state <= sta1;
						
							
						WHEN "0100" => -- Input from port
						  RFright_on_OpndBus <= '1';
						  PortSel<=Rs(5 downto 0);
						  Port_on_Databus<='1';
						  RFLwrite <= '1';
							RFHwrite <= '1';
								next_state <= IFP;
							
						  
							
						WHEN "0101" => -- Output to port
						  RFright_on_OpndBus <= '1';
							ALUsel <= "01010";
							ALUout_on_Databus <= '1';
						  Data_on_Port<='1';
						  PortSel<=Rd(5 downto 0);
						  next_state <= OTP;	
						  	  
 
						WHEN "0110" => --AND
							RFright_on_OpndBus <= '1';
							ALUsel <= "00000";
							ALUout_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							--SRload <= '1';
							IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;
 
						WHEN "0111" => -- OR
							RFright_on_OpndBus <= '1';
							ALUsel <= "00001";
							ALUout_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							--SRload <= '1';
							IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;
 
						WHEN "1000" => -- NOT
							RFright_on_OpndBus <= '1';
							ALUsel <= "01001";
							ALUout_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							--SRload <= '1';
							IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;
							
						WHEN "1001" => -- Shift Left
							RFright_on_OpndBus <= '1';
							ALUsel <= "00011";
							ALUout_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
							IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;
							
						WHEN "1010" => -- Shift Right
							RFright_on_OpndBus <= '1';
							ALUsel <= "00010";
							ALUout_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
							IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;	
							
						WHEN "1011" => -- ADD
							RFright_on_OpndBus <= '1';
							ALUsel <= "00101";
							ALUout_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
							IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;		
							
						WHEN "1100" => -- Sub
							RFright_on_OpndBus <= '1';
							ALUsel <= "00110";
							ALUout_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							SRload <= '1';
							IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;	
							
						WHEN "1101" => -- Multiply
							RFright_on_OpndBus <= '1';
							ALUsel <= "00111";
							ALUout_on_Databus <= '1';
							RFLwrite <= '1';
							RFHwrite <= '1';
							
							IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;	
							
						WHEN "1110" => -- Compare
							RFright_on_OpndBus <= '1';
							ALUsel <= "00100";
							SRload <= '1';
							IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;	
							
							
 
						WHEN "0000" => --0000
							next_state <= OP0;
								
								
				   WHEN "1111" =>
				    next_state <= OP1;
				    
				    when others=> next_state <= Reset;
							  end case;
							  
							  
							  


	when OP0 =>
							  CASE (IRout(11 DOWNTO 8)) IS
								WHEN "0000" => --No Operation
									IF (ShadowE = '1') THEN
										next_state <= Execute2;
									ELSE 
										next_state <= PCplusOne;
									END IF;
								WHEN "0001" => --Halt
									next_state <= halt;
								WHEN "0010" => --Z Set
									ZSet <= '1';
									IF (ShadowE = '1') THEN
										next_state <= Execute2;
									ELSE 
										next_state <= PCplusOne;
									END IF;
								WHEN "0011" => --Z Reset
									ZReset <= '1';
									IF (ShadowE = '1') THEN
										next_state <= Execute2;
									ELSE 
										next_state <= PCplusOne;
									END IF;
								WHEN "0100" => --C Set
									CSet <= '1';
									IF (ShadowE = '1') THEN
										next_state <= Execute2;
									ELSE 
										next_state <= PCplusOne;
									END IF;
								WHEN "0101" => --C Reset
									CReset <= '1';
									IF (ShadowE = '1') THEN
										next_state <= Execute2;
									ELSE 
										next_state <= PCplusOne;
									END IF;
								WHEN "0110" => --WP Reset
									WPreset <= '1';
									IF (ShadowE = '1') THEN
										next_state <= Execute2;
									ELSE 
										next_state <= PCplusOne;
									END IF; 
								WHEN "0111" => --PC Plus I
								  EnablePC <= '1';
								  PCplusI <= '1';
								  next_state <= PCplusOne;
								WHEN "1000" => --PC Plus I: if Z=1
								  if Zout='1' then
								   EnablePC <= '1'; 
								  PCplusI <= '1';
								  else
								    null;
								    end if;
								  next_state <= PCplusOne;
								WHEN "1001" => --PC Plus I: if C=1
								  if Cout='1' then
								    EnablePC <= '1';
								  PCplusI <= '1';
								  else
								    null;
								    end if;
								  next_state <= PCplusOne;
								WHEN "1010" => --WP Plus I
								  WPadd <= '1';
								  next_state <= PCplusOne;
								WHEN others => 
								  next_state <= Reset;
								end case;
								
								when OP1 =>
								   CASE (IR(9 DOWNTO 8)) IS
				       WHEN "00" =>  -- Low Write
				         IR_on_LOpndBus<='1';
				         RFright_on_OpndBus <= '0';
							   ALUsel <= "01010";
							   ALUout_on_Databus <= '1';
	    							 RFLwrite <= '1';
	    							 next_state <= PCplusOne;
	    							WHEN "01" => --High Write
				         IR_on_HOpndBus<='1';
				         RFright_on_OpndBus <= '0';
							   ALUsel <= "01010";
							   ALUout_on_Databus <= '1';
	    							 RFHwrite <= '1';
	    							 next_state <= PCplusOne; 
	    							When "10" => --Save PC+I
	    							  PCplusI <= '1';
			            EnablePC <= '1';
			            Address_on_Databus <= '1';
	    							  RFHwrite <= '1'; 
	    							  RFLwrite <= '1'; 
	    							  next_state <= PCplusOne;
	    							WHEN "11" => -- Jump Address Rd+I
	    							  Rs_onRside <= '0';
	    							  RplusI <= '1';
		             	EnablePC <= '1';
		             	next_state <= PCplusOne;

						WHEN OTHERS => 
									next_state <= reset;
						END CASE;


			  
							  
							  
							  
		
		When Execute2 => --Execute 2
	    					  IRout(15 downto 0)<= IR(7 downto 0)&"00000000";
	    					  shadowE<='0';
	    					  next_state <= Execute;
	    					  
	    					  
	    					  
	    					when IFP=>
						  RFright_on_OpndBus <= '1';
						  PortSel<=Rs(5 downto 0);
						  Port_on_Databus<='1';
						  RFLwrite <= '1';
							RFHwrite <= '1';
						  
						  IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;  
	    					  
	    					when OTP => 
	    					RFright_on_OpndBus <= '1';
							ALUsel <= "01010";
							ALUout_on_Databus <= '1';
						  Data_on_Port<='1';
						  EN<='1';
						  PortSel<=Rd(5 downto 0);
						    						    
						    IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;
						    
          when IDA1 =>
							
							Memory_in_Databus<='1';
            Rplus0 <= '1';
								Rs_onRside <= '1';
								Readmem <= '1';
								next_state <= IDA;
								
								
						WHEN IDA =>  --Load Address reset
							IF (memDataReady = '0') THEN
							  Memory_in_Databus<='1';
								Rplus0 <= '1';
								Rs_onRside <= '1';
								Readmem <= '1';
								next_state <= IDA1;

							ELSE
								RFLwrite <= '1';
								RFHwrite <= '1';
								IF (ShadowE = '1') THEN
									next_state <= Execute2;
								ELSE
									next_state <= PCplusOne;
								END IF;
							END IF;
							
							when halt =>
							  next_state <= PCplusOne;
							
							when PCplusOne =>
							  PCplus1 <= '1';
				       	EnablePC <= '1';
				       	next_state <= Fetch;
							
							
								when sta1 =>
						  Rs_onRside <= '0';
							Rplus0 <= '1';
							RFright_on_OpndBus <= '1';
		         	ALUsel <= "01010";
							ALUout_on_Databus <= '1';
							writemem <= '1';
							next_state <= sta2;
						
																when sta2 =>
						  Rs_onRside <= '0';
							Rplus0 <= '1';
							RFright_on_OpndBus <= '1';
		         	ALUsel <= "01010";
							ALUout_on_Databus <= '1';
							--writemem <= '1';
							next_state <= sta3;
							
							when sta3 =>
							   Rs_onRside <= '0';
							Rplus0 <= '1';
							RFright_on_OpndBus <= '1';
		          ALUsel <= "01010";
							ALUout_on_Databus <= '1';
							next_state <= sta4;
							
						when sta4 =>
						  
						  IF (ShadowE = '1') THEN
								next_state <= Execute2;
							ELSE 
								next_state <= PCplusOne;
							END IF;
							
				

						WHEN OTHERS => next_state <= reset;
				END CASE;
			END PROCESS;
		END ARCHITECTURE;