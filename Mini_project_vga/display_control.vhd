library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display_control is
	port(
			xt1i : in std_logic_vector(9 downto 0);
			xt2i : in std_logic_vector(9 downto 0);
			
			red_out : out std_logic_vector(9 downto 0);
			green_out : out std_logic_vector(9 downto 0);
			blue_out : out std_logic_vector(9 downto 0);
			
			clk : in std_logic;
			ROM_clk : in std_logic;
			rst_n : in std_logic;
			video_on : in std_logic;
			eof : in std_logic;
			pixel_row : in std_logic_vector(9 downto 0);
			pixel_column : in std_logic_vector(9 downto 0)
			
		);
end entity display_control;

architecture structural of display_control is
	-- signals and components here

	component ROM is
		port(
				q : out std_logic_vector(29 downto 0);
				raddr : in std_logic_vector(2 downto 0);
				clk : in std_logic
		);
	end component ROM;
	
	-- addresses of colors placed in ROM component
	constant color_red : std_logic_vector(2 downto 0) := "000";
	constant color_green : std_logic_vector(2 downto 0) := "001";
	constant color_blue : std_logic_vector(2 downto 0) := "010";
	constant color_white : std_logic_vector(2 downto 0) := "011";
	
	-- select correct color in ROM
	signal colorAddress : std_logic_vector (2 downto 0);
	
	-- color put in vga_sync
	signal color : std_logic_vector (29 downto 0);

	signal pixel_row_int, pixel_column_int : natural;
	
begin

	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
	
	-- draw tank 50 pixels wide and 50 pixels long
	pixelDraw : process(clk, rst_n) is
	
	begin
--		if (rst_n = '1') then -- reset positions of tanks are controlled in their corresponding components
--			-- top_tank
--			if (pixel_column_int = (to_integer(unsigned(xt1i)) - 40) and pixel_column_int = (to_integer(unsigned(xt1i)) + 40)) then
--				if (pixel_row_int >= 0 and pixel_row_int <= 40) then
--					colorAddress <= color_red; -- tank top screen is red
--				end if;
--				
--			-- bottom_tank
--			elsif (pixel_column_int = (to_integer(unsigned(xt2i)) - 40) and pixel_column_int = (to_integer(unsigned(xt2i)) + 40)) then
--				if (pixel_row_int >= 439 and pixel_row_int <= 479) then
--					colorAddress <= color_blue; -- tank bottom screen is blue
--				end if;
--			else
--				colorAddress <= color_white; -- background of game is white
--			end if;
			
		if (rising_edge(clk)) then
		
			-- top_tank
			if (pixel_column_int = (to_integer(unsigned(xt1i)) - 40) and pixel_column_int = (to_integer(unsigned(xt1i)) + 40)) then
				if (pixel_row_int >= 0 and pixel_row_int <= 40) then
					colorAddress <= color_red; -- tank top screen is red
				end if;
				
--			-- bottom_tank
--			elsif (pixel_column_int = (to_integer(unsigned(xt2i)) - 40) and pixel_column_int = (to_integer(unsigned(xt2i)) + 40)) then
--				if (pixel_row_int >= 439 and pixel_row_int <= 479) then
--					colorAddress <= color_blue; -- tank bottom screen is blue
--				end if;
			else
				colorAddress <= color_white; -- background of game is white
			end if;
			
		end if;
		
	end process pixelDraw;
	
	
	colors : ROM
		port map (
						raddr => colorAddress, 
						clk => ROM_clk, 
						q => color);

	red_out <= color(29 downto 20);
	green_out <= color(19 downto 10);
	blue_out <= color(9 downto 0);
	
	
end architecture structural;