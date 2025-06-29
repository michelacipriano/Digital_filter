LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY D_flip_flop is
	PORT ( D, CLK, CL: IN STD_LOGIC;
		Q: OUT STD_LOGIC);
end D_flip_flop;

Architecture Behavior of D_flip_flop is

SIGNAL Q_AUX: STD_LOGIC := '0';


BEGIN
PROCESS (CLK,CL,Q_AUX)
	BEGIN	
	if ((CLK = '1' AND CLK'EVENT)) THEN
		Q_AUX <= D;
	else Q_AUX <= Q_AUX;
	END IF;

	IF (CL = '1') THEN Q_AUX <= '0';
	END IF;
	
	Q <= Q_AUX;
	
END PROCESS;
END behavior;