LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY extender IS
	PORT(data : IN SIGNED (7 DOWNTO 0);
	extended_data : OUT SIGNED (10 DOWNTO 0));
END extender;

ARCHITECTURE behavior of extender IS
BEGIN
extended_data <= "111" & data WHEN data(7) = '1' ELSE 
		 "000" & data;
END behavior;

