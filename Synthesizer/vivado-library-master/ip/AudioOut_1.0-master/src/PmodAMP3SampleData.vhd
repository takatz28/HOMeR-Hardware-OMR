----------------------------------------------------------------------------------
-- Company: System Chip Design Lab (Temple Univeristy Engineering)
-- Engineer: Andrew Powell
-- 
-- Create Date:    20:53:42 08/30/2015 
-- Design Name: 
-- Module Name:    PmodAMP3SampleData - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL;	
use IEEE.STD_LOGIC_MISC.ALL;

entity PmodAMP3SampleData is
	generic (
		WIDTH	: integer := 32);
	port (
		signal clock		: in std_logic;
		signal reset		: in std_logic;
		signal enable		: in std_logic;
		signal ready		: out std_logic := '0';
		signal ch			: in std_logic;
		signal lock_left	: in std_logic;
		signal lock_right	: in std_logic;
		signal in_left		: in std_logic_vector((WIDTH-1) downto 0);
		signal in_right	: in std_logic_vector((WIDTH-1) downto 0);
		signal out_left	: out std_logic_vector((WIDTH-1) downto 0) := 
			conv_std_logic_vector(0,WIDTH);
		signal out_right	: out std_logic_vector((WIDTH-1) downto 0) := 
			conv_std_logic_vector(0,WIDTH));
end PmodAMP3SampleData;

architecture Behavioral of PmodAMP3SampleData is

	type state_type is (S_WAIT_FOR_ENABLE, S_LOAD_LEFT, S_LOAD_RIGHT, S_READY);
	signal state : state_type := S_WAIT_FOR_ENABLE;

begin
	
	process (clock)
	begin
		if (rising_edge(clock)) then
			if (reset='1') then
				ready <= '0';
				out_left <= (others => '0');
				out_right <= (others => '0');
				state <= S_WAIT_FOR_ENABLE;
			else
				case state is
					when S_WAIT_FOR_ENABLE =>
						ready <= '0';
						if (enable='1') then
							if (ch='1') then
								state <= S_LOAD_LEFT;
							else
								state <= S_LOAD_RIGHT;
							end if;
						end if;
					when S_LOAD_RIGHT =>
						if (lock_right='0') then
							out_right <= in_right;
							state <= S_READY;
						end if;
					when S_LOAD_LEFT =>
						if (lock_left='0') then
							out_left <= in_left;
							state <= S_READY;
						end if;
					when  S_READY =>
						ready <= '1';
						if (enable='0') then
							state <= S_WAIT_FOR_ENABLE;
						end if;
					when others =>
						state <= S_WAIT_FOR_ENABLE;
				end case;
			end if;
		end if;
	end process;

end Behavioral;

