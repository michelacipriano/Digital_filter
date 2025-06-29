LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY saturator IS
	PORT(EN: IN STD_LOGIC;
	     inp: IN SIGNED (10 DOWNTO 0);
	     outp : OUT SIGNED (7 DOWNTO 0));
END saturator;

ARCHITECTURE behavior of saturator IS
BEGIN
PROCESS(inp, EN)
BEGIN
IF (EN = '1') THEN
	IF (inp(10) = '0') THEN
		IF (inp (9) = '1') OR (inp(8) = '1') OR (inp(7) = '1') THEN
			outp <= "01111111";
		ELSE
			outp <= inp (7 DOWNTO 0);
		END IF;
	ELSE
		IF (inp (9 DOWNTO 7) = "111") THEN
			outp <= inp (7 DOWNTO 0);
		ELSE
			outp <= "10000000";
		END IF;
	END IF;
ELSE
	outp <= (OTHERS => '0');
END IF;
	
END PROCESS;
END behavior;
