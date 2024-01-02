
----------------------------------------------------------------------------------
-- Company: Pentek, Inc.
-- Engineer: 
-- 
-- Create Date: 08/19/2018 07:28:49 AM
-- Design Name: 
-- Module Name: fifo_ctl_src_sel - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: FIFO Path Control Source Select
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
-- Register Map
-- 0x00 - Reset Control Register
--   [0] -  Ch0 src_sel 
--   [1] -  Ch1 src_sel 
--   [2] -  Ch2 src_sel 
--   [3] -  Ch3 src_sel  
--   [4] -  Fifo Reset all Channels 
-- 0x04 - Status Register
--   [16:0] -  Ch0 Selected Size Control
--   [17]   -  Ch0 Selected Size Control Enable
-- 0x08 - Status Register
--   [16:0] -  Ch1 Selected Size Control
--   [17]   -  Ch1 Selected Size Control Enable
-- 0x0C - Status Register
--   [16:0] -  Ch2 Selected Size Control
--   [17]   -  Ch2 Selected Size Control Enable
-- 0x10 - Status Register
--   [16:0] -  Ch3 Selected Size Control
--   [17]   -  Ch3 Selected Size Control Enable
    
----------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Libraries
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.ALL;

Library xpm;
use xpm.vcomponents.all;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifo_ctl_src_sel is
port (
----------------------------------------------------------------------------
-- Control/Status Registers (AXI4-LITE)
----------------------------------------------------------------------------
   -- associated with s_axi_csr_aclk
   s_axi_csr_aclk           : in  std_logic;
   s_axi_csr_aresetn        : in  std_logic;
   s_axi_csr_awaddr         : in  std_logic_vector(11 downto 0);
   s_axi_csr_awprot         : in  std_logic_vector(2 downto 0);
   s_axi_csr_awvalid        : in  std_logic;
   s_axi_csr_awready        : out std_logic;
   s_axi_csr_wdata          : in  std_logic_vector(31 downto 0);
   s_axi_csr_wstrb          : in  std_logic_vector(3 downto 0);
   s_axi_csr_wvalid         : in  std_logic;
   s_axi_csr_wready         : out std_logic;
   s_axi_csr_bresp          : out std_logic_vector(1 downto 0);
   s_axi_csr_bvalid         : out std_logic;
   s_axi_csr_bready         : in  std_logic;
   s_axi_csr_araddr         : in  std_logic_vector(11 downto 0);
   s_axi_csr_arprot         : in  std_logic_vector(2 downto 0);
   s_axi_csr_arvalid        : in  std_logic;
   s_axi_csr_arready        : out std_logic;
   s_axi_csr_rdata          : out std_logic_vector(31 downto 0);
   s_axi_csr_rresp          : out std_logic_vector(1 downto 0);
   s_axi_csr_rvalid         : out std_logic;
   s_axi_csr_rready         : in  std_logic;
----------------------------------------------------------------------------
-- Data Clocks
----------------------------------------------------------------------------
   axis_ppld_aclk           : in  std_logic;
   txclk                    : in  std_logic;
----------------------------------------------------------------------------
-- Control Output Signals
----------------------------------------------------------------------------   
   -- Synchronous with axis_ppld_aclk
   ch0_override_pkt_size    : out std_logic_vector(16 downto 0);
   ch0_override_pkt_size_en : out std_logic;
   ch1_override_pkt_size    : out std_logic_vector(16 downto 0);
   ch1_override_pkt_size_en : out std_logic;
   ch2_override_pkt_size    : out std_logic_vector(16 downto 0);
   ch2_override_pkt_size_en : out std_logic;
   ch3_override_pkt_size    : out std_logic_vector(16 downto 0);
   ch3_override_pkt_size_en : out std_logic;
   ch0_fifo_aresetn         : out std_logic;
   ch1_fifo_aresetn         : out std_logic;
   ch2_fifo_aresetn         : out std_logic;
   ch3_fifo_aresetn         : out std_logic;
----------------------------------------------------------------------------
-- Control Input Signals
----------------------------------------------------------------------------   
   -- Synchronous with axis_ppld_aclk
   ch0a_pkt_size            : in  std_logic_vector(16 downto 0);
   ch0a_pkt_size_en         : in  std_logic;
   ch1a_pkt_size            : in  std_logic_vector(16 downto 0);
   ch1a_pkt_size_en         : in  std_logic;
   ch2a_pkt_size            : in  std_logic_vector(16 downto 0);
   ch2a_pkt_size_en         : in  std_logic;
   ch3a_pkt_size            : in  std_logic_vector(16 downto 0);
   ch3a_pkt_size_en         : in  std_logic;
   -- Synchronous with txclk
   ch0b_pkt_size            : in  std_logic_vector(16 downto 0);
   ch0b_pkt_size_en         : in  std_logic;
   ch1b_pkt_size            : in  std_logic_vector(16 downto 0);
   ch1b_pkt_size_en         : in  std_logic;
   ch2b_pkt_size            : in  std_logic_vector(16 downto 0);
   ch2b_pkt_size_en         : in  std_logic;
   ch3b_pkt_size            : in  std_logic_vector(16 downto 0);
   ch3b_pkt_size_en         : in  std_logic;
   -- Synchronous with axis_ppld_aclk
   ch0a_fifo_aresetn        : in  std_logic;
   ch1a_fifo_aresetn        : in  std_logic;
   ch2a_fifo_aresetn        : in  std_logic;
   ch3a_fifo_aresetn        : in  std_logic;
   -- Synchronous with txclk
   ch0b_fifo_aresetn        : in  std_logic;
   ch1b_fifo_aresetn        : in  std_logic;
   ch2b_fifo_aresetn        : in  std_logic;
   ch3b_fifo_aresetn        : in  std_logic
);
end fifo_ctl_src_sel;

architecture Behavioral of fifo_ctl_src_sel is

ATTRIBUTE X_INTERFACE_INFO : STRING;
-- Supported parameter: POLARITY {ACTIVE_LOW, ACTIVE_HIGH}
-- Normally active low is assumed.  Use this parameter to force the level
ATTRIBUTE X_INTERFACE_PARAMETER : STRING;

ATTRIBUTE X_INTERFACE_INFO of ch0_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch0_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch0_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch1_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch1_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch1_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch2_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch2_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch2_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch3_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch3_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch3_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch0a_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch0a_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch0a_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch1a_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch1a_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch1a_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch2a_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch2a_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch2a_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch3a_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch3a_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch3a_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch0b_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch0b_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch0b_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch1b_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch1b_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch1b_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch2b_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch2b_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch2b_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of ch3b_fifo_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 ch3b_fifo_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of ch3b_fifo_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of s_axi_csr_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 s_axi_csr_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of s_axi_csr_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of s_axi_csr_aclk: SIGNAL is "xilinx.com:signal:clock:1.0 s_axi_csr_aclk CLK";
ATTRIBUTE X_INTERFACE_PARAMETER of s_axi_csr_aclk: SIGNAL is "ASSOCIATED_BUSIF s_axi_csr, ASSOCIATED_RESET s_axi_csr_aresetn";

ATTRIBUTE X_INTERFACE_INFO of axis_ppld_aclk: SIGNAL is "xilinx.com:signal:clock:1.0 axis_ppld_aclk CLK";
ATTRIBUTE X_INTERFACE_PARAMETER of axis_ppld_aclk: SIGNAL is "ASSOCIATED_RESET ch0_fifo_aresetn:ch1_fifo_aresetn:ch2_fifo_aresetn:ch3_fifo_aresetn:ch0a_fifo_aresetn:ch1a_fifo_aresetn:ch2a_fifo_aresetn:ch3a_fifo_aresetn";

ATTRIBUTE X_INTERFACE_INFO of txclk: SIGNAL is "xilinx.com:signal:clock:1.0 txclk CLK";
ATTRIBUTE X_INTERFACE_PARAMETER of txclk: SIGNAL is "ASSOCIATED_RESET ch0b_fifo_aresetn:ch1b_fifo_aresetn:ch2b_fifo_aresetn:ch3b_fifo_aresetn";


-------------------------------------------------------------------------------
-- Types
-------------------------------------------------------------------------------

type state_type is
(
    RESET_STATE,
    WR_ADDR_DATA_STATE,
    WR_DATA_STATE,
    WR_ADDR2_STATE,
    WR_ADDR_STATE,
    WR_DATA2_STATE,
    WR_ADDR_DEC_STATE,
    WR_B_RSP_STATE,
    RD_ADDR_STATE,
    WAIT_RD_BS_STATE,
    WAIT_RD_CMPLT_STATE,
    WAIT_RDDATA_RDY_STATE
);

type ctl_reg_array is array (0 to 0) of std_logic_vector(31 downto 0);
type stat_reg_array is array (0 to 3) of std_logic_vector(31 downto 0);

constant num_ctl_regs      : integer := 1;

-------------------------------------------------------------------------------
-- Signals
-------------------------------------------------------------------------------

signal w_addr           : std_logic_vector(4 downto 0) := (others => '0');
signal r_addr           : std_logic_vector(4 downto 0) := (others => '0');
signal state            : state_type := RESET_STATE;
signal rd_data          : std_logic_vector(31 downto 0)  := (others => '0');
signal w_data           : std_logic_vector(31 downto 0)  := (others => '0');
signal w_strb           : std_logic := '0';
signal src_senda        : std_logic:= '0';
signal src_rcva         : std_logic:= '0';
signal dest_reqa        : std_logic:= '0';
signal t1_s_axi_csr_aresetn: std_logic:= '0';
signal wr_strb          : std_logic_vector(3 downto 0) := "0000";
signal w_we             : std_logic := '0'; 
signal w_addr_num       : integer := 0;
signal r_addr_num       : integer := 0;
signal cntl_reg         : ctl_reg_array;
signal stat_reg         : stat_reg_array;
signal stat0_vctr       : std_logic_vector(17 downto 0) := (others => '0');
signal stat1_vctr       : std_logic_vector(17 downto 0) := (others => '0');
signal stat2_vctr       : std_logic_vector(17 downto 0) := (others => '0');
signal stat3_vctr       : std_logic_vector(17 downto 0) := (others => '0');
signal stat0_in         : std_logic_vector(31 downto 0) := (others => '0');
signal stat1_in         : std_logic_vector(31 downto 0) := (others => '0');
signal stat2_in         : std_logic_vector(31 downto 0) := (others => '0');
signal stat3_in         : std_logic_vector(31 downto 0) := (others => '0');
signal cntl_reg_x       : std_logic_vector(4 downto 0) := (others => '0');
signal ch0_pkt_size_en_sel: std_logic := '0';
signal ch0_pkt_size_sel: std_logic_vector(16 downto 0) := (others => '0');
signal ch1_pkt_size_en_sel: std_logic := '0';
signal ch1_pkt_size_sel: std_logic_vector(16 downto 0) := (others => '0');
signal ch2_pkt_size_en_sel: std_logic := '0';
signal ch2_pkt_size_sel: std_logic_vector(16 downto 0) := (others => '0');
signal ch3_pkt_size_en_sel: std_logic := '0';
signal ch3_pkt_size_sel: std_logic_vector(16 downto 0) := (others => '0');
signal ctlb0: std_logic_vector(18 downto 0) := (others => '0');
signal ctlb1: std_logic_vector(18 downto 0) := (others => '0');
signal ctlb2: std_logic_vector(18 downto 0) := (others => '0');
signal ctlb3: std_logic_vector(18 downto 0) := (others => '0');
signal ctlb0_x: std_logic_vector(18 downto 0) := (others => '0');
signal ctlb1_x: std_logic_vector(18 downto 0) := (others => '0');
signal ctlb2_x: std_logic_vector(18 downto 0) := (others => '0');
signal ctlb3_x: std_logic_vector(18 downto 0) := (others => '0');
-------------------------------------------------------------------------------


begin

-------------------------------------------------------------------------------
-- AXI4-Lite Interface State Machine
-------------------------------------------------------------------------------

process(s_axi_csr_aclk)
begin
    if rising_edge(s_axi_csr_aclk) then
        t1_s_axi_csr_aresetn <= s_axi_csr_aresetn;
        if t1_s_axi_csr_aresetn = '0' then
           state <= RESET_STATE;
           s_axi_csr_awready <= '0'; 
           s_axi_csr_wready  <= '0';  
           s_axi_csr_arready <= '0'; 
           s_axi_csr_rvalid  <= '0';  
           s_axi_csr_bvalid  <= '0';
           w_we              <= '0'; 
		     wr_strb           <= "0000";
        else 
           case state is 
            when RESET_STATE =>
                if (s_axi_csr_aresetn = '0') then
                    state <= RESET_STATE;
                    s_axi_csr_awready <= '0';
                    s_axi_csr_wready <= '0';
                    s_axi_csr_arready <= '0'; 
                    s_axi_csr_rvalid  <= '0';  
                    s_axi_csr_bvalid  <= '0';   
                    w_we             <= '0'; 
		         wr_strb           <= "0000";
                elsif (s_axi_csr_awvalid = '1') then  
                    if (s_axi_csr_wvalid = '1') then
                        state <=  WR_ADDR_DATA_STATE;
                    else
                        state <=  WR_ADDR_STATE;
                    end if; 
                elsif (s_axi_csr_wvalid = '1') then
                    state <=  WR_DATA_STATE;
                elsif (s_axi_csr_arvalid = '1') then
                    state <=  RD_ADDR_STATE;
                else
                    state <= RESET_STATE;
                end if;    
             when WR_ADDR_DATA_STATE =>
                s_axi_csr_wready <= '1';
                s_axi_csr_awready <= '1';  
                w_data <= s_axi_csr_wdata;
                wr_strb <= s_axi_csr_wstrb;     
                w_addr <= s_axi_csr_awaddr(4 downto 0); 
                state  <= WR_ADDR_DEC_STATE;
             when WR_DATA_STATE =>
                s_axi_csr_wready <= '1';
                w_data <= s_axi_csr_wdata;
                wr_strb <= s_axi_csr_wstrb;
                state  <= WR_ADDR2_STATE;
             when WR_ADDR2_STATE =>
                s_axi_csr_wready <= '0';
                if (s_axi_csr_awvalid = '1') then      
                   state  <= WR_ADDR_DEC_STATE;
                   w_addr <= s_axi_csr_awaddr(4 downto 0);
                   s_axi_csr_awready <= '1';
                else
                   state  <= WR_ADDR2_STATE;
                end if;  
             when WR_ADDR_STATE =>
                   s_axi_csr_awready <= '1';
                   w_addr <= s_axi_csr_awaddr(4 downto 0);
                   state  <= WR_DATA2_STATE;
             when WR_DATA2_STATE =>
                s_axi_csr_awready <= '0';
                if (s_axi_csr_wvalid = '1') then      
                   state  <= WR_ADDR_DEC_STATE;
                   w_data <= s_axi_csr_wdata;
		             wr_strb <= s_axi_csr_wstrb;
                   s_axi_csr_wready <= '1';
                else
                   state  <= WR_DATA2_STATE;
                end if;    
             when WR_ADDR_DEC_STATE =>
                w_we          <= '1';   
                s_axi_csr_wready  <= '0';
                s_axi_csr_awready <= '0';   
                state         <= WR_B_RSP_STATE;
                s_axi_csr_bresp   <= "00";
                s_axi_csr_bvalid  <= '1';     
            when  WR_B_RSP_STATE =>
                w_we             <= '0';  
                if s_axi_csr_bready = '1' then
                    s_axi_csr_bvalid <= '0';
                    state <= RESET_STATE;
                else
                    state <= WR_B_RSP_STATE;
                end if;    
            when  RD_ADDR_STATE =>
               s_axi_csr_arready <= '1';
               r_addr        <= s_axi_csr_araddr(4 downto 0);
               state         <= WAIT_RD_BS_STATE;     
            when WAIT_RD_BS_STATE =>
                s_axi_csr_arready <= '0';    
                state   <=  WAIT_RD_CMPLT_STATE;
            when WAIT_RD_CMPLT_STATE =>
                s_axi_csr_rdata  <= rd_data;
                s_axi_csr_rvalid <= '1'; 
                s_axi_csr_rresp  <= "00";
                state <= WAIT_RDDATA_RDY_STATE;                   
            when WAIT_RDDATA_RDY_STATE =>   
                if s_axi_csr_rready = '1' then
                    s_axi_csr_rvalid <= '0';
                    state <= RESET_STATE;
                else
                   state <= WAIT_RDDATA_RDY_STATE;     
                end if;  
            when others =>
               state <= RESET_STATE;
          end case;
       end if;
   end if;  
end process;

--------------------------------------------------------------------------------
-- Control Registers
--------------------------------------------------------------------------------

w_addr_num <= conv_integer(w_addr(4 downto 2));


gen_ctl_regs: for i in 0 to 0 generate

process(s_axi_csr_aclk)
begin
    if rising_edge(s_axi_csr_aclk) then
      if  t1_s_axi_csr_aresetn = '0' then
         -- Initialize when reset
         case i is
            when 0 =>
               cntl_reg(i)(31 downto 0) <= x"00000000";
            when others =>
               cntl_reg(i)(31 downto 0) <= x"00000000"; 
          end case;                 
      else
          if  (w_we = '1') then  
            if (w_addr_num = i) then
               if wr_strb(0) = '1' then
                   cntl_reg(i)(7 downto 0) <= w_data(7 downto 0);
               end if;
			      if wr_strb(1) = '1' then
                   cntl_reg(i)(15 downto 8) <= w_data(15 downto 8);
		         end if;
			      if wr_strb(2) = '1' then
                   cntl_reg(i)(23 downto 16) <= w_data(23 downto 16);
		         end if;
			      if wr_strb(3) = '1' then
                   cntl_reg(i)(31 downto 24) <= w_data(31 downto 24);
		         end if;
            end if;
          end if;     
      end if;
    end if;
end process;

end generate;


gen_stat_regs: for i in 0 to 3 generate

process(s_axi_csr_aclk)
begin
   if rising_edge(s_axi_csr_aclk) then
      case i is
         when 0 =>
            stat_reg(i)(31 downto 0) <= stat0_in;
         when 1 =>
            stat_reg(i)(31 downto 0) <= stat1_in;
         when 2 =>
            stat_reg(i)(31 downto 0) <= stat2_in;
         when 3 =>
            stat_reg(i)(31 downto 0) <= stat3_in;
         when others =>
            stat_reg(i)(31 downto 0) <= x"00000000"; 
       end case;                 
   end if;
end process;

end generate;

stat0_in(31 downto 18) <= (others => '0');
stat1_in(31 downto 18) <= (others => '0');
stat2_in(31 downto 18) <= (others => '0');
stat3_in(31 downto 18) <= (others => '0');

xpm_cdc_stat0_inst : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 3,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 1,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 18           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => stat0_in(17 downto 0), -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.
      dest_clk => s_axi_csr_aclk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk  => axis_ppld_aclk,   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in   => stat0_vctr     -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.
   );
   
xpm_cdc_stat1_inst : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 3,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 1,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 18           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => stat1_in(17 downto 0), -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.
      dest_clk => s_axi_csr_aclk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk  => axis_ppld_aclk,   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in   => stat1_vctr     -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.
   );
   
xpm_cdc_stat2_inst : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 3,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 1,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 18           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => stat2_in(17 downto 0), -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.
      dest_clk => s_axi_csr_aclk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk  => axis_ppld_aclk,   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in   => stat2_vctr     -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.
   );
         
xpm_cdc_stat3_inst : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 3,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 1,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 18           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => stat3_in(17 downto 0), -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.
      dest_clk => s_axi_csr_aclk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk  => axis_ppld_aclk,   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in   => stat3_vctr     -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.
   );

stat0_vctr <= ch0_pkt_size_en_sel & ch0_pkt_size_sel;
stat1_vctr <= ch1_pkt_size_en_sel & ch1_pkt_size_sel;
stat2_vctr <= ch2_pkt_size_en_sel & ch2_pkt_size_sel;
stat3_vctr <= ch3_pkt_size_en_sel & ch3_pkt_size_sel;

---------------------------------------------------------------------------------------------------
-- Clock Domain Crossing for 100Ge Controls
---------------------------------------------------------------------------------------------------

ctlb0 <= ch0b_fifo_aresetn & ch0b_pkt_size_en & ch0b_pkt_size;
ctlb1 <= ch1b_fifo_aresetn & ch1b_pkt_size_en & ch1b_pkt_size;
ctlb2 <= ch2b_fifo_aresetn & ch2b_pkt_size_en & ch2b_pkt_size;
ctlb3 <= ch3b_fifo_aresetn & ch3b_pkt_size_en & ch3b_pkt_size;

xpm_cdc_ctlb0_inst : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 3,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 1,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 19           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => ctlb0_x, -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.
      dest_clk => axis_ppld_aclk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk  => txclk,   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in   => ctlb0     -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.
   );
   
xpm_cdc_ctlb1_inst : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 3,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 1,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 19           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => ctlb1_x, -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.
      dest_clk => axis_ppld_aclk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk  => txclk,   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in   => ctlb1     -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.
   );
   
xpm_cdc_ctlb2_inst : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 3,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 1,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 19           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => ctlb2_x, -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.
      dest_clk => axis_ppld_aclk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk  => txclk,   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in   => ctlb2     -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.
   );
         
xpm_cdc_ctlb3_inst : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 3,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 1,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 19           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => ctlb3_x, -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.
      dest_clk => axis_ppld_aclk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk  => txclk,   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in   => ctlb3     -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.
   );

--------------------------------------------------------------------------------
-- Read Registers
--------------------------------------------------------------------------------

r_addr_num <= conv_integer(r_addr(r_addr'length - 1 downto 2));

process(s_axi_csr_aclk)
begin
   if rising_edge(s_axi_csr_aclk) then
      if (r_addr_num < num_ctl_regs) then -- Control regs
         rd_data <= cntl_reg(r_addr_num);
      else -- Status regs
         rd_data <= stat_reg(r_addr_num - num_ctl_regs);
      end if;
   end if;
end process;   

--------------------------------------------------------------------------------
-- Control Outputs
--------------------------------------------------------------------------------

xpm_cdc_ctl_inst : xpm_cdc_array_single
   generic map (
      DEST_SYNC_FF => 3,   -- DECIMAL; range: 2-10
      INIT_SYNC_FF => 1,   -- DECIMAL; integer; 0=disable simulation init values, 1=enable simulation init
                           -- values
      SIM_ASSERT_CHK => 0, -- DECIMAL; integer; 0=disable simulation messages, 1=enable simulation messages
      SRC_INPUT_REG => 1,  -- DECIMAL; 0=do not register input, 1=register input
      WIDTH => 5           -- DECIMAL; range: 1-1024
   )
   port map (
      dest_out => cntl_reg_x, -- WIDTH-bit output: src_in synchronized to the destination clock domain. This
                            -- output is registered.
      dest_clk => axis_ppld_aclk, -- 1-bit input: Clock signal for the destination clock domain.
      src_clk  => s_axi_csr_aclk,   -- 1-bit input: optional; required when SRC_INPUT_REG = 1
      src_in   => cntl_reg(0)(4 downto 0)     -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                            -- domain. It is assumed that each bit of the array is unrelated to the others.
                            -- This is reflected in the constraints applied to this macro. To transfer a binary
                            -- value losslessly across the two clock domains, use the XPM_CDC_GRAY macro
                            -- instead.
   );
   
process(axis_ppld_aclk)
begin
   if rising_edge(axis_ppld_aclk) then
      if (cntl_reg_x(0) = '0') then
         ch0_override_pkt_size    <= ch0a_pkt_size;
         ch0_override_pkt_size_en <= ch0a_pkt_size_en;
         ch0_fifo_aresetn         <= ch0a_fifo_aresetn and (not cntl_reg_x(4));
         ch0_pkt_size_sel         <= ch0a_pkt_size;    
         ch0_pkt_size_en_sel      <= ch0a_pkt_size_en; 
      else
         ch0_override_pkt_size    <= ctlb0_x(16 downto 0);
         ch0_override_pkt_size_en <= ctlb0_x(17);
         ch0_fifo_aresetn         <= ctlb0_x(18) and (not cntl_reg_x(4));    
         ch0_pkt_size_sel         <= ctlb0_x(16 downto 0);   
         ch0_pkt_size_en_sel      <= ctlb0_x(17);           
      end if;
      if (cntl_reg_x(1) = '0') then
         ch1_override_pkt_size    <= ch1a_pkt_size;
         ch1_override_pkt_size_en <= ch1a_pkt_size_en;
         ch1_fifo_aresetn         <= ch1a_fifo_aresetn and (not cntl_reg_x(4));
         ch1_pkt_size_sel         <= ch1a_pkt_size;    
         ch1_pkt_size_en_sel      <= ch1a_pkt_size_en; 
      else
         ch1_override_pkt_size    <= ctlb1_x(16 downto 0);
         ch1_override_pkt_size_en <= ctlb1_x(17);
         ch1_fifo_aresetn         <= ctlb1_x(18) and (not cntl_reg_x(4));    
         ch1_pkt_size_sel         <= ctlb1_x(16 downto 0);   
         ch1_pkt_size_en_sel      <= ctlb1_x(17);                   
      end if;
      if (cntl_reg_x(2) = '0') then
         ch2_override_pkt_size    <= ch2a_pkt_size;
         ch2_override_pkt_size_en <= ch2a_pkt_size_en;
         ch2_fifo_aresetn         <= ch2a_fifo_aresetn and (not cntl_reg_x(4));
         ch2_pkt_size_sel         <= ch2a_pkt_size;    
         ch2_pkt_size_en_sel      <= ch2a_pkt_size_en; 
      else
         ch2_override_pkt_size    <= ctlb2_x(16 downto 0);
         ch2_override_pkt_size_en <= ctlb2_x(17);
         ch2_fifo_aresetn         <= ctlb2_x(18) and (not cntl_reg_x(4));    
         ch2_pkt_size_sel         <= ctlb2_x(16 downto 0);   
         ch2_pkt_size_en_sel      <= ctlb2_x(17);                    
      end if;
      if (cntl_reg_x(3) = '0') then
         ch3_override_pkt_size    <= ch3a_pkt_size;
         ch3_override_pkt_size_en <= ch3a_pkt_size_en;
         ch3_fifo_aresetn         <= ch3a_fifo_aresetn and (not cntl_reg_x(4));
         ch3_pkt_size_sel         <= ch3a_pkt_size;    
         ch3_pkt_size_en_sel      <= ch3a_pkt_size_en; 
      else
         ch3_override_pkt_size    <= ctlb3_x(16 downto 0);
         ch3_override_pkt_size_en <= ctlb3_x(17);
         ch3_fifo_aresetn         <= ctlb3_x(18) and (not cntl_reg_x(4));    
         ch3_pkt_size_sel         <= ctlb3_x(16 downto 0);   
         ch3_pkt_size_en_sel      <= ctlb3_x(17);                     
      end if;
   end if;
end process; 


end Behavioral;
