----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2015 12:22:07 AM
-- Design Name: 
-- Module Name: DataPort - Behavioral
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

entity DataPort is
    generic (
        -- Data Port parameters
        C_data_port_ADDR_WIDTH	: integer	:= 32;
        C_data_port_DATA_WIDTH    : integer    := 32);
    port (
        -- Ports of Axi Synchronization port
        aclk    : in std_logic;
        aresetn    : in std_logic;
    
        -- Ports of Axi Master Bus Interface data_port
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
        
        -- Data interface with Controller
        enable : in std_logic;
        ready : out std_logic;
        word_addr : in std_logic_vector(C_data_port_ADDR_WIDTH-1 downto 0);
        word_data : out std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0);
        error_reg : out std_logic_vector(C_data_port_DATA_WIDTH-1 downto 0)); 
end DataPort;

architecture Behavioral of DataPort is
    
    type state_data_port_r_type is (
        S_DATA_PORT_R_ENABLE,
        S_DATA_PORT_R_ADDRESS,
        S_DATA_PORT_R_READ_CHECK,
        S_DATA_PORT_R_READY,
        S_DATA_PORT_R_ERROR);
    signal state_data_port_r : state_data_port_r_type := S_DATA_PORT_R_ENABLE;
    signal data_port_arvalid_buff : std_logic;
    signal data_port_rready_buff : std_logic; 
    signal data_port_rresp_buff : std_logic_vector(1 downto 0);

begin

    -- Data Port Master AXI4-Lite Write Interface (Dummy)
    data_port_awaddr <= (others => '0');
    data_port_awprot <= (others => '0');
    data_port_awvalid <= '0';
    data_port_wdata <= (others => '0');
    data_port_wstrb <= (others => '0');
    data_port_wvalid <= '0';
    data_port_bready <= '0';

    -- Data Port Master AXI4-Lite Read Interface
    data_port_arvalid <= data_port_arvalid_buff;
    data_port_rready <= data_port_rready_buff;
    data_port_arprot <= "000";
    process (aclk)
    begin
        if (rising_edge(aclk)) then
            if (aresetn='0') then
                data_port_araddr <= (others => '0');
                data_port_arvalid_buff <= '0';
                data_port_rresp_buff <= (others => '0');
                data_port_rready_buff <= '0';
                state_data_port_r <= S_DATA_PORT_R_ENABLE;
                error_reg <= (others => '0');
                ready <= '0';
            else
                case state_data_port_r is
                    when S_DATA_PORT_R_ENABLE =>
                        ready <= '0';
                        if (enable='1') then
                            data_port_araddr <= word_addr;
                            state_data_port_r <= S_DATA_PORT_R_ADDRESS;
                        end if;
                    when S_DATA_PORT_R_ADDRESS =>
                        if (data_port_arvalid_buff='1' and data_port_arready='1') then
                            data_port_arvalid_buff <= '0';
                            state_data_port_r <= S_DATA_PORT_R_READ_CHECK;
                        else
                            data_port_arvalid_buff <= '1';
                        end if;
                    when S_DATA_PORT_R_READ_CHECK =>
                        if (data_port_rready_buff='1' and data_port_rvalid='1') then
                            if (data_port_rresp="00") then
                                state_data_port_r <= S_DATA_PORT_R_READY;
                            else
                                data_port_rresp_buff <= data_port_rresp;
                                state_data_port_r <= S_DATA_PORT_R_ERROR;
                            end if;
                            data_port_rready_buff <= '0';
                            word_data <= data_port_rdata;
                        else
                            data_port_rready_buff <= '1';
                        end if;
                    when S_DATA_PORT_R_READY =>
                        ready <= '1';
                        if (enable='0') then
                            state_data_port_r <= S_DATA_PORT_R_ENABLE;
                        end if;
                    when S_DATA_PORT_R_ERROR =>
                        error_reg(data_port_rresp_buff'high downto data_port_rresp_buff'low) <=
                            data_port_rresp_buff;
                    when others =>
                        state_data_port_r <= S_DATA_PORT_R_ENABLE;
                end case;
            end if;
        end if;
    end process;

end Behavioral;
