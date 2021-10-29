----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2015 03:20:50 PM
-- Design Name: 
-- Module Name: AudioController - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.log2;
USE IEEE.MATH_REAL.ceil;


entity AudioController is
    generic (
         C_config_port_DATA_WIDTH    : integer    := 32;
         C_data_port_ADDR_WIDTH	: integer	:= 32;
         C_data_port_DATA_WIDTH    : integer    := 32;
         AUDIO_DATA_WIDTH : integer := 24);
    port (
        -- Ports of Axi Synchronization port
        aclk    : in std_logic;
        aresetn    : in std_logic;
        
        -- Mode Reg interface
        mode_reg : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
        mode_reg_1 : out std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0); 
        mode_reg_1_enable : out std_logic;
        mode_reg_1_ready : in std_logic;
        
        -- Other Reg interface
        start_addr_reg : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
        size_reg : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0); 
        
        -- Data Port interface
        word_data : in std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0);
        word_addr : out std_logic_vector(C_data_port_ADDR_WIDTH-1 downto 0);
        data_port_enable : out std_logic;
        data_port_ready : in std_logic;
        
        -- Audio interface
        audio_data : out std_logic_vector(AUDIO_DATA_WIDTH-1 downto 0);
        audio_enable : out std_logic;
        audio_ready : in std_logic;
        audio_ch : out std_logic;
        audio_lrclk : in std_logic);
end AudioController;

architecture Behavioral of AudioController is

    -- Mode Reg possible values
    constant MODE_REG_NOTHING: integer := 0;
    constant MODE_REG_START : integer := 1;
    constant MODE_REG_RELOAD : integer := 2;
    
    -- Size constants
    constant BITS_PER_BYTE : integer := 8;
    constant BYTES_PER_WORD : integer := C_data_port_DATA_WIDTH/BITS_PER_BYTE;
    constant BASE2_BYTES_PER_WORD : integer := integer(ceil(log2(real(BYTES_PER_WORD))));
    constant BYTES_PER_SAMPLE : integer := 2;
    constant SAMPLES_PER_WORD : integer := BYTES_PER_WORD/BYTES_PER_SAMPLE;
    constant BITS_PER_SAMPLE : integer := BYTES_PER_SAMPLE*BITS_PER_BYTE;
    
    -- FSM
    type state_controller_type is (
        S_CONTROLLER_MODE,
        S_CONTROLLER_RESET,
        S_CONTROLLER_CHECK,
        S_CONTROLLER_DATA,
        S_CONTROLLER_AUDIO);
    signal state_controller : state_controller_type:= S_CONTROLLER_MODE;
    
    -- Regs
    signal mode_reg_1_enable_buff : std_logic;
    signal start_addr_reg_buff : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0); 
    signal size_reg_buff : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0); 
    
    -- Audio
    signal audio_data_buff : std_logic_vector(BITS_PER_SAMPLE-1 downto 0);
    signal audio_enable_buff : std_logic;
    signal audio_ch_buff : std_logic;
    signal word_ptr : std_logic_vector(C_data_port_DATA_WIDTH-BASE2_BYTES_PER_WORD-1 downto 0);
    signal data_port_enable_buff : std_logic;
begin

    -- Only a single FSM is needed to coordinate the AudioOut's modules.
    mode_reg_1_enable <= mode_reg_1_enable_buff;
    data_port_enable <= data_port_enable_buff;
    audio_enable <= audio_enable_buff;
    audio_ch <= audio_ch_buff;
    audio_data(audio_data'high downto audio_data'length-BITS_PER_SAMPLE) <= audio_data_buff;
    word_addr <= std_logic_vector(unsigned(start_addr_reg_buff) + (unsigned(word_ptr)&to_unsigned(0,BASE2_BYTES_PER_WORD)));
    
    process (aclk)
        variable sample_ptr : integer range 0 to SAMPLES_PER_WORD := 0;
        variable sample_buff : std_logic_vector(BITS_PER_SAMPLE-1 downto 0);
    begin
        if (rising_edge(aclk)) then
            if (aresetn='0') then
                state_controller <= S_CONTROLLER_MODE;
                mode_reg_1 <= (others => '0');
                start_addr_reg_buff <= (others => '0');
                size_reg_buff <= (others => '0');
                mode_reg_1_enable_buff <= '0';
                audio_data_buff <= (others => '0');
                audio_enable_buff <= '0';
                audio_ch_buff <= '0';
                data_port_enable_buff <= '0';
                word_ptr <= (others => '0');
                sample_ptr := 0;
            else
                case state_controller is
                    when S_CONTROLLER_MODE =>
                        -- START indicates samples are loaded only once.
                        if (to_integer(unsigned(mode_reg))=MODE_REG_START) then
                            mode_reg_1 <= std_logic_vector(to_unsigned(MODE_REG_NOTHING,mode_reg_1'length));
                            start_addr_reg_buff <= start_addr_reg;
                            size_reg_buff <= size_reg;
                            state_controller <= S_CONTROLLER_RESET;
                        -- RELOAD indicates samples are reloaded until AudioOut_v1_0 
                        -- is configured to do otherwise.
                        elsif (to_integer(unsigned(mode_reg))=MODE_REG_RELOAD) then
                            start_addr_reg_buff <= start_addr_reg;
                            size_reg_buff <= size_reg;
                            state_controller <= S_CONTROLLER_DATA;
                        end if;
                    when S_CONTROLLER_RESET =>
                        if (mode_reg_1_enable_buff='1' and mode_reg_1_ready='1') then
                            mode_reg_1_enable_buff <= '0';
                            state_controller <= S_CONTROLLER_DATA;
                        else
                            mode_reg_1_enable_buff <= '1';
                        end if;
                    when S_CONTROLLER_CHECK =>
                        if (sample_ptr<SAMPLES_PER_WORD) then
                            sample_buff := word_data(
                                BITS_PER_SAMPLE*(SAMPLES_PER_WORD-sample_ptr)-1 downto 
                                BITS_PER_SAMPLE*(SAMPLES_PER_WORD-1-sample_ptr));
                            for each_byte in 0 to BYTES_PER_SAMPLE-1 loop
                                audio_data_buff(BITS_PER_BYTE*(each_byte+1)-1 downto BITS_PER_BYTE*each_byte) <=
                                    sample_buff(
                                        BITS_PER_BYTE*(BYTES_PER_SAMPLE-each_byte)-1 downto 
                                        BITS_PER_BYTE*(BYTES_PER_SAMPLE-1-each_byte));
                            end loop;
                            state_controller <= S_CONTROLLER_AUDIO;
                        else
                            if (word_ptr<size_reg_buff) then
                                state_controller <= S_CONTROLLER_DATA;
                            else
                                word_ptr <= (others => '0');
                                state_controller <= S_CONTROLLER_MODE;
                            end if;
                            sample_ptr := 0;
                        end if;
                    when S_CONTROLLER_DATA =>
                        if (data_port_enable_buff='1' and data_port_ready='1') then
                            data_port_enable_buff <= '0';
                            word_ptr <= std_logic_vector(unsigned(word_ptr)+to_unsigned(1,word_ptr'length));
                            state_controller <= S_CONTROLLER_CHECK;
                        else
                            data_port_enable_buff <= '1';
                        end if;
                    when S_CONTROLLER_AUDIO =>
                        if (audio_enable_buff='1' and audio_ready='1') then
                            if (audio_ch_buff='0') then
                                audio_ch_buff <= '1';
                            else
                                audio_ch_buff <= '0';
                                state_controller <= S_CONTROLLER_CHECK;
                                sample_ptr := sample_ptr+1;
                            end if;
                            audio_enable_buff <= '0';
                        elsif (audio_lrclk/=audio_ch_buff) then
                            audio_enable_buff <= '1';
                        end if;                      
                    when others => 
                        state_controller <= S_CONTROLLER_MODE;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
