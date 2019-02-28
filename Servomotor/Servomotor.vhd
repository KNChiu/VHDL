library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
-------------------------------------------------
entity Servomotor is
	port(	CK :in std_logic;
			SERVOOUT:buffer std_logic
		);
end Servomotor;			
-------------------------------------------------
architecture A of Servomotor is
signal CLK_DELAY,CLK_DELAY_1,TIME_1,TIME_2,TIME_3,TIME_4,SERVO_ANGLE_5 :integer range 0 to 49999999;
signal DELAY_0_2us,DELAY_1s:std_logic;
signal SERVO_S :integer range 0 to 3;
begin
process(CK)
begin
	
	SERVO_ANGLE_5 <= 18;
	
	if rising_edge(ck) then
		if CLK_DELAY = 4 then
			CLK_DELAY <= 0; DELAY_0_2us <= not DELAY_0_2us;
		else
			CLK_DELAY <= CLK_DELAY + 1;
		end if;
		
--		if CLK_DELAY_1 = 24999999 then
--			CLK_DELAY_1 <= 0; DELAY_1s <= not DELAY_1s;
--		else
--			CLK_DELAY_1 <= CLK_DELAY_1 + 1;
--		end if;
	end if;
	
	if rising_edge(DELAY_0_2us) then
		case SERVO_S is
			when 0=>
					if TIME_1 = 89999 then
						TIME_1 <= 0; SERVO_S <= 1;
					else
						TIME_1 <= TIME_1 + 1;
						SERVOOUT <= '0';
					end if;
			when 1=>
					SERVOOUT <= '1';
					if TIME_2 = 2499 then
						TIME_2 <= 0; SERVO_S <= 2;
					else
						TIME_2 <= TIME_2 + 1;
					end if;
			when 2=>
					if TIME_3 = 7500 then
						TIME_3 <= 0; TIME_4 <= 0; SERVO_S <= 0;
					else
						TIME_3 <= TIME_3 + 1;
						if TIME_4 = 208 * SERVO_ANGLE_5 then
							SERVOOUT <= '0';
							
						else
							TIME_4 <= TIME_4 + 1; 
							SERVOOUT <= '1';
						end if;
					end if;
			when others=>null;
		end case;
	end if;
	
--	if rising_edge(DELAY_1s) then 
--		if SERVO_ANGLE_5 = 36 then
--			SERVO_ANGLE_5 <= 0;
--		else
--			SERVO_ANGLE_5 <= SERVO_ANGLE_5 + 1;
--		end if;
--	end if;
	
end process;
end A;