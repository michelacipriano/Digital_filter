LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY adder IS
PORT (a, b : IN SIGNED(10 DOWNTO 0);
      carry_in: SIGNED;
      final_sum: OUT SIGNED(10 downto 0));
END adder;

ARCHITECTURE behaviour OF adder IS

SIGNAL c_out_sig, sum_sig: SIGNED(10 downto 0);

COMPONENT full_adder IS
PORT(a, b, c_i: IN signed;
     s: OUT signed;
     c_0: OUT signed);
END component;



BEGIN 
F0: full_adder PORT MAP(a(0 downto 0), b(0 downto 0), carry_in, sum_sig(0 downto 0), c_out_sig(0 DOWNTO 0));
F1: full_adder PORT MAP(a(1 downto 1), b(1 downto 1),c_out_sig(0 DOWNTO 0), sum_sig(1 downto 1), c_out_sig(1 DOWNTO 1));
F2: full_adder PORT MAP(a(2 downto 2), b(2 downto 2),c_out_sig(1 DOWNTO 1), sum_sig(2 downto 2), c_out_sig(2 DOWNTO 2));
F3: full_adder PORT MAP(a(3 downto 3), b(3 downto 3), c_out_sig(2 DOWNTO 2), sum_sig(3 downto 3), c_out_sig(3 DOWNTO 3));
F4: full_adder PORT MAP(a(4 downto 4), b(4 downto 4), c_out_sig(3 DOWNTO 3), sum_sig(4 downto 4), c_out_sig(4 DOWNTO 4));
F5: full_adder PORT MAP(a(5 downto 5), b(5 downto 5),c_out_sig(4 DOWNTO 4), sum_sig(5 downto 5), c_out_sig(5 DOWNTO 5));
F6: full_adder PORT MAP(a(6 downto 6), b(6 downto 6),c_out_sig(5 DOWNTO 5), sum_sig(6 downto 6), c_out_sig(6 DOWNTO 6));
F7: full_adder PORT MAP(a(7 downto 7), b(7 downto 7), c_out_sig(6 DOWNTO 6), sum_sig(7 downto 7), c_out_sig(7 DOWNTO 7));
F8: full_adder PORT MAP(a(8 downto 8), b(8 downto 8),c_out_sig(7 DOWNTO 7), sum_sig(8 downto 8), c_out_sig(8 DOWNTO 8));
F9: full_adder PORT MAP(a(9 downto 9), b(9 downto 9),c_out_sig(8 DOWNTO 8), sum_sig(9 downto 9), c_out_sig(9 DOWNTO 9));
F10: full_adder PORT MAP(a(10 downto 10), b(10 downto 10), c_out_sig(9 DOWNTO 9), sum_sig(10 downto 10), c_out_sig(10 DOWNTO 10));

final_sum <= sum_sig;
end behaviour;

