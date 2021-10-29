----------------------------------------------------------------------------------
-- Company: System Chip Design Lab (Temple Univeristy Engineering) 
-- Engineer: Andrew Powell
-- 
-- Create Date:    23:13:36 09/08/2015 
-- Design Name: 
-- Module Name:    Reset - Behavioral 
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

entity ResetModule is
	port (
		signal clock 					: in std_logic;
		signal reset 					: in std_logic;
		signal enable					: in std_logic;
		signal ready					: out std_logic := '0';
		signal reset_modules 		: out std_logic;
		signal reset_down_samplers : out std_logic);
end ResetModule;

architecture Behavioral of ResetModule is
	signal reset_modules_buff 			: std_logic := '0';
	signal reset_down_samplers_buff 	: std_logic := '0';
	type state_type is (S_ENABLE, S_RESET_DOWN_SAMPLERS_0, S_RESET_DOWN_SAMPLERS_1);
	signal state 							: state_type := S_ENABLE;
begin
	reset_modules <= reset_modules_buff;
	reset_down_samplers <= reset_down_samplers_buff;
	process (clock)
	begin
		if (falling_edge(clock)) then
			if (reset='1') then
				state <= S_ENABLE;
				reset_modules_buff <= '0';
				reset_down_samplers_buff <= '0';
				ready <= '0';
			else
				case state is
					when S_ENABLE =>
						ready <= '0';
						if (enable='1') then
							state <= S_RESET_DOWN_SAMPLERS_0;
						end if;
					when S_RESET_DOWN_SAMPLERS_0 =>
						if (reset_down_samplers_buff='0') then
							reset_modules_buff <= '1';
							reset_down_samplers_buff <= '1';
						else
							reset_down_samplers_buff <= '0';
							state <= S_RESET_DOWN_SAMPLERS_1;
						end if;
					when S_RESET_DOWN_SAMPLERS_1 =>
						if (reset_down_samplers_buff='0') then
							reset_down_samplers_buff <= '1';
						else
							ready <= '1';
							if (enable='0') then
								reset_modules_buff <= '0';
								reset_down_samplers_buff <= '0';
								state <= S_ENABLE;
							end if;
						end if;
					when others =>
						state <= S_ENABLE;
				end case;
			end if;
		end if;
	end process;
end Behavioral;