LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CU IS
	PORT( START ,MEM_A_HAS_WRITTEN, CLOCK, RESET: IN STD_LOGIC;
		WR_A, RD_A, WR_B, RD_B, CS_A, CS_B, DONE, D, UPDATE_AD, RESET_SUM, EN_SAT: OUT STD_LOGIC;
		SH, LD: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		INV: OUT SIGNED;
		N_SHIFT: OUT NATURAL);
END CU;

ARCHITECTURE BEHAVIOR OF CU IS
TYPE STATE_TYPE IS (START_STATE, WRITING_A , READING_START, READING_A1 , READING_A2 ,  READING_A3,  READING_A4, 
		    DONE_STATE, ELABORATING_A1, ELABORATING_A2,  ELABORATING_A3, ELABORATING_A4, COMPLETING_SEQUENCE, 
		    PREP_TO_WRITING, WRITING_B);
SIGNAL CS_S: STATE_TYPE := START_STATE;
SIGNAL FS: STATE_TYPE;
SIGNAL NUMBER_OF_PROCESS: UNSIGNED (9 DOWNTO 0):= (OTHERS => '0');
SIGNAL W: STD_LOGIC := '1';

BEGIN

	
MEM: PROCESS(CLOCK, RESET)
BEGIN
	IF RESET = '1' THEN
		CS_S <= WRITING_A;
	ELSE

		IF (CLOCK = '1' AND CLOCK'EVENT) THEN
			CS_S <= FS;

		END IF;
	END IF;
END PROCESS MEM;

CC1: PROCESS(CS_S, START, MEM_A_HAS_WRITTEN, W)
	BEGIN
		CASE CS_S IS
			WHEN START_STATE =>
				IF (START = '1') THEN
					FS <= WRITING_A;
				ELSE
					FS <= START_STATE;
				END IF;

			WHEN WRITING_A =>
				IF (MEM_A_HAS_WRITTEN = '1') THEN
					FS <= READING_A1;
				ELSE
					FS <= WRITING_A;
				END IF;


			WHEN READING_A1 =>
				   IF ( W = '1') THEN
					FS <= ELABORATING_A1;
				    ELSE
					FS <= READING_A1;
				    END IF;

			WHEN ELABORATING_A1 =>
					IF (W = '1') THEN
					      FS <= READING_A2;
					ELSE
					      FS <= ELABORATING_A1;
					END IF;
			WHEN READING_A2 =>	
	
				IF ( W = '1') THEN
					FS <= ELABORATING_A2;
				ELSE
					FS <= READING_A2;
				END IF;

			WHEN ELABORATING_A2 =>
					IF (W = '1') THEN
					      FS <= READING_A3;
					ELSE
						 FS <= ELABORATING_A2;
					END IF;
			WHEN READING_A3 =>

				IF ( W = '1') THEN
					FS <= ELABORATING_A3;
				ELSE
					FS <= READING_A3;
				END IF;

			WHEN ELABORATING_A3 =>
					IF (W = '1') THEN
					      FS <= READING_A4;
					ELSE
						 FS <= ELABORATING_A3;
					END IF;
			
			WHEN READING_A4 =>
					IF ( W = '1') THEN
					FS <= ELABORATING_A4;
				ELSE
					FS <= READING_A4;
				END IF;

			WHEN ELABORATING_A4 =>
				IF (W = '1') THEN
					      FS <= COMPLETING_SEQUENCE;
					ELSE
						 FS <= ELABORATING_A4;
					END IF;
			WHEN COMPLETING_SEQUENCE =>
				IF (W = '1') THEN
					FS <= PREP_TO_WRITING;
				ELSE
					FS <= COMPLETING_SEQUENCE;
				END IF;

			WHEN PREP_TO_WRITING =>
					IF (W = '1') THEN
					FS <= WRITING_B;
				ELSE
					FS <= PREP_TO_WRITING;
				END IF;
			WHEN WRITING_B =>
				IF (W = '1') THEN
					IF NUMBER_OF_PROCESS < TO_UNSIGNED(1023,10) THEN
						FS <= READING_A1;
						NUMBER_OF_PROCESS <= NUMBER_OF_PROCESS + 1;
					ELSE
						FS <= DONE_STATE;
						NUMBER_OF_PROCESS <= (OTHERS => '0');
					END IF;
				
				ELSE
					FS <= COMPLETING_SEQUENCE;
					NUMBER_OF_PROCESS <= NUMBER_OF_PROCESS;
				END IF;
		WHEN DONE_STATE =>
			FS <= DONE_STATE;
			
		WHEN OTHERS =>	
			FS <= CS_S;
		END CASE;
END PROCESS CC1;

CC2: PROCESS (CS_S,FS)
	BEGIN
		CASE CS_S IS
			WHEN START_STATE =>
				
				
				EN_SAT <= '0';
				RESET_SUM <= '0';
				D <= '0';
				WR_A <= '0';
				RD_A <= '0';
				UPDATE_AD <= '0';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '0';
				CS_B <= '0';
				SH <= "000";
				LD <= "000";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 0;

			WHEN WRITING_A =>

				
				EN_SAT <= '0';
				RESET_SUM <= '0';
				D <= '0';
				WR_A <= '1';
				RD_A <= '0';
				UPDATE_AD <= '0';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '1';
				CS_B <= '0';
				SH <= "000";
				LD <= "000";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 1;
			
			
			WHEN READING_A1 =>


				EN_SAT <= '0';
				RESET_SUM <= '1';
				D <= '1';
				WR_A <= '0';
				RD_A <= '1';
				UPDATE_AD <= '0'; 
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '1';
				CS_B <= '0';
				SH <= "001";
				LD <= "110";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 1;
				
			WHEN ELABORATING_A1 =>
			
				EN_SAT <= '0';
				RESET_SUM <= '0';
				D <= '0';
                                UPDATE_AD <= '1';
				WR_A <= '0';
				RD_A <= '1';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '1';
				CS_B <= '0';
				SH <= "001";
				LD <= "110";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 1;

			WHEN READING_A2 =>


			
				EN_SAT <= '0';			
				RESET_SUM <= '0';
				D <= '1';
				WR_A <= '0';
				UPDATE_AD <= '0';
				RD_A <= '1';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '1';
				CS_B <= '0';
				SH <= "001";
				LD <= "111";
				INV <= TO_SIGNED(1,1);
				DONE <= '0';
				N_SHIFT <= 1;
			
				
			WHEN ELABORATING_A2 =>
				
				EN_SAT <= '0';
				RESET_SUM <= '0';
				D <= '0';
				WR_A <= '0';
				RD_A <= '1';
				UPDATE_AD <= '1';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '0';
				CS_B <= '0';
				SH <= "001";
				LD <= "111";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 1;

			WHEN READING_A3 =>
			
				EN_SAT <= '0';
				RESET_SUM <= '0';		
				D <= '1';
				UPDATE_AD <= '0';
				WR_A <= '0';
				RD_A <= '1';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '1';
				CS_B <= '0';
				SH <= "001";
				LD <= "111";
				INV <= TO_SIGNED(1,1);
				DONE <= '0';
				N_SHIFT <= 2;
				
			WHEN ELABORATING_A3 =>
				
				EN_SAT <= '0';
				RESET_SUM <= '0';
				D <= '0';
				UPDATE_AD <= '1';
				WR_A <= '0';
				RD_A <= '1';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '1';
				CS_B <= '0';
				SH <= "001";
				LD <= "111";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 2;

			
			WHEN READING_A4 =>
				
				EN_SAT <= '0';
				RESET_SUM <= '0';
				D <= '1';
				UPDATE_AD <= '0';
				WR_A <= '0';
				RD_A <= '1';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '1';
				CS_B <= '0';
				SH <= "001";
				LD <= "110";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 2;

	
			WHEN ELABORATING_A4 =>
				
				EN_SAT <= '0';
				RESET_SUM <= '0';
				D <= '0';
				UPDATE_AD <= '0';
				WR_A <= '0';
				RD_A <= '1';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '1';
				CS_B <= '0';
				SH <= "000";
				LD <= "110";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 2;

			
			WHEN DONE_STATE =>
			
				EN_SAT <= '0';
				D <= '0';
				RESET_SUM <= '0';
				UPDATE_AD <= '0';
				WR_A <= '0';
				RD_A <= '0';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '0';
				CS_B <= '0';
				SH <= "000";
				LD <= "110";
				INV <= TO_SIGNED(0,1);
				DONE <= '1';
				N_SHIFT <= 0;

			WHEN WRITING_B =>
	
				EN_SAT <= '1';
				RESET_SUM <= '0';
				UPDATE_AD <= '1';
				D <= '1';
				WR_A <= '0';
				RD_A <= '0';
				RD_B <= '0';
				WR_B <= '0'; 
				CS_A <= '0';
				CS_B <= '0';
				SH <= "000";
				LD <= "110";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 1;
				

			WHEN COMPLETING_SEQUENCE =>

				EN_SAT <= '0';
				RESET_SUM <= '0';
				UPDATE_AD <= '0';
				D <= '1';
				WR_A <= '0';
				RD_A <= '0';
				RD_B <= '0';
				WR_B <= '0'; 
				CS_A <= '0';
				CS_B <= '0';
				SH <= "000";
				LD <= "110";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 1;
	
			WHEN PREP_TO_WRITING =>
				
				EN_SAT <= '1';
				RESET_SUM <= '0';
				UPDATE_AD <= '0';
				D <= '0';
				WR_A <= '0';
				RD_A <= '0';
				RD_B <= '0';
				WR_B <= '1'; 
				CS_A <= '0';
				CS_B <= '1';
				SH <= "000";
				LD <= "110";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 1;

			WHEN OTHERS =>
				
				EN_SAT <= '0';
				D <= '0';
				RESET_SUM <= '0';
				UPDATE_AD <= '0';
				WR_A <= '0';
				RD_A <= '0';
				RD_B <= '0';
				WR_B <= '0';
				CS_A <= '0';
				CS_B <= '0';
				SH <= "000";
				LD <= "110";
				INV <= TO_SIGNED(0,1);
				DONE <= '0';
				N_SHIFT <= 0;

			END CASE;
END PROCESS CC2;

				
		
END BEHAVIOR;		
				
				
