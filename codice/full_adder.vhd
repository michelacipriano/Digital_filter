LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY full_adder IS
PORT(a, b, c_i: IN SIGNED;
     s: OUT SIGNED;
     c_0: OUT SIGNED);
END full_adder;

ARCHITECTURE behavior OF full_adder IS
 
begin
process(a,b,c_i)
	begin	
		if (a= to_signed(1,1) AND b= to_signed(1,1)) then	
			c_0 <= to_signed(1,1);
			if (c_i = to_signed(1,1)) then 
				 s<= to_signed(1,1);
			else
				s <= to_signed(0,1);
			end if;
		elsif (a=to_signed(1,1) OR b=to_signed(1,1)) then
				if (c_i = to_signed(1,1)) then 
				 s <= to_signed(0,1);
				 c_0 <= to_signed(1,1);
				else
					 s <= to_signed(1,1);
				 c_0 <= to_signed(0,1);
				end if;
		else		
				c_0 <= to_signed(0,1);
				if (c_i = to_signed(1,1)) then 
				 s <= to_signed(1,1);
				else
				s <= to_signed(0,1);
			end if;
		end if;
		
end process;

END behavior; 
