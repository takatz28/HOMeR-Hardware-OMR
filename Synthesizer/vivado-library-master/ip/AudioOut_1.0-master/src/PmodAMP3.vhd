----------------------------------------------------------------------------------
-- Company: System Chip Design Lab (Temple Univeristy Engineering)
-- Engineer: Andrew Powell
-- 
-- Create Date:    13:29:05 08/29/2015 
-- Design Name: 
-- Module Name:    PmodAMP3 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- 
-- This module is designed to output data from the Digilent PmodAMP3. 
--
-- The synchronous "reset" must be held for 8 clock cycles for proper reset.
--
-- The "enable" and "ready" are the syncrhonizing handshaking signals. The module
-- will write data from "data" to either a left or right channel buffer once "enable"
-- is set to '1' and "ready" becomes '1'. "ready" is set back to '0' once "enable"
-- is set back to '0'. The buffer is selected by "ch". The module will continuously 
-- write the data from the channel buffers to the TDM signals that drive the PmodAMP3.
--
-- This module was only tested on the Digilent Atlys Board.
--
-- Dependencies: DownSample, ResetModule, PmodAMP3SampleData, PmodAMP3LoadData
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

entity PmodAMP3 is
	-- Do not change any of the generics.
	generic(
		SAMPLE_RATE_DOWNSAMPLE_WIDTH	: integer := 9;
		BCLK_DOWNSAMPLE_WIDTH			: integer := 3;
		MCLK_DOWNSAMPLE_WIDTH			: integer := 1;
		DATA_WIDTH							: integer := 24;
		CHANNEL_WIDTH						: integer := 32;
		LOAD_SELECTOR_WIDTH				: integer := 5;
		LOAD_SELECTOR_CHANGE_VALUE		: integer := 31);
	port(
		signal clock			: in std_logic;		-- Clock: 50 MHz
		signal reset			: in std_logic;		-- Reset: Synchronous
		signal enable			: in std_logic;		-- Handshake: Enable
		signal ready			: out std_logic;		-- Handshake: Ready
		signal ch				: in std_logic;		-- Input: '1'=Right Channel,'0'=Left Channel
		signal data				: 							-- Input: Data 
			in std_logic_vector((DATA_WIDTH-1) downto 0);
		signal amp_sdata		: out std_logic;		-- TDM: Serial Out
		signal amp_nsd			: out std_logic;		-- TDM: Power Save (Always '1')
		signal amp_lrclk		: out std_logic;		-- TDM: Channel 48.828 KHz Clock (Sample Frequency)
		signal amp_bclk		: out std_logic;		-- TDM: Bit 3.125 MHz Clock (64 Cycles Per LR Clock)
		signal amp_mclk		: out std_logic);		-- TDM: Master 12.5 MHz Clock
end PmodAMP3;

architecture Behavioral of PmodAMP3 is

	component DownSample 
		generic (	
			WIDTH				: integer;
			INITIAL             : std_logic);
		port (		
			clock				: in std_logic;
			reset				: in std_logic;
			output			: out std_logic);
	end component;
	
	component ResetModule
		port(
			clock 					: in std_logic;
			reset 					: in std_logic;
			enable 					: in std_logic;          
			ready 					: out std_logic;
			reset_modules 			: out std_logic;
			reset_down_samplers 	: out std_logic);
	end component;
	
	component PmodAMP3SampleData
		generic (
			WIDTH	: integer	:= 32);
		port (
			signal clock		: in std_logic;
			signal reset		: in std_logic;
			signal enable		: in std_logic;
			signal ready		: out std_logic;
			signal ch			: in std_logic;
			signal lock_left	: in std_logic;
			signal lock_right	: in std_logic;
			signal in_left		: in std_logic_vector((WIDTH-1) downto 0);
			signal in_right	: in std_logic_vector((WIDTH-1) downto 0);
			signal out_left	: out std_logic_vector((WIDTH-1) downto 0);
			signal out_right	: out std_logic_vector((WIDTH-1) downto 0));
	end component;

	component PmodAMP3LoadData
	generic (
		WIDTH								: integer := 32;
		LOAD_SELECT_WIDTH				: integer := 5;
		LOAD_SELECT_SWITCH_VALUE 	: integer := 31);
	port (
		signal clock		: in std_logic;
		signal reset		: in std_logic;
		signal ch			: out std_logic;
		signal sdata		: out std_logic;
		signal right_buff	: in std_logic_vector((WIDTH-1) downto 0);
		signal left_buff	: in std_logic_vector((WIDTH-1) downto 0));
	end component;

	signal amp_lrclk_buff	: std_logic;
	signal amp_bclk_buff		: std_logic;
	signal amp_mclk_buff		: std_logic;
	signal amp_sdata_buff	: std_logic;
	
	signal ch_busy		: std_logic;
	signal lock_left	: std_logic;
	signal lock_right	: std_logic;
	signal in_data		: std_logic_vector((CHANNEL_WIDTH-1) downto 0);
	signal right_buff	: std_logic_vector((CHANNEL_WIDTH-1) downto 0);
	signal left_buff	: std_logic_vector((CHANNEL_WIDTH-1) downto 0);

	signal reset_down_samplers	: std_logic;
	signal reset_modules			: std_logic;
	signal reset_ready			: std_logic;

begin
	
	amp_lrclk <= amp_lrclk_buff;
	amp_bclk <= amp_bclk_buff;
	amp_mclk <= amp_mclk_buff;
	amp_sdata <= amp_sdata_buff;
	
	lock_left <= not ch_busy;
	lock_right <= ch_busy;
	
	in_data(in_data'high downto in_data'length-DATA_WIDTH) <= data;
	in_data(in_data'high-DATA_WIDTH downto 0) <= (others=>'0');
	amp_nsd <= '1';
	
	-- Down Sampler For LR Clock
	DownSample_0 : DownSample
		generic 	map (
			WIDTH => SAMPLE_RATE_DOWNSAMPLE_WIDTH,
			INITIAL => '0')
		port map (
			clock => clock,
			reset => reset_down_samplers,
			output => amp_lrclk_buff);
			
	-- Down Sampler B Clock 
	DownSample_1 : DownSample
		generic 	map (
			WIDTH => BCLK_DOWNSAMPLE_WIDTH,
			INITIAL => '1')
		port map (
			clock => clock,
			reset => reset_down_samplers,
			output => amp_bclk_buff);
			
	-- Down Sampler M Clock 
	DownSample_2 : DownSample
		generic 	map (
			WIDTH => MCLK_DOWNSAMPLE_WIDTH,
			INITIAL => '1')
		port map (
			clock => clock,
			reset => reset_down_samplers,
			output => amp_mclk_buff);
			
	-- Reset Module
	ResetModule_0 : ResetModule 
		port map(
			clock => clock,
			reset => '0',
			enable => reset,
			ready => reset_ready,
			reset_modules => reset_modules,
			reset_down_samplers => reset_down_samplers);
			
	-- Sample Data
	PmodAMP3SampleData_0 : PmodAMP3SampleData
		port map (
			clock	=> clock,
			reset	=> reset_modules,
			enable => enable,
			ready	=> ready,
			ch	=> ch,
			lock_left => lock_left,
			lock_right => lock_right,
			in_left => in_data,
			in_right => in_data,
			out_left	=> left_buff,
			out_right => right_buff);
	
	-- Load Data
	PmodAMP3LoadData_0 : PmodAMP3LoadData
		port map (
			clock	=> amp_bclk_buff,
			reset	=> reset_modules,
			ch	=> ch_busy,
			sdata	=> amp_sdata_buff,
			right_buff	=> right_buff,
			left_buff => left_buff);
			
end Behavioral;

