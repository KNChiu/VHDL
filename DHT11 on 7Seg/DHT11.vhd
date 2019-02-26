library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-------------------------------------------------
entity DHT11 is
	port(	RESET,CK :in std_logic;
			DHTL	:inout std_logic;
			LED1,LED2:buffer std_logic_vector(7 downto 0);
			-----------------------------------------------
			CH		:buffer std_logic_vector(3 downto 0);
			SEGOUT	:buffer std_logic_vector(7 downto 0)
			);
end DHT11;			
-------------------------------------------------
architecture A of DHT11 is
signal	COT :integer range 0 to 60000000;
signal	DHTS:integer range 0 to 8;
signal	DHTR	:std_logic_vector(0 to 40);
signal	i:integer range 0 to 40;
signal	TP	:std_logic_vector(7 downto 0);
signal	HD	:std_logic_vector(7 downto 0);
-------------------------------------------------
signal	CLK:std_logic_vector(20 downto 0);
signal	CK1:std_logic;
signal	CHA1,CHA2:integer range 0 to 2;
signal	HDB,TPB:std_logic_vector(7 downto 0);
signal	CHAC,CHAD:std_logic_vector(3 downto 0);
signal	CH3,CH2,CH1,CH0:std_logic_vector(3 downto 0);
signal	CHC	:std_logic_vector(1 downto 0);
signal	SEGCHANG:std_logic_vector(3 downto 0);

-------------------------------------------------
begin
process(CK)
begin

	if RESET ='0' then DHTL<='Z'; COT<=0; DHTS<=0; i<=0; TP<="00000000"; HD<="00000000";
		else if rising_edge(CK) then
				
				CLK<=CLK+'1';
				CK1<=CLK(14);
				
				case DHTS is
-------------------------------------------------------------------------------------------------初始化				
					when 0 => DHTL<='Z'; COT<=0; DHTS<=0; i<=0; --TP<="00000000"; HD<="00000000"; 
							  if COT = 60000000 then 											--延遲1S以上
								COT<=0; DHTS<=1; 
							  else 
								COT<=COT+1;
							  end if;
							  
					when 1 => if COT = 1000000 then 				   							--延遲20uS
								COT<=0; DHTS<=2; DHTL<='Z';
							  else 
								COT<=COT+1; DHTL<='0';
							  end if;							    
					when 2 => if DHTL = '0' then												--偵測是否有80us的LOW訊號
								DHTS<=3;
							  end if;							
					when 3 => if DHTL = '1' then 												--偵測是否有80us的HIGH訊號
									DHTS<=4;
								end if;
------------------------------------------------------------------------------------------------儲存資料的迴圈									
					when 4 => if DHTL = '0' then											  	--偵測是否有50us的LOW電位(資料間隔)
								DHTS<=5;
							  end if;			
					when 5 => if DHTL = '1' then 												--偵測是否有HIGH的上升觸發
									DHTS<=6;
							  end if;															  
					when 6 => if COT = 2500 then												--延遲50us
								COT<=0; DHTS<=7;
							  else 
								COT<=COT+1;
							  end if;
					when 7 => 
							  if i > 40 then													--將延遲後所讀到的資料存入 
								i<=0; DHTS<=8;
							  else 
								i<=i+1; DHTS<=4; DHTR(i)<=DHTL;
							  end if;
							  
					when 8 => DHTS<=0;
							 HD  <= (DHTR(1) & DHTR(2) & DHTR(3) & DHTR(4) & DHTR(5) & DHTR(6) & DHTR(7) & DHTR(8));		--濕度
							 TP  <= (DHTR(17) & DHTR(18) & DHTR(19) & DHTR(20) & DHTR(21) & DHTR(22) & DHTR(23) & DHTR(24));--溫度
							 	
				end case;
				LED1<= not TP;
				case CHA1 is
					when 0 => HDB<=HD; CHA1<=1; CHAC<="0000";
					when 1 => if HDB > "1001" then 
								HDB<=HDB-"1001"; CHAC<=CHAC+'1';
							  else 
								CHA1<=2;
							  end if;
					when 2 => CHA1<=0; CH3<=CHAC; CH2<=HDB(3 downto 0);
				end case;
				case CHA2 is
					when 0 => TPB<=TP; CHA2<=1; CHAD<="0000";
					when 1 => if (TPB > "1001") then 
								TPB<=TPB-"1001"; CHAD<=CHAD+'1';
							  else 
								CHA2<=2;
							  end if;
					when 2 => CHA2<=0; CH1<=CHAD; CH0<=TPB(3 downto 0);
				end case;
			end if;--CK
			
			if rising_edge(CK1) then			
				 case CHC is 
					 when "00" => CH<="0111"; SEGCHANG<=CH3; CHC<="01"; 
					 when "01" => CH<="1011"; SEGCHANG<=CH2; CHC<="10";
					 when "10" => CH<="1101"; SEGCHANG<=CH1; CHC<="11";
					 when "11" => CH<="1110"; SEGCHANG<=CH0; CHC<="00";
					 when others =>null;
				 end case;
			end if; --CK1
			
			case SEGCHANG is 
					when "0000" =>SEGOUT<="00000011";--0 --BCD 轉換
					when "0001" =>SEGOUT<="10011111";--1
					when "0010" =>SEGOUT<="00100101";--2
					when "0011" =>SEGOUT<="00001101";--3
					when "0100" =>SEGOUT<="10011001";--4
					when "0101" =>SEGOUT<="01001001";--5
					when "0110" =>SEGOUT<="01000001";--6
					when "0111" =>SEGOUT<="00011111";--7
					when "1000" =>SEGOUT<="00000001";--8
					when "1001" =>SEGOUT<="00001001";--9
					when others =>null;
			end case;
					
				 
		end if;--RESET					  	
								
end process;
end A;	