library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- BRAM that functions like a ROM -> no need for write enable & d
-- the BRAM functions as a look up table for colors
-- lets say need only 8 colors -> 3 bit address (can hold 8 colors)
entity ROM is
	port(
			q : out std_logic_vector(29 downto 0);
			raddr : in std_logic_vector(2 downto 0);  -- 3 bit addr
			clk : in std_logic
		);
end entity ROM;

architecture behavioral of ROM is
	-- signals and components here
	
	type rom_type is array (0 to 7) of std_logic_vector (29 downto 0);
	
	constant ROM_array : rom_type := (
													"111111111100000000000000000000", -- red (0)
													"000000000011111111110000000000", -- green (1)
													"000000000000000000001111111111", -- blue (2)
													"111111111111111111111111111111", -- white (3)
													"000000000000000000000000000000",
													"000000000000000000000000000000",
													"000000000000000000000000000000",
													"000000000000000000000000000000"
													);
	begin
	
	q <= ROM_array(to_integer(unsigned(raddr)));
	
end architecture behavioral;