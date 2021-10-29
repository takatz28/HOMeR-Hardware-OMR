----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2015 09:58:35 PM
-- Design Name: 
-- Module Name: ConfigPort - Behavioral
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

entity ConfigPort is
    generic (
        DEFAULT_START_ADDR : std_logic_vector := x"20000000";
        -- Parameters of Axi Slave Bus Interface config_port
        C_config_port_DATA_WIDTH    : integer    := 32;
        C_config_port_ADDR_WIDTH    : integer    := 4);
    port (
        -- Ports of Axi Synchronization port
        aclk    : in std_logic;
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
        
        -- Reg port
        mode_reg : out std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
        start_addr_reg : out std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
        size_reg : out std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
        error_reg : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
        mode_reg_1 : in std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
        mode_reg_1_enable : in std_logic;
        mode_reg_1_ready : out std_logic);
end ConfigPort;

architecture Behavioral of ConfigPort is

    constant BITS_PER_BYTE : integer := 8;
    constant ADDR_MODE_REG : integer := 0;
    constant ADDR_START_ADDR_REG : integer := 1;
    constant ADDR_SIZE_REG : integer := 2;
    constant ADDR_ERROR_REG : integer := 3;
    
    type state_config_port_w_type is (
        S_CONFIG_PORT_W_ADDRESS,
        S_CONFIG_PORT_W_CHECK,
        S_CONFIG_PORT_W_DATA,
        S_CONFIG_PORT_W_REG,
        S_CONFIG_PORT_W_RESPONSE);
    signal state_config_port_w : state_config_port_w_type := S_CONFIG_PORT_W_ADDRESS;
    signal config_port_awready_buff : std_logic;
    signal config_port_wready_buff : std_logic;
    signal config_port_bvalid_buff : std_logic;
    signal config_port_bresp_buff : std_logic_vector(1 downto 0);
    signal config_port_awaddr_buff : std_logic_vector(C_config_port_ADDR_WIDTH-1 downto 0);
    signal config_port_awprot_buff : std_logic_vector(2 downto 0);
    signal config_port_awaddr_select : std_logic_vector(C_config_port_ADDR_WIDTH-1 downto 2);
    
    type state_config_port_r_type is (
        S_CONFIG_PORT_R_ADDRESS,
        S_CONFIG_PORT_R_READ_CHECK,
        S_CONFIG_PORT_R_READ_DATA);
    signal state_config_port_r : state_config_port_r_type := S_CONFIG_PORT_R_ADDRESS;
    signal config_port_arready_buff : std_logic;
    signal config_port_rvalid_buff : std_logic;
    signal config_port_rresp_buff : std_logic_vector(1 downto 0);
    signal config_port_araddr_buff : std_logic_vector(C_config_port_ADDR_WIDTH-1 downto 0);
    signal config_port_arprot_buff : std_logic_vector(2 downto 0);
    signal config_port_araddr_select : std_logic_vector(C_config_port_ADDR_WIDTH-1 downto 2);
    
    signal mode_reg_buff : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
    signal size_reg_buff : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
    signal start_addr_reg_buff : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
    
    type state_mode_reg_type is (
        S_MODE_REG_ENABLE,
        S_MODE_REG_0_READY,
        S_MODE_REG_1_READY);
    signal state_mode_reg : state_mode_reg_type := S_MODE_REG_ENABLE;
    signal mode_reg_0_buff : std_logic_vector(C_config_port_DATA_WIDTH-1 downto 0);
    signal mode_reg_0_enable : std_logic; 
    signal mode_reg_0_ready : std_logic;
begin

    -- Register assignments.
    mode_reg <= mode_reg_buff;
    start_addr_reg <= start_addr_reg_buff;
    size_reg <= size_reg_buff;
    
    -- Mode Reg can be changed by both Config Port and AudioOut.
    process (aclk)
    begin
        if (rising_edge(aclk)) then
            if (aresetn='0') then
                mode_reg_0_ready <= '0';
                mode_reg_1_ready <= '0';
                mode_reg_buff <= (others => '0');
                state_mode_reg <= S_MODE_REG_ENABLE;
            else
                case state_mode_reg is
                    when S_MODE_REG_ENABLE =>
                        mode_reg_0_ready <= '0';
                        mode_reg_1_ready <= '0';
                        if (mode_reg_0_enable='1') then
                            mode_reg_buff <= mode_reg_0_buff;
                            state_mode_reg <= S_MODE_REG_0_READY;
                        elsif (mode_reg_1_enable='1') then
                            mode_reg_buff <= mode_reg_1;
                            state_mode_reg <= S_MODE_REG_1_READY;
                        end if;
                    when S_MODE_REG_0_READY =>
                        mode_reg_0_ready <= '1';
                        if (mode_reg_0_enable='0') then
                            state_mode_reg <= S_MODE_REG_ENABLE;
                        end if;
                    when S_MODE_REG_1_READY =>
                        mode_reg_1_ready <= '1';
                        if (mode_reg_1_enable='0') then
                            state_mode_reg <= S_MODE_REG_ENABLE;
                        end if;
                    when others =>
                        state_mode_reg <= S_MODE_REG_ENABLE;
                end case;
            end if; 
        end if;
    end process;

    -- Config Port Slave AXI4-Lite Write Interface
    config_port_awready <= config_port_awready_buff;
    config_port_wready <= config_port_wready_buff;
    config_port_bvalid <= config_port_bvalid_buff;
    config_port_bresp <= config_port_bresp_buff;
    config_port_awaddr_select <= config_port_awaddr_buff(
            config_port_awaddr_buff'high downto 
            config_port_awaddr_buff'low+2);
    process (aclk)
    begin
        if (rising_edge(aclk)) then
            if (aresetn='0') then
                state_config_port_w <= S_CONFIG_PORT_W_ADDRESS;
                config_port_awready_buff <= '0';
                config_port_wready_buff <= '0';
                config_port_bvalid_buff <= '0';
                config_port_bresp_buff <= (others => '0');
                config_port_awaddr_buff <= (others => '0');
                config_port_awprot_buff <= (others => '0');
                mode_reg_0_enable <= '0';
                mode_reg_0_buff <= (others => '0');
                start_addr_reg_buff <= DEFAULT_START_ADDR;
                size_reg_buff <= (others => '0');
            else
                case state_config_port_w is
                    when S_CONFIG_PORT_W_ADDRESS =>
                        -- Sample from AXI4-Lite Write Address Channel
                        if (config_port_awready_buff='1' and config_port_awvalid='1') then
                            config_port_awready_buff <= '0';
                            config_port_awaddr_buff <= config_port_awaddr;
                            config_port_awprot_buff <= config_port_awprot;
                            state_config_port_w <= S_CONFIG_PORT_W_CHECK;
                        else
                            config_port_awready_buff <= '1';
                        end if;
                    when S_CONFIG_PORT_W_CHECK =>
                        -- Check for errors.
                        if ((config_port_awaddr_buff(1 downto 0)/="00") or
                                (config_port_awprot_buff(2)/='0')) then
                            config_port_bresp_buff <= "10";
                        else
                            config_port_bresp_buff <= "00";
                        end if;
                        state_config_port_w <= S_CONFIG_PORT_W_DATA;
                    when S_CONFIG_PORT_W_DATA =>
                        if (config_port_wready_buff='1' and config_port_wvalid='1') then
                            -- Write data based on address and write strobe.
                            for i in 0 to config_port_wstrb'high loop
                                if (to_integer(unsigned(config_port_awaddr_select))=
                                        ADDR_MODE_REG) then
                                    if (config_port_wstrb(i)='1') then
                                        mode_reg_0_buff(BITS_PER_BYTE*(i+1)-1 downto 
                                            i*BITS_PER_BYTE) <= 
                                            config_port_wdata(BITS_PER_BYTE*(i+1)-1 downto 
                                            i*BITS_PER_BYTE);
                                    end if;
                                elsif (to_integer(unsigned(config_port_awaddr_select))=
                                        ADDR_START_ADDR_REG) then
                                    start_addr_reg_buff(BITS_PER_BYTE*(i+1)-1 downto 
                                            i*BITS_PER_BYTE) <= 
                                            config_port_wdata(BITS_PER_BYTE*(i+1)-1 downto 
                                            i*BITS_PER_BYTE);
                                elsif (to_integer(unsigned(config_port_awaddr_select))=
                                        ADDR_SIZE_REG) then
                                    size_reg_buff(BITS_PER_BYTE*(i+1)-1 downto 
                                            i*BITS_PER_BYTE) <= 
                                            config_port_wdata(BITS_PER_BYTE*(i+1)-1 downto 
                                            i*BITS_PER_BYTE);
                                end if;
                            end loop;
                            config_port_wready_buff <= '0';
                            state_config_port_w <= S_CONFIG_PORT_W_REG;
                        else
                            config_port_wready_buff <= '1';
                        end if;
                    when S_CONFIG_PORT_W_REG =>
                        -- We need to ensure the mode register can be changed
                        -- by both Config Port and AudioOut.
                        if (to_integer(unsigned(config_port_awaddr_select))=
                                ADDR_MODE_REG) then
                            if (mode_reg_0_enable='1' and mode_reg_0_ready='1') then
                                mode_reg_0_enable <= '0';
                                state_config_port_w <= S_CONFIG_PORT_W_RESPONSE;
                            else
                                mode_reg_0_enable <= '1';
                            end if;
                        else
                            state_config_port_w <= S_CONFIG_PORT_W_RESPONSE;
                        end if;
                    when S_CONFIG_PORT_W_RESPONSE =>
                        if (config_port_bvalid_buff='1' and config_port_bready='1') then
                            config_port_bvalid_buff <= '0';
                            state_config_port_w <= S_CONFIG_PORT_W_ADDRESS;
                        else
                            config_port_bvalid_buff <= '1';
                        end if;
                    when others =>
                        state_config_port_w <= S_CONFIG_PORT_W_ADDRESS;
                end case;
            end if;
        end if;
    end process;
    
    -- Config Port Slave AXI4-Lite Read Interface
    config_port_arready <= config_port_arready_buff;
    config_port_rvalid <= config_port_rvalid_buff;
    config_port_rresp <= config_port_rresp_buff;
    config_port_araddr_select <= config_port_araddr_buff(
        config_port_araddr_buff'high downto 
        config_port_araddr_buff'low+2);
    process (aclk)
    begin
        if (rising_edge(aclk)) then
            if (aresetn='0') then
                state_config_port_r <= S_CONFIG_PORT_R_ADDRESS;
                config_port_araddr_buff <= (others => '0');
                config_port_arprot_buff <= (others => '0');
                config_port_arready_buff <= '0';
                config_port_rvalid_buff <= '0';
                config_port_rdata <= (others => '0');
                config_port_rresp_buff <= (others => '0');
            else
                case state_config_port_r is
                    when S_CONFIG_PORT_R_ADDRESS =>
                        if (config_port_arready_buff='1' and
                                config_port_arvalid='1') then
                            state_config_port_r <= S_CONFIG_PORT_R_READ_CHECK;
                            config_port_araddr_buff <= config_port_araddr;
                            config_port_arprot_buff <= config_port_arprot;
                            config_port_arready_buff <= '0';
                        else
                            config_port_arready_buff <= '1';
                        end if;
                    when S_CONFIG_PORT_R_READ_CHECK =>
                        -- Check for errors.
                        if ((config_port_araddr_buff(1 downto 0)/="00") or
                                (config_port_arprot_buff(2)/='0')) then
                            config_port_rresp_buff <= "10";
                        else
                            config_port_rresp_buff <= "00";
                        end if;
                        -- Read data based on address.
                        if (to_integer(unsigned(config_port_araddr_select))=
                                ADDR_MODE_REG) then
                            config_port_rdata <= mode_reg_buff;
                        elsif (to_integer(unsigned(config_port_araddr_select))=
                                ADDR_START_ADDR_REG) then
                            config_port_rdata <= start_addr_reg_buff;
                        elsif (to_integer(unsigned(config_port_araddr_select))=
                                ADDR_SIZE_REG) then
                            config_port_rdata <= size_reg_buff;
                        elsif (to_integer(unsigned(config_port_araddr_select))=
                                ADDR_ERROR_REG) then
                            config_port_rdata <= error_reg;
                        else
                            config_port_rdata <= (others => '0');
                        end if;
                        state_config_port_r <= S_CONFIG_PORT_R_READ_DATA;
                    when S_CONFIG_PORT_R_READ_DATA =>
                        if (config_port_rvalid_buff='1' and 
                                config_port_rready='1') then
                            state_config_port_r <= S_CONFIG_PORT_R_ADDRESS;
                            config_port_rvalid_buff <= '0';
                        else
                            config_port_rvalid_buff <= '1';
                        end if;
                    when others =>
                        state_config_port_r <= S_CONFIG_PORT_R_ADDRESS;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
