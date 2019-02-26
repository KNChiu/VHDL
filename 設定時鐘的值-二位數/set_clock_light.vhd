library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
-----------------------------------
Entity set_clock_light	is
	port(		CK	:in	std_logic;
				RE	:in  std_logic;
				CU	:in  std_logic;
				ST	:in  std_logic;
				
				FF :buffer std_logic;
				F  :buffer std_logic_vector(6 downto 0);
				D  :buffer std_logic_vector(3 downto 0)
	);
	
end;
-----------------------------------
architecture ARCH of set_clock_light is

signal	CH :std_logic;
signal	CK1:std_logic;
signal	CLK:std_logic_vector(24 downto 0);


---------this is for clock----------
signal	HS	:std_logic;
signal	S	:std_logic_vector(5 downto 0);
signal	M	:std_logic_vector(5 downto 0);
signal	H	:std_logic_vector(5 downto 0);
---------this is for clock----------
-----------BIN=>BCD-----------------
signal	CLT	:integer range 0 to 255;
signal	HQ	:std_logic_vector(5 downto 0);
signal	HD	:std_logic_vector(3 downto 0);
signal	HB	:integer range 0 to 2;
signal	MQ	:std_logic_vector(5 downto 0);
signal	MD	:std_logic_vector(3 downto 0);
signal	MB	:integer range 0 to 2;
signal	SQ	:std_logic_vector(5 downto 0);
signal	SD	:std_logic_vector(3 downto 0);
signal	SB	:integer range 0 to 2;
signal	S1	:std_logic_vector(3 downto 0);
signal	M1  :std_logic_vector(3 downto 0);
signal	H1	:std_logic_vector(3 downto 0);
signal	S0	:std_logic_vector(3 downto 0);
signal	M0	:std_logic_vector(3 downto 0);
signal	H0	:std_logic_vector(3 downto 0);
-----------BIN=>BCD-----------------
--7 seg hour and minute and second--
signal	Q	:std_logic_vector(3 downto 0);
signal	CHMS:integer range 0 to 1;
signal	HMS	:std_logic;
signal	HM	:integer range 0 to 3;
signal	MS	:integer range 0 to 3;
--7 seg hour and minute and second--
-------------butten up--------------
signal	   T:integer range 0 to 500;
signal	STS	:std_logic;
signal	SSTS:integer range 0 to 1;
signal	CST	:integer range 0 to 2;
signal	HMST:integer range 1 to 3;
signal	CUH	:integer range 0 to 1;
signal	CUM	:integer range 0 to 1;
-------------butten up--------------
-------------blight two-------------
signal	C1	:std_logic_vector(1 downto 0);
signal	C2	:std_logic_vector(1 downto 0);
signal	C3	:std_logic_vector(1 downto 0);
signal	CT	:integer range 0 to 20;
signal	MCUS	:integer range 0 to 2;
-------------blight two-------------

begin
process(CK)
begin

	if rising_edge(CK)	then
		CLK<=CLK+1;
	end if;
	
	CK1<=CLK(16);
	HS<=CLK(24);
	
-----------------------------this is for clock--------------------------------------------	

if RE ='0' then HB<=0; HMS<='0'; CST<=0; HMST<=1; MCUS<=0; H<="000000"; M<="000000"; S<="000000"; STS<='0'; HB<=0; MB<=0; SB<=0;
	else 
	if rising_edge(CK1)	then
		if STS='0' then 
		if (CLT=0) then CLT<=255;
			if (S<59) then S<=S+1; 	
						else S<="000000";
				if  (M<59) then M<=M+1;
							else M<="000000";
					if (H<23) then H<=H+'1';
								else H<="000000";
					end if;--H
				end if;--M
			end if;--S
						else CLT<=CLT-1;
		end if;--CLT	
		end if;--STS
		
-----------------------------this is for clock-------------------------------------------
----------------------------------BIN=>BCD-----------------------------------------------
	--if rising_edge(CK1)	then

		case HB is
			when 0 => HQ<=H; HD<="0000"; HB<=1;
			when 1 => if (HQ<10) then HB<=2; else HQ<=HQ-"1010"; HD<=HD+1; end if;
			when 2 => H0<=HQ(3 downto 0); H1<=HD; HB<=0;
		end case;	 
		case MB is
			when 0 => MQ<=M; MD<="0000"; MB<=1;
			when 1 => if (MQ<10) then MB<=2; else MQ<=MQ-"1010"; MD<=MD+1; end if;
			when 2 => M0<=MQ(3 downto 0); M1<=MD; MB<=0;
		end case;	
		case SB is
			when 0 => SQ<=S; SD<="0000"; SB<=1;
			when 1 => if (SQ<10) then SB<=2; else SQ<=SQ-"1010"; SD<=SD+1; end if;
			when 2 => S0<=SQ(3 downto 0); S1<=SD; SB<=0;
		end case;	
		
--	end if;	
----------------------------------BIN=>BCD-----------------------------------------------
---------------------------7 seg hour and minute and second-----------------------------------------------------	
--	if rising_edge(CK1)	then
		if STS='0' then	
			case CHMS is
				when 0 =>if CU='0' then CHMS<=1; HMS<=not HMS; end if;
				when 1 =>if CU='1' then CHMS<=0; end if;
			end case;
			else HMS<='0';
		end if;
		
		case HMS is 
			when '1' =>case HM is 
						when 0 =>Q<=H1; D<="0111"; HM<=1; FF<='1';
						when 1 =>Q<=H0; D<="1011"; HM<=2; FF<=HS;
						when 2 =>Q<=M1; D<="1101"; HM<=3; FF<='1';
						when 3 =>Q<=M0; D<="1110"; HM<=0; FF<='1';
					 end case;
			when '0' =>case MS is 
						when 0 =>Q<=M1; D<="0111"; MS<=1; FF<='1';
						when 1 =>Q<=M0; D<="1011"; MS<=2; FF<='1';
						when 2 =>Q<=S1; D<="1101"; MS<=3; FF<='1';
						when 3 =>Q<=S0; D<="1110"; MS<=0; FF<='1';
					 end case;	
		end case;
		
	
--	end if;				 	 	
---------------------------7 seg hour and minute and second-----------------------------------------------------
-----------------------------------------butten up--------------------------------------------------------------
--	if rising_edge(CK1)	then
	case SSTS is
		when 0=>if ST='0' then SSTS<=1; STS<='1'; end if;
		when 1=>
				case CST is 
					when 0 =>if ST='0' then CST<=1; end if;
					when 1 =>CST<=2; if (HMST>2) then HMST<=1; STS<='0';  else HMST<=HMST+1; end if;
					when 2 =>if ST='1' then CST<=0; SSTS<=0; end if;
				end case;
	end case;
--	end if;						
-----------------------------------------butten up--------------------------------------------------------------
----------------------------------------blight two--------------------------------------------------------------
--	if rising_edge(CK1)	then
	if STS ='1' then
		case HMST is
			when 1 =>MCUS<=0;
					case C1 is 
						when "00" => D<="0111"; C1<="01"; Q<=H1;
						when "01" => D<="1011"; C1<="10"; Q<=H0;
						when "10" => D<="1101"; C1<="11"; Q<=M1; 
						when "11" => D<="1110"; C1<="00"; Q<=M0;   	
					end case; 
			when 2 =>MCUS<=1;
					case C2 is 
						when "00" => D<="0111"; C2<="01"; CT<=CT+1; if (CT>5) then Q<=H1; else if (CT>10) then  Q<="1111"; CT<=0; else Q<="1111"; end if; end if;
						when "01" => D<="1011"; C2<="10"; CT<=CT+1; if (CT>5) then Q<=H0; else if (CT>10) then  Q<="1111"; CT<=0; else Q<="1111"; end if; end if;
						when "10" => D<="1101"; C2<="11"; Q<=M1; 
						when "11" => D<="1110"; C2<="00"; Q<=M0;   	
					end case; 
			when 3 => MCUS<=2;
					case C3 is
						when "00" => D<="0111"; C3<="01"; Q<=H1;
						when "01" => D<="1011"; C3<="10"; Q<=H0;
						when "10" => D<="1101"; C3<="11"; CT<=CT+1; if (CT>5) then Q<=M1; else if (CT>10) then  Q<="1111"; CT<=0; else Q<="1111"; end if; end if; 
						when "11" => D<="1110"; C3<="00"; CT<=CT+1; if (CT>5) then Q<=M0; else if (CT>10) then  Q<="1111"; CT<=0; else Q<="1111"; end if; end if;   	
					end case; 			
		end case;
	end if;--STS
--	end if;
----------------------------------------blight two--------------------------------------------------------------	
---------------------------------------butten set up------------------------------------------------------------				
--	if rising_edge(CK1)	then
		if STS='1' then 
			case MCUS is 
				when 0 =>H<=H; M<=M;
				when 1 =>
						case CUH is
							when 0=>if CU='0' then CUH<=1; T<=0; if (H>22) then H<="000000"; else H<=H+'1'; end if; end if;
							when 1=>if CU='1' then CUH<=0; 
										else if(T=350) then T<=300; if (H>22) then H<="000000"; else H<=H+'1'; end if;
												else T<=T+1; 
											 end if;
										 end if;
						end case;
				when 2 =>
						case CUM is
							when 0=>if CU='0' then CUM<=1; T<=0; if (M>58) then M<="000000"; else M<=M+'1'; end if; end if;
							when 1=>if CU='1' then CUM<=0; 
										else if(T=350) then T<=300; if (M>58) then M<="000000"; else M<=M+'1'; end if;
												else T<=T+1; 
											 end if;
										end if;
						end case;	
			end case;
		end if;
	end if;--CK1	
end if;--REST							  					
---------------------------------------butten set up------------------------------------------------------------		
---------------------------wold 0~9,Z----------------------------
	case Q is
		when "0000" =>F<="0000001";
		when "0001" =>F<="1001111";
		when "0010" =>F<="0010010";
		when "0011" =>F<="0000110";
		when "0100" =>F<="1001100";
		when "0101" =>F<="0100100";
		when "0110" =>F<="0100000";
		when "0111" =>F<="0001101";
		when "1000" =>F<="0000000";
		when "1001" =>F<="0001100";
		when "1111" =>F<="1111111";
		when others =>F<=null;
	end case;
---------------------------wold 0~F	----------------------------
--end if;--set

	
end process;
end ARCH;		