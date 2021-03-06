library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-------------------------------------------------
entity Helicopter is
	port(	CK,RESET,FLY_UP :in std_logic;
			
			SEGR :buffer std_logic_vector(7 downto 0);
			SEGG :buffer std_logic_vector(7 downto 0);
			CH8X8:buffer std_logic_vector(7 downto 0)
		);
end Helicopter;			
-------------------------------------------------
architecture A of Helicopter is
signal	CLKCONT:std_logic_vector(25 downto 0);
signal	BACK,BACK_GROUND:std_logic_vector(7 downto 0);
signal	CK_7_SEG,SEC_1S,SEC_20mS,CLK,BACK_WHIT:std_logic;
signal	HeliS,HeliS_FLY,BACK_MAKE,FLASH,FIND_I,CHACK:integer range 0 to 7;
signal	FLY_BOTTEN:integer range 0 to 1;
signal	SWG_R7,SWG_R6,SWG_R5,SWG_R4,SWG_R3,SWG_R2,SWG_R1,SWG_R0,
		SWG_G7,SWG_G6,SWG_G5,SWG_G4,SWG_G3,SWG_G2,SWG_G1,SWG_G0:std_logic_vector(7 downto 0);
type ram_8X8 is array(7 downto 0) of std_logic_vector(7 downto 0);
signal	SWG_R_ram,SWG_G_ram:ram_8X8;
type ram_background is array(7 downto 0) of std_logic_vector(7 downto 0);
constant BACKGROUND:ram_background:=( X"83",X"81",X"E5",X"C1",X"C3",X"93",X"83",X"E1"
--									  X"E1",X"C3",X"C7",X"83",X"83",X"C1",X"E7",X"C7",
--									  X"E7",X"83",X"87",X"C3",X"81",X"E1",X"E7",X"C1",
--									  X"C1",X"8B",X"C1",X"93",X"C1",X"C3",X"89",X"C1"
--									  X"F3",X"E7",X"CF",X"9F",X"CF",X"CF",X"9F",X"9F",
--									  X"F3",X"E7",X"CF",X"9F",X"CF",X"CF",X"9F",X"9F"
										);
signal	SEC_1S_CONT,SEC_20mS_CONT,SEC_3S_CONT,CONT_BACK,SEC_DOWM_CONT,SEC_FLASH_CONT,BACKGROUND_SEC:integer range 0 to 50000000;
-------------------------------------------------
component seg_8X8X2 is
	port(	RESET,CK_7_SEG :in std_logic;
			SWG_R7, SWG_R6, SWG_R5, SWG_R4, SWG_R3, SWG_R2, SWG_R1, SWG_R0 :in std_logic_vector(7 downto 0);
			SWG_G7, SWG_G6, SWG_G5, SWG_G4, SWG_G3, SWG_G2, SWG_G1, SWG_G0 :in std_logic_vector(7 downto 0);
			SEGR :buffer std_logic_vector(7 downto 0);
			SEGG :buffer std_logic_vector(7 downto 0);
			CH8X8 :buffer std_logic_vector(7 downto 0)
		);
end component seg_8X8X2;		
-------------------------------------------------
begin
process(CK)
begin
	
	if rising_edge(CK) then
		CLKCONT<=CLKCONT+'1';
	end if;	--CK
		
		CK_7_SEG<=CLKCONT(15);
	if rising_edge(CK) then
		if SEC_20mS_CONT = 499999 then
			SEC_20mS_CONT <= 0; SEC_20mS <= not SEC_20mS;
		else
			SEC_20mS_CONT <= SEC_20mS_CONT + 1;
		end if;
	end if;
	
	if rising_edge(SEC_20mS) then
		case HeliS is
			when 0=>
					HeliS <= 1;
					BACKGROUND_SEC <= 99;
					SWG_R_ram(7) <= "00000000"; SWG_R_ram(6) <= "00010000"; SWG_R_ram(5) <= "00000000"; SWG_R_ram(4) <= "00000000";
					SWG_R_ram(3) <= "00000000"; SWG_R_ram(2) <= "00000000"; SWG_R_ram(1) <= "00000000"; SWG_R_ram(0) <= "00000000";
					SWG_G_ram(7) <= BACKGROUND(7); SWG_G_ram(6) <= BACKGROUND(6); SWG_G_ram(5) <= BACKGROUND(5); SWG_G_ram(4) <= BACKGROUND(4);
					SWG_G_ram(3) <= BACKGROUND(3); SWG_G_ram(2) <= BACKGROUND(2); SWG_G_ram(1) <= BACKGROUND(1); SWG_G_ram(0) <= BACKGROUND(0);
--					SWG_G_ram(7) <= X"E1"; SWG_G_ram(6) <= X"C3"; SWG_G_ram(5) <= X"C7"; SWG_G_ram(4) <= X"83";
--					SWG_G_ram(3) <= X"83"; SWG_G_ram(2) <= X"C1"; SWG_G_ram(1) <= X"E7"; SWG_G_ram(0) <= X"C7";
			when 1=>
					if (SWG_R_ram(6) and SWG_G_ram(6)) /= "00000000" then
						HeliS <=2; CHACK <= 0;
					else
						if SEC_3S_CONT = BACKGROUND_SEC then
							SEC_3S_CONT <= 0;
							
							SWG_G_ram(0) <= BACKGROUND(CONT_BACK);
							
							if CONT_BACK = 7 then
								CONT_BACK <= 0; BACKGROUND_SEC <= BACKGROUND_SEC * 9 / 10;
							else
								CONT_BACK <= CONT_BACK + 1;
							end if;
							
							SWG_G_ram(1) <=SWG_G_ram(0); SWG_G_ram(2) <=SWG_G_ram(1); SWG_G_ram(3) <=SWG_G_ram(2); 
							SWG_G_ram(4) <=SWG_G_ram(3); SWG_G_ram(5) <=SWG_G_ram(4); SWG_G_ram(6) <=SWG_G_ram(5); SWG_G_ram(7) <=SWG_G_ram(6);
						else
							SEC_3S_CONT <= SEC_3S_CONT + 1;
							if SEC_DOWM_CONT = 49 then
								SEC_DOWM_CONT <= 0;	
								if SWG_R_ram(6)(0) = '1' then
												
								else
									SEC_DOWM_CONT <= 0; SWG_R_ram(6) <= SWG_R_ram(6)(0)&SWG_R_ram(6)(7 downto 1);
								end if;
							else
								SEC_DOWM_CONT <= SEC_DOWM_CONT + 1;
								case FLY_BOTTEN is
									when 0=>
											if FLY_UP = '0' then
												SEC_DOWM_CONT <= 0;
												if SWG_R_ram(6)(7) = '1' then
												
												else
													SWG_R_ram(6) <= SWG_R_ram(6)(6 downto 0)&SWG_R_ram(6)(7);
												end if;
												FLY_BOTTEN <= 1;
											end if;
									when 1=>
											if FLY_UP = '1' then
												FLY_BOTTEN <= 0;
											end if;
								end case;
							end if;
						end if;
					end if;
			when 2=>
					case CHACK is
						when 0=>
								if FIND_I >= 7 then	
									FIND_I <= 0; HeliS <= 0;
								else
									if SWG_R_ram(6)(FIND_I) = '1' then
										CHACK <= 1;
									else
										FIND_I <= FIND_I + 1;
									end if;
								end if;
						when 1=>
								if SEC_FLASH_CONT = 24 then
									SEC_FLASH_CONT <= 0; 
									if FLASH = 5 then
										CHACK <= 0; FIND_I <= 0; FLASH <= 0; HeliS <= 0;
									else
										FLASH <= FLASH + 1;
										SWG_R_ram(6)(FIND_I) <= not SWG_R_ram(6)(FIND_I);
									end if;
								else
									SEC_FLASH_CONT <= SEC_FLASH_CONT + 1; 
								end if;
						when others=>null;
					end case;
			when others=> null;
		end case;
	end if;
		SWG_R7 <= SWG_R_ram(7); SWG_R6 <= SWG_R_ram(6); SWG_R5 <= SWG_R_ram(5); SWG_R4 <= SWG_R_ram(4);
		SWG_R3 <= SWG_R_ram(3); SWG_R2 <= SWG_R_ram(2); SWG_R1 <= SWG_R_ram(1); SWG_R0 <= SWG_R_ram(0);
		SWG_G7 <= SWG_G_ram(7); SWG_G6 <= SWG_G_ram(6); SWG_G5 <= SWG_G_ram(5); SWG_G4 <= SWG_G_ram(4);
		SWG_G3 <= SWG_G_ram(3); SWG_G2 <= SWG_G_ram(2); SWG_G1 <= SWG_G_ram(1); SWG_G0 <= SWG_G_ram(0);
-----------------------------------------------------------------------------------------------------------------------------------------------------------		 	
end process;
			u0:seg_8X8X2
				port map
				(
				 RESET=>RESET,
				 CK_7_SEG=>CK_7_SEG,
				 SEGR=>SEGR, SEGG=>SEGG, CH8X8=>CH8X8,
				 
				 SWG_R7=>SWG_R7, SWG_R6=>SWG_R6, SWG_R5=>SWG_R5, SWG_R4=>SWG_R4, SWG_R3=>SWG_R3, SWG_R2=>SWG_R2, SWG_R1=>SWG_R1, SWG_R0=>SWG_R0,
				 SWG_G7=>SWG_G7, SWG_G6=>SWG_G6, SWG_G5=>SWG_G5, SWG_G4=>SWG_G4, SWG_G3=>SWG_G3, SWG_G2=>SWG_G2, SWG_G1=>SWG_G1, SWG_G0=>SWG_G0
				); 
	
end A;						
				