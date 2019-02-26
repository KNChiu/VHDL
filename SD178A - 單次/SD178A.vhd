library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
---------------------------------------
entity SD178A is
	port(	
			CK,RESET :in	std_logic;

			SDI,SCLK :out std_logic;
			LED:buffer std_logic;
			RDY :in std_logic
		);
end;
--------------------------------------
architecture ARCH of  SD178A is
signal	CK_DELAY:integer range 0 to 25000;
signal	BOOT_DELAY,DELAY:integer range 0 to 3000;
signal	CK_1K:std_logic;
signal	SDAS:integer range 0 to 9;
type RAM1 is array(0 to 1)of std_logic_vector(7 downto 0);  
signal	WORDRAM:RAM1;
signal	SUD_BUFFER:std_logic_vector(7 downto 0);
signal	WORD_CONT:integer range 7 downto -1;
signal	NUM:integer range 0 to 7;
--signal	i:integer range 0 to 6;
--signal	RSOUTDATA:std_logic_vector(6 downto 0);

begin
process(CK)
begin
	if rising_edge(ck) then
		if CK_DELAY = 24999 then
			CK_DELAY<=0; CK_1K<=not CK_1K;
		else 
			CK_DELAY<=CK_DELAY+1;
		end if;
	end if;
end process;

WORDRAM(0)<=X"30";
WORDRAM(1)<=X"31";

process(CK_1K)
begin
	
		if RESET = '0' then
			SCLK<='1'; SDI<='1'; SDAS<=0;
		else
		if rising_edge(CK_1K) then
			case SDAS is
				when 0=>
						SCLK<='1';
						SDI<='1';
						SDAS<=1;
--						WORD_CONT<=7; NUM<=0;
						
				when 1=>
						if BOOT_DELAY = 3000 then		--delay 3s
							BOOT_DELAY<=0; SDAS<=2;
						else 
							BOOT_DELAY<=BOOT_DELAY+1;
						end if;
				when 2=>
						if RDY = '0' then
							if NUM > 1 then
								NUM<=0;
								SDAS<=7;
							else
								NUM<=NUM+1;
								SUD_BUFFER<=WORDRAM(NUM)(7 downto 0);
								SDAS<=3; SCLK<='1';
							end if;
						end if;
						
				when 3=>
						SCLK<='1';
						if WORD_CONT < 0 then
							WORD_CONT<=7;
							SDAS<=6; SDI<='1';
						else
							SDI<=SUD_BUFFER(WORD_CONT);
							WORD_CONT<=WORD_CONT-1;
							SDAS<=4;
						end if;

				when 4=>
						SDAS<=5;
				when 5=>
						SDAS<=3;
						SCLK<='0';
				when 6=>
						if DELAY = 500 then	--0.5s
							DELAY<=0;
							SDAS<=2; LED<='0';
						else 
							DELAY<=DELAY+1;
						end if;
				when 7=>
						--SDAS<=2;
					
				when others=>
							SCLK<='1';
							SDI<='1';
						
			end case;--SDAS
		end if;--RESET
	end if;--CK_1K

end process;
end	ARCH;