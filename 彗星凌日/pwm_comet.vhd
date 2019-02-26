library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
---------------------------------------
entity pwm_comet is
	port(		CK	:in	std_logic;
				L	:buffer std_logic_vector(5 downto 0);
				DD	:buffer std_logic_vector(3 downto 0);
				N	:buffer std_logic		);
				
	end;
--------------------------------------
architecture ARCH of pwm_comet is
signal	T:std_logic_vector(5 downto 0);
signal	FF:std_logic_vector(9 downto 0);
signal	TT:std_logic_vector(5 downto 0);
signal	S:std_logic_vector(1 downto 0);
signal	CC:std_logic_vector(2 downto 0);
signal	AA:std_logic_vector(20 downto 0);
signal   a,b,c,d,e,f:std_logic;
begin
process(CK)
begin
		DD<="0000";
		N<='1';
	if rising_edge(CK) then	
		if FF="1111111111" then FF<="0000000001"; else FF<=FF(8 downto 0) & '1'; end if;
	end if;	


		a<='0';
		b<=FF(7);
		c<=FF(3);
		d<=FF(0); e<=FF(0); f<=FF(0); 
	
		
	if rising_edge(CK) then	
		AA<=AA+1;
	end if;	
	
	if rising_edge(CK) then	
			if (AA=0) then CC<=CC+1; end if;			
							case CC is 
								when "000" => L<=a&b&c&d&e&f; 
								when "001" => L<=b&c&d&e&f&a;  
								when "010" => L<=c&d&e&f&a&b; 
								when "011" => L<=d&e&f&a&b&c; 
								when "100" => L<=e&f&a&b&c&d; 
								when "101" => L<=f&a&b&c&d&e; CC<="000";
								when others =>null;
							end case;	
							
	end if;		

end process;
end ARCH;