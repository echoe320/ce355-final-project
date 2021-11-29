library IEEE;

use IEEE.std_logic_1164.all;

entity VGA_to_screen is
	port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
	
			--VGA 
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(9 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic

		);
end entity VGA_to_screen;

architecture structural of VGA_to_screen is

component tank1 is
	port(
			--clk : in std_logic;
			xin : in std_logic_vector(9 downto 0);
			--yin : in std_logic_vector(9 downto 0);
			--d : in std_logic; -- direction
			--speed : in std_logic;
			xout : out std_logic_vector(9 downto 0)
			--yout : out std_logic_vector(9 downto 0)
		);
end component tank1;


component display_control is
	port(
			xt1i : in std_logic_vector(9 downto 0);
			
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
end component display_control;

component VGA_SYNC is
	port(
			clock_50Mhz										: in std_logic;
			horiz_sync_out, vert_sync_out, 
			video_on, pixel_clock, eof						: out std_logic;												
			pixel_row, pixel_column						    : out std_logic_vector(9 downto 0)
		);
end component VGA_SYNC;

--Signals for VGA sync
signal pixel_row_int 										: std_logic_vector(9 downto 0);
signal pixel_column_int 									: std_logic_vector(9 downto 0);
signal video_on_int											: std_logic;
signal VGA_clk_int											: std_logic;
signal eof													: std_logic;

signal xout_internal : std_logic_vector(9 downto 0);

begin

	tank_top_screen : tank1
		port map (
						--clk : in std_logic;
						xin => "0101000000",
						--yin : in std_logic_vector(9 downto 0);
						--d : in std_logic; -- direction
						--speed : in std_logic;
						xout => xout_internal
						--yout : out std_logic_vector(9 downto 0)
					);

	videoGen : display_control
		port map (
						xt1i => xout_internal,
			
						red_out => VGA_RED,
						green_out => VGA_GREEN,
						blue_out => VGA_BLUE,
			
						clk => CLOCK_50,
						ROM_clk => VGA_clk_int,
						rst_n => RESET_N,
						video_on => video_on_int,
						eof => eof,
						pixel_row => pixel_row_int,
						pixel_column => pixel_column_int
					);

--------------------------------------------------------------------------------------------
--This section should not be modified in your design.  This section handles the VGA timing signals
--and outputs the current row and column.  You will need to redesign the pixelGenerator to choose
--the color value to output based on the current position.

	videoSync : VGA_SYNC
		port map(CLOCK_50, HORIZ_SYNC, VERT_SYNC, video_on_int, VGA_clk_int, eof, pixel_row_int, pixel_column_int);

	VGA_BLANK <= video_on_int;

	VGA_CLK <= VGA_clk_int;

--------------------------------------------------------------------------------------------	

end architecture structural;