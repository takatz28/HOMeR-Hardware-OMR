----------------------------------------------------------------------------------
-- Company: System Chip Design Lab (Temple Univeristy Engineering)
-- Engineer: Andrew Powell
-- 
-- Create Date:    21:07:10 08/30/2015 
-- Design Name: 
-- Module Name:    PmodAMP3LoadData - Behavioral 
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

entity PmodAMP3LoadData is
	generic (
		WIDTH								: integer := 32;
		LOAD_SELECT_WIDTH				: integer := 5;
		LOAD_SELECT_SWITCH_VALUE 	: integer := 31);
	port (
		signal clock		: in std_logic;
		signal reset		: in std_logic;
		signal ch			: out std_logic;
		signal sdata		: out std_logic := '0';
		signal right_buff	: in std_logic_vector((WIDTH-1) downto 0);
		signal left_buff	: in std_logic_vector((WIDTH-1) downto 0));
end PmodAMP3LoadData;

architecture Behavioral of PmodAMP3LoadData is
	
	signal ch_buff			: std_logic := '1';
	signal load_select	: std_logic_vector((LOAD_SELECT_WIDTH-1) downto 0) :=
		conv_std_logic_vector(1,LOAD_SELECT_WIDTH);
	
begin

	ch <= ch_buff;

	process (clock)
	begin
		if (falling_edge(clock)) then
			if (reset='1') then
				ch_buff <= '1';
				sdata <= '0';
				load_select <= conv_std_logic_vector(1,load_select'length);
			else
				load_select <= load_select+1;
				if (load_select=LOAD_SELECT_SWITCH_VALUE) then
					ch_buff <= not ch_buff;
				end if;
				if (ch_buff='1') then
					sdata <= right_buff(right_buff'high-conv_integer(load_select));
				else
					sdata <= left_buff(left_buff'high-conv_integer(load_select));
				end if;
			end if;
		end if;
	end process;

end Behavioral;

