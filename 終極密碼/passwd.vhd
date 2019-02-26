library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
-----------------------------------
Entity passwd	is
	port(		
				CK	:in	std_logic;
				Ki	:in   std_logic_vector(3 downto 0);
				KO	:buffer std_logic_vector(3 downto 0);
				D	:buffer std_logic_vector(3 downto 0);
				L	:buffer std_logic_vector(6 downto 0)
	);
	
end;
------------------------------------------------------------------
architecture ARCH of passwd is
signal	S	:std_logic_vector(1 downto 0);
signal	SSM,SBI	:integer range 0 to 4;
signal	SK	:integer range 1 to 2;
signal	PA	:integer range 0 to 8192;
signal	PB	:integer range 1 to 8192;
signal	PC	:integer range 1 to 8192;
signal	PD	:integer range 1 to 8192;
signal	TT	:integer range 0 to 1000;
signal	T	:integer range 0 to 9999;
signal	CCC:std_logic_vector(1 downto 0);
signal	C3,C2,C1,C0:integer range 0 to 9999;
signal	N	:integer range 1 to 81;
signal	NN	:integer range 1 to 81;
signal	a,b,c	:integer range 0 to 9;
signal	Q0,Q1,Q2,Q3	:integer range 0 to 9;
signal	CC	:integer range 1 to 5;
signal	CKS	:std_logic_vector(23 downto 0);
signal	CK1:std_logic;
signal	CK2:std_logic;
signal	LO	:integer range 0 to 9;
signal	KEY:std_logic_vector(4 downto 0);

type ram_reg is array(12 downto 0)of integer range 1 to 8192;
signal	  i:integer range 0 to 12;
signal	BAQ:ram_reg;
signal	BAR:integer range 0 to 12;
signal	 WR:std_logic;

begin
process(CK)
begin
		
	if rising_edge(CK)	then
		CKS<=CKS+1;
	end if;
	
	CK1<=CKS(15);

	
	
--------------------------------------------------------------------------------------	
	if rising_edge(CK1)	then
		case s is
			when "00" =>S<="01";KEY<="10000";
			when "01" =>if Ki/="1111" then S<="10"; KO<="1110"; KEY<="00000"; end if;
			when "10"=>if Ki ="1111" then KO<=KO(2 downto 0)&'1'; KEY<=KEY+1;
						 else S<="11"; if Ki(3)='1' then KEY(3 downto 2)<=not Ki(2 downto 1);
										else KEY(3 downto 2)<="11";end if;		 
						end if;
			when "11"=> if Ki="1111" then S<="01"; KO<="0000"; end if;	
							KEY<="10000"; 					
		end case;
	end if;	
---------------------------------------------------------------------------------------	
	if rising_edge(CK1)	then
		case SK is 
			when 1 =>PA<=0; PB<=1; PC<=8192; SK<=2; BAR<=0; WR<='1';
			when 2 =>WR<='0';
				if KEY ="01100" then PA<=8192; PB<=1; PC<=8192; BAR<=0; WR<='1';
					else if KEY="01111" 
							then PC<=BAQ(i-1); 
							BAR<=BAR-1;
								else
								case SBI is
									when 0 => if KEY="01101" then SBI<=1; end if;
									when 1 => SBI<=2; PB<=PC; BAR<=BAR+1;
									when 2 => PC<=PA+PC; SBI<=3;
									when 3 => PC<=PC/2; SBI<=4; WR<='1';
									when 4 => if KEY="01101" then  else SBI<=0; WR<='0'; end if;
								end case; 
								case SSM is
									when 0 => if KEY="01110" then SSM<=1;end if;
									when 1 => SSM<=2; PA<=PC; BAR<=BAR+1;
									when 2 => PC<=PB+PC; SSM<=3;
									when 3 => PC<=PC/2; SSM<=4; WR<='1';
									when 4 => if KEY="01110" then  else SSM<=0; WR<='0'; end if;
								end case;
							end if;	
				end if;	
		end case;		
	end if;		
----------------------------------------------------------------------------------------
	
	i<=BAR;
	
	if rising_edge(CK1)	then	
		if WR='1' then 
			BAQ(i)<=PC;
		end if;
	end if;	
		
-----------------------------------------------------------------------------------------	
	if rising_edge(CK)	then	
		case CC is 
			when 1 => CC<=2; a<=0; b<=0; c<=0; c0<=PC;
			when 2 => if c0>=1000  then c0<=c0-1000; a<=a+1; else CC<=3;end if;
			when 3 => if c0>=100  then c0<=c0-100;  b<=b+1; else CC<=4;end if;
			when 4 => if c0>=10   then c0<=c0-10;   c<=c+1; else CC<=5;end if;
			when 5 => Q0<=c0; Q1<=c; Q2<=b; Q3<=a; CC<=1;
		end case;
	end if;	
	
	if rising_edge(CK1)	then
		case CCC is 
				when "00" =>	D<="1110"; CCC<="01"; LO<=Q0;
				when "01" =>	D<="1101"; CCC<="10"; LO<=Q1;
				when "10" => 	D<="1011"; CCC<="11"; LO<=Q2;
				when "11" =>   D<="0111"; CCC<="00"; LO<=Q3;
			end case;
	end if;
	
	case LO is
	   when 0 => L<="0000001";
	   when 1 => L<="1001111";
	   when 2 => L<="0010010";
	   when 3 => L<="0000110";
	   when 4 => L<="1001100";
	   when 5 => L<="0100100";
	   when 6 => L<="0100000";
	   when 7 => L<="0001101";
	   when 8 => L<="0000000";
	   when 9 => L<="0001100";
	end case;
-----------------------------------------------------------------------------------------
		
	
end process;
end ARCH;	
	