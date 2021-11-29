library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tank2 is
	port(
			clk : in std_logic;
			reset : in std_logic;
			xin : in std_logic_vector(9 downto 0);
			d : in std_logic; -- direction -> '0' right, '1' left
			speed : in std_logic_vector(3 downto 0); -- can be 1, 5, or 10
			xout : out std_logic_vector(9 downto 0)
		);
end entity tank2;

architecture structural of tank2 is
	-- signals and components here
	
	signal cycle_count : natural;
	signal seconds : natural;
	
begin
	
	-- for first test then get rid of this line
--	xout <= xin;
	
	-- execute normal instruction for increment
	clocked_process : process(reset, clk) begin
		if (reset = '1') then
			cycle_count <= 0;
			xout <= std_logic_vector(to_unsigned(320, 10)); -- middle of the screen
		elsif (rising_edge(clk)) then
			cycle_count <= cycle_count + 1;
			seconds <= seconds + 1;
			
			if (cycle_count > 1000000) then -- trigger event every 1MHz
				cycle_count <= 0;
				seconds <= 0;
				
				if (d = '0') then -- moving right
					if ((unsigned(xin) + 40) > 639) then
						xout <= std_logic_vector(to_unsigned(600, 10));
					else
						xout <= std_logic_vector(unsigned(xin) + (unsigned(speed) * seconds));
					end if;
				end if;
				
				if (d = '1') then -- moving left
					if ((unsigned(xin) - 40) < 0) then
						xout <= std_logic_vector(to_unsigned(40, 10));
					else
						xout <= std_logic_vector(unsigned(xin) - (unsigned(speed) * seconds));
					end if;
				end if;

			else
			
				xout <= xin;
			
			end if;
			
		end if;
	end process clocked_process;

end architecture structural;