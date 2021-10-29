----------------------------------------------------------------------------------
-- Company: System Chip Design Lab (SCDL)
-- Engineer: Andrew Powell
-- 
-- Create Date: 11/06/2015 03:20:50 PM
-- Design Name: 
-- Module Name: AudioOut_v1_0
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: A basic hardware audio driver for the Zybo's SSM2603 codec. In the
-- IP's current form, only the DAC is applicable. In the future, the functionality 
-- of AudioOut_v1_0 may be extended to include the codec's other features. 
--
-- Please note AudioOut_v1_0 takes advantage of a modified version of PmodAMP3, another
-- module developed to drive the Digilent PmodAMP3. 
-- 
-- Dependencies: AudioController, PmodAMP3 (modified), ConfigPort, DataPort
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AudioOut_v1_0 is
	generic (
	   DEFAULT_START_ADDR : std_logic_vector := x"20000000";

		-- Parameters of Axi Slave Bus Interface config_port
		C_config_port_DATA_WIDTH	: integer	:= 32;
		C_config_port_ADDR_WIDTH	: integer	:= 4;

		-- Parameters of Axi Master Bus Interface data_port
		C_data_port_ADDR_WIDTH	: integer	:= 32;
		C_data_port_DATA_WIDTH	: integer	:= 32);
	port (
	   -- Ports of Axi Synchronization port
		aclk	: in std_logic; -- 50 MHz clock
        aresetn    : in std_logic;
        
		-- Ports of Axi Slave Bus Interface config_port
		config_port_awaddr	: in std_logic_vector(C_config_port_ADDR_WIDTH-1 downto 0);
		config_port_awprot	: in std_logic_vector(2 downto 0);
		config_port_awvalid	: in std_logic;
		config_port_awready	: out std_logic;
		config_port_wdata	: in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
		config_port_wstrb	: in std_logic_vector((C_config_port_DATA_WIDTH/8)-1 downto 0);
		config_port_wvalid	: in std_logic;
		config_port_wready	: out std_logic;
		config_port_bresp	: out std_logic_vector(1 downto 0);
		config_port_bvalid	: out std_logic;
		config_port_bready	: in std_logic;
		config_port_araddr	: in std_logic_vector(C_config_port_ADDR_WIDTH-1 downto 0);
		config_port_arprot	: in std_logic_vector(2 downto 0);
		config_port_arvalid	: in std_logic;
		config_port_arready	: out std_logic;
		config_port_rdata	: out std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
		config_port_rresp	: out std_logic_vector(1 downto 0);
		config_port_rvalid	: out std_logic;
		config_port_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface data_port
		data_port_awaddr	: out std_logic_vector(C_data_port_ADDR_WIDTH-1 downto 0);
		data_port_awprot	: out std_logic_vector(2 downto 0);
		data_port_awvalid	: out std_logic;
		data_port_awready	: in std_logic;
		data_port_wdata	: out std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0);
		data_port_wstrb	: out std_logic_vector(C_data_port_DATA_WIDTH/8-1 downto 0);
		data_port_wvalid	: out std_logic;
		data_port_wready	: in std_logic;
		data_port_bresp	: in std_logic_vector(1 downto 0);
		data_port_bvalid	: in std_logic;
		data_port_bready	: out std_logic;
		data_port_araddr	: out std_logic_vector(C_data_port_ADDR_WIDTH-1 downto 0);
		data_port_arprot	: out std_logic_vector(2 downto 0);
		data_port_arvalid	: out std_logic;
		data_port_arready	: in std_logic;
		data_port_rdata	: in std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0);
		data_port_rresp	: in std_logic_vector(1 downto 0);
		data_port_rvalid	: in std_logic;
		data_port_rready	: out std_logic;
		
		-- Interface to the audio codec's output DAC
		audio_sdata : out std_logic;
        audio_nsd : out std_logic;
        audio_lrclk : out std_logic;
        audio_bclk : out std_logic;
        audio_mclk : out std_logic);
end AudioOut_v1_0;

architecture arch_imp of AudioOut_v1_0 is

    constant AUDIO_DATA_WIDTH : integer := 24;

    signal mode_reg : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
    signal mode_reg_1 : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
    signal mode_reg_1_enable : std_logic;
    signal mode_reg_1_ready : std_logic;
    
    signal start_addr_reg : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
    signal size_reg : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
    signal error_reg : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
    
    signal word_data : std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0);
    signal word_addr : std_logic_vector(C_data_port_ADDR_WIDTH-1 downto 0);
    signal data_port_enable : std_logic;
    signal data_port_ready : std_logic;
    
    signal audio_data : std_logic_vector(AUDIO_DATA_WIDTH-1 downto 0);
    signal audio_enable : std_logic;
    signal audio_ready : std_logic;
    signal audio_ch : std_logic;
    signal audio_lrclk_buff : std_logic;

    component AudioController is
        generic (
             C_config_port_DATA_WIDTH : integer := C_config_port_DATA_WIDTH;
             C_data_port_ADDR_WIDTH	: integer	:= C_data_port_ADDR_WIDTH;
             C_data_port_DATA_WIDTH    : integer    := C_data_port_DATA_WIDTH;
             AUDIO_DATA_WIDTH : integer := AUDIO_DATA_WIDTH);
        port (
            aclk    : in std_logic;
            aresetn    : in std_logic;
            mode_reg : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
            mode_reg_1 : out std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0); 
            mode_reg_1_enable : out std_logic;
            mode_reg_1_ready : in std_logic;
            start_addr_reg : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
            size_reg : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0); 
            word_data : in std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0);
            word_addr : out std_logic_vector(C_data_port_ADDR_WIDTH-1 downto 0);
            data_port_enable : out std_logic;
            data_port_ready : in std_logic;
            audio_data : out std_logic_vector(AUDIO_DATA_WIDTH-1 downto 0);
            audio_enable : out std_logic;
            audio_ready : in std_logic;
            audio_ch : out std_logic;
            audio_lrclk : in std_logic);
    end component;
       
    component PmodAMP3 is
        generic(
            DATA_WIDTH  : integer := AUDIO_DATA_WIDTH);
        port(
            clock : in std_logic;      
            reset : in std_logic;      
            enable : in std_logic;   
            ready : out std_logic;        
            ch : in std_logic;    
            data : in std_logic_vector((DATA_WIDTH-1) downto 0);
            amp_sdata : out std_logic;     
            amp_nsd : out std_logic;       
            amp_lrclk : out std_logic;        
            amp_bclk : out std_logic;      
            amp_mclk  : out std_logic);        
    end component;
    
    component ConfigPort is
        generic (
            DEFAULT_START_ADDR : std_logic_vector := DEFAULT_START_ADDR;
            C_config_port_DATA_WIDTH    : integer    := C_config_port_DATA_WIDTH;
            C_config_port_ADDR_WIDTH    : integer    := C_config_port_ADDR_WIDTH);
        port (
            aclk    : in std_logic;
            aresetn    : in std_logic;
            config_port_awaddr    : in std_logic_vector(C_config_port_ADDR_WIDTH-1 downto 0);
            config_port_awprot    : in std_logic_vector(2 downto 0);
            config_port_awvalid    : in std_logic;
            config_port_awready    : out std_logic;
            config_port_wdata    : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
            config_port_wstrb    : in std_logic_vector((C_config_port_DATA_WIDTH/8)-1 downto 0);
            config_port_wvalid    : in std_logic;
            config_port_wready    : out std_logic;
            config_port_bresp    : out std_logic_vector(1 downto 0);
            config_port_bvalid    : out std_logic;
            config_port_bready    : in std_logic;
            config_port_araddr    : in std_logic_vector(C_config_port_ADDR_WIDTH-1 downto 0);
            config_port_arprot    : in std_logic_vector(2 downto 0);
            config_port_arvalid    : in std_logic;
            config_port_arready    : out std_logic;
            config_port_rdata    : out std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
            config_port_rresp    : out std_logic_vector(1 downto 0);
            config_port_rvalid    : out std_logic;
            config_port_rready    : in std_logic;
            mode_reg : out std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
            start_addr_reg : out std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
            size_reg : out std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
            error_reg : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
            mode_reg_1 : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
            mode_reg_1_enable : in std_logic;
            mode_reg_1_ready : out std_logic);
    end component;
    
    component DataPort is
        generic (
            -- Data Port parameters
            C_data_port_ADDR_WIDTH    : integer    := C_data_port_ADDR_WIDTH;
            C_data_port_DATA_WIDTH    : integer    := C_data_port_DATA_WIDTH);
        port (
            aclk    : in std_logic;
            aresetn    : in std_logic;
            data_port_awaddr    : out std_logic_vector(C_data_port_ADDR_WIDTH-1 downto 0);
            data_port_awprot    : out std_logic_vector(2 downto 0);
            data_port_awvalid    : out std_logic;
            data_port_awready    : in std_logic;
            data_port_wdata    : out std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0);
            data_port_wstrb    : out std_logic_vector(C_data_port_DATA_WIDTH/8-1 downto 0);
            data_port_wvalid    : out std_logic;
            data_port_wready    : in std_logic;
            data_port_bresp    : in std_logic_vector(1 downto 0);
            data_port_bvalid    : in std_logic;
            data_port_bready    : out std_logic;
            data_port_araddr    : out std_logic_vector(C_data_port_ADDR_WIDTH-1 downto 0);
            data_port_arprot    : out std_logic_vector(2 downto 0);
            data_port_arvalid    : out std_logic;
            data_port_arready    : in std_logic;
            data_port_rdata    : in std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0);
            data_port_rresp    : in std_logic_vector(1 downto 0);
            data_port_rvalid    : in std_logic;
            data_port_rready    : out std_logic;
            enable : in std_logic;
            ready : out std_logic;
            word_addr : in std_logic_vector(C_data_port_ADDR_WIDTH-1 downto 0);
            word_data : out std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0);
            error_reg : out std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0)); 
    end component;
    
begin

    audio_lrclk <= audio_lrclk_buff;

    -- The controller governs all other components
    -- in the module, with a single FSM.
    AudioController_0 : AudioController
        port map (
            aclk => aclk,
            aresetn => aresetn,
            mode_reg => mode_reg,
            mode_reg_1 => mode_reg_1,
            mode_reg_1_enable => mode_reg_1_enable,
            mode_reg_1_ready => mode_reg_1_ready,
            start_addr_reg => start_addr_reg,
            size_reg => size_reg,
            word_data => word_data,
            word_addr => word_addr,
            data_port_enable => data_port_enable,
            data_port_ready => data_port_ready,
            audio_data => audio_data,
            audio_enable => audio_enable,
            audio_ready => audio_ready,
            audio_ch => audio_ch,
            audio_lrclk => audio_lrclk_buff);

    -- Audio_0 implements the I2S interface.
    Audio_0 : PmodAMP3 
        port map (
            clock => aclk,
            reset => "not" (aresetn),
            enable => audio_enable,
            ready => audio_ready,
            ch => audio_ch,
            data => audio_data,
            amp_sdata => audio_sdata,
            amp_nsd	=> audio_nsd,
            amp_lrclk => audio_lrclk_buff,
            amp_bclk => audio_bclk,
            amp_mclk => audio_mclk);

    -- ConfigPort_0 implements an AXI4-Lite interface
    -- so that another device can configure its registers.
    ConfigPort_0 : ConfigPort 
        port map (
            aclk => aclk,
            aresetn => aresetn,
            config_port_awaddr	=> config_port_awaddr,
            config_port_awprot => config_port_awprot,
            config_port_awvalid	=> config_port_awvalid,
            config_port_awready	=> config_port_awready,
            config_port_wdata => config_port_wdata,
            config_port_wstrb => config_port_wstrb,
            config_port_wvalid => config_port_wvalid,
            config_port_wready => config_port_wready,
            config_port_bresp => config_port_bresp,
            config_port_bvalid => config_port_bvalid,
            config_port_bready => config_port_bready,
            config_port_araddr => config_port_araddr,
            config_port_arprot => config_port_arprot,
            config_port_arvalid	=> config_port_arvalid,
            config_port_arready	=> config_port_arready,
            config_port_rdata => config_port_rdata,
            config_port_rresp => config_port_rresp,
            config_port_rvalid => config_port_rvalid,
            config_port_rready => config_port_rready,
            mode_reg => mode_reg,
            start_addr_reg => start_addr_reg,
            size_reg => size_reg,
            error_reg => error_reg,
            mode_reg_1 => mode_reg_1,
            mode_reg_1_enable => mode_reg_1_enable,
            mode_reg_1_ready => mode_reg_1_ready);

    -- DataPort_0 accesses connected memory where
    -- the samples are stored.
    DataPort_0 : DataPort 
        port map (
            aclk => aclk,
            aresetn => aresetn,
            data_port_awaddr => data_port_awaddr,
            data_port_awprot => data_port_awprot,
            data_port_awvalid => data_port_awvalid,
            data_port_awready => data_port_awready,
            data_port_wdata => data_port_wdata,
            data_port_wstrb => data_port_wstrb,
            data_port_wvalid => data_port_wvalid,
            data_port_wready => data_port_wready,
            data_port_bresp => data_port_bresp,
            data_port_bvalid => data_port_bvalid,
            data_port_bready => data_port_bready,
            data_port_araddr => data_port_araddr,
            data_port_arprot => data_port_arprot,
            data_port_arvalid => data_port_arvalid,
            data_port_arready => data_port_arready,
            data_port_rdata => data_port_rdata,
            data_port_rresp => data_port_rresp,
            data_port_rvalid => data_port_rvalid,
            data_port_rready => data_port_rready,
            enable => data_port_enable,
            ready => data_port_ready,
            word_addr => word_addr,
            word_data => word_data,
            error_reg => error_reg); 
            
end arch_imp;
