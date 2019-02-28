library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-------------------------------------------------
entity seg_8X8X2 is
	port(	RESET,CK_7_SEG :in std_logic;
			SWG_R7, SWG_R6, SWG_R5, SWG_R4, SWG_R3, SWG_R2, SWG_R1, SWG_R0 :in std_logic_vector(7 downto 0);
			SWG_G7, SWG_G6, SWG_G5, SWG_G4, SWG_G3, SWG_G2, SWG_G1, SWG_G0 :in std_logic_vector(7 downto 0);
			SEGR :buffer std_logic_vector(7 downto 0);
			SEGG :buffer std_logic_vector(7 downto 0);
			CH8X8 :buffer std_logic_vector(7 downto 0)
		);
end seg_8X8X2;			
-------------------------------------------------
architecture A of seg_8X8X2 is
signal	SEGS_R,SEGS_G	: std_logic_vector(2 downto 0);
signal	SEGCHANG: std_logic_vector(3 downto 0);
begin
process(CK_7_SEG)
begin
--	if RESET = '0' then 
--		else 
		if rising_edge(CK_7_SEG) then	
					
			 case SEGS_R is 
				 when "000" => CH8X8<="01111111"; SEGR<=SWG_R0; SEGS_R<="001";
				 when "001" => CH8X8<="10111111"; SEGR<=SWG_R1; SEGS_R<="010";
				 when "010" => CH8X8<="11011111"; SEGR<=SWG_R2; SEGS_R<="011";
				 when "011" => CH8X8<="11101111"; SEGR<=SWG_R3; SEGS_R<="100";
				 when "100" => CH8X8<="11110111"; SEGR<=SWG_R4; SEGS_R<="101";
				 when "101" => CH8X8<="11111011"; SEGR<=SWG_R5; SEGS_R<="110";
				 when "110" => CH8X8<="11111101"; SEGR<=SWG_R6; SEGS_R<="111";
				 when "111" => CH8X8<="11111110"; SEGR<=SWG_R7; SEGS_R<="000";
			 end case;
			 
			 case SEGS_G is 
				 when "000" => CH8X8<="01111111"; SEGG<=SWG_G0; SEGS_G<="001";
				 when "001" => CH8X8<="10111111"; SEGG<=SWG_G1; SEGS_G<="010";
				 when "010" => CH8X8<="11011111"; SEGG<=SWG_G2; SEGS_G<="011";
				 when "011" => CH8X8<="11101111"; SEGG<=SWG_G3; SEGS_G<="100";
				 when "100" => CH8X8<="11110111"; SEGG<=SWG_G4; SEGS_G<="101";
				 when "101" => CH8X8<="11111011"; SEGG<=SWG_G5; SEGS_G<="110";
				 when "110" => CH8X8<="11111101"; SEGG<=SWG_G6; SEGS_G<="111";
				 when "111" => CH8X8<="11111110"; SEGG<=SWG_G7; SEGS_G<="000";
			 end case;
			
		 end if; 
			 
--	end if; --RESET		 	
end process;
end A;						
				