LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity generic_reg is
	PORT( D: IN SIGNED(10 DOWNTO 0);
	      LD, SH, CLOCK, RESET: IN STD_LOGIC;
	      N : IN NATURAL;
	      Q: OUT SIGNED(10 DOWNTO 0));
end generic_reg;

architecture behavior of generic_reg is


BEGIN
PROCESS (CLOCK,RESET) 
	BEGIN	
		IF (RESET = '1') THEN
		    Q <= (OTHERS => '0');

		ELSE
			IF (CLOCK = '1' AND CLOCK'EVENT) THEN
				IF ( LD = '1' AND SH = '0') THEN	    -- LOAD FUNCTIONALITY
		    			Q <= D;

				ELSIF (LD = '0' AND SH = '1') THEN      -- RIGHT 2'S COMP SHIFTING FUNCTIONALITY
					
					IF (N = 1) THEN
						Q(9 DOWNTO 0) <= D(10 DOWNTO 1);  	
						Q(10) <= D(10);
				
					ELSE
						Q(8 DOWNTO 0) <= D(10 DOWNTO 2);
						Q(10 DOWNTO 9) <= D(10) & D(10);
						
					END IF;

				ELSIF (LD = '1' AND SH = '1') THEN
					
					IF (N = 1) THEN
						Q(10 DOWNTO 1) <= D(9 DOWNTO 0); 	-- LEFT 2'S COMP SHIFTING FUNCTIONALITY
						Q(0) <= '0'; 	

					ELSE
						Q(10 DOWNTO 2) <= D(8 DOWNTO 0);
						Q(1 DOWNTO 0) <= "00";
		
					END IF;
	
				END IF;
				
			END IF;
END IF;
END process;	

END behavior;