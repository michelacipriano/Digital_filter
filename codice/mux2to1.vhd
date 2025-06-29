LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mux2 IS
	PORT(a, b : IN SIGNED(10 DOWNTO 0);
	inv : IN STD_LOGIC;
	c : OUT SIGNED (10 DOWNTO 0));
END mux2;

ARCHITECTURE behavior of mux2 IS
BEGIN
PROCESS(inv,a,b)
BEGIN
	IF (inv = '0') THEN
		c <= a;
	ELSE
		c <= b;
	END IF;
END PROCESS;
END behavior;
