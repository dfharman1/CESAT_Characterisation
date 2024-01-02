----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/02/2018 09:05:09 AM
-- Design Name: 
-- Module Name: eth_100ge_ctl_stat - Behavioral
----------------------------------------------------------------------------------
-- Company: Pentek, Inc.
-- Engineer: 
-- 
-- Create Date: 08/19/2018 07:28:49 AM
-- Design Name: 
-- Module Name: eth_100ge_ctl_stat - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 100Ge Core Reset Control and Status Registers
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
-- Register Map
-- 0x00 - Reset Control Register
--   [0] -  100ge sys_reset  
--   [1] -  RX Reset
--   [2] -  TX Reset
-- 0x04 - Loopback Control Register
--   [11:0] - loopback control
-- 0x08 - Differential Control Register
--   [4:0] - lane 0 differential control
--   [9:5] - lane 1 differential control
--   [14:10] - lane 2 differential control
--   [19:15] - lane 3 differential control
-- 0x0c - Pre-Cursor Control Register
--   [4:0] - lane 0 Pre-Cursor control
--   [9:5] - lane 1 Pre-Cursor control
--   [14:10] - lane 2 Pre-Cursor control
--   [19:15] - lane 3 Pre-Cursor control
-- 0x10 - Post-Cursor Control Register
--   [4:0] - lane 0 Post-Cursor control
--   [9:5] - lane 1 Post-Cursor control
--   [14:10] - lane 2 Post-Cursor control
--   [19:15] - lane 3 Post-Cursor control
-- 0x14 - Polarity Control Register
--   [3:0] - RX Polarity control
--   [7:4] - TX Polarity control
--   [8]   -- RX LPM Enable
-- 0x18 - Status Register
--   [3:0] -  100ge core power good
--   [4]   -  100ge core gt_reset_tx_done_out
--   [5]   -  100ge core gt_reset_rx_done_out
--   [6]   - QPLL Lock
--   [7]   - rx aligned
    
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

entity eth_100ge_ctl_stat is
generic(
   default_lane0_diffctrl: integer range 0 to 31 := 0;
   default_lane1_diffctrl: integer range 0 to 31 := 0;
   default_lane2_diffctrl: integer range 0 to 31 := 0;
   default_lane3_diffctrl: integer range 0 to 31 := 0;
   default_lane0_precursor: integer range 0 to 20 := 0;
   default_lane1_precursor: integer range 0 to 20 := 0;
   default_lane2_precursor: integer range 0 to 20 := 0;
   default_lane3_precursor: integer range 0 to 20 := 0;
   default_lane0_postcursor: integer range 0 to 31 := 0;
   default_lane1_postcursor: integer range 0 to 31 := 0;
   default_lane2_postcursor: integer range 0 to 31 := 0;
   default_lane3_postcursor: integer range 0 to 31 := 0;
   rx_lpm_enable           : boolean := true
);
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
-- Control Signals
---------------------------------------------------------------------------- 
   axi_csr_areset           : out std_logic;  
   sys_reset                : out std_logic;
   loopback                 : out std_logic_vector(11 downto 0);
   diffctrl                 : out std_logic_vector(19 downto 0);
   precursor                : out std_logic_vector(19 downto 0);
   postcursor               : out std_logic_vector(19 downto 0);
   rx_polarity              : out std_logic_vector(3 downto 0);
   tx_polarity              : out std_logic_vector(3 downto 0);
   rxlpmen                  : out std_logic_vector(3 downto 0);
   gt_powergood             : out std_logic;
   link_led_n               : out std_logic;
   core_rx_reset            : out std_logic;
   core_tx_reset            : out std_logic;
----------------------------------------------------------------------------
-- Status Signals
----------------------------------------------------------------------------
   gt_powergoodout          : in  std_logic_vector(3 downto 0);
   gt_reset_tx_done_out     : in  std_logic;
   gt_reset_rx_done_out     : in  std_logic;
   qpll_lock                : in  std_logic_vector(0 downto 0);
   stat_rx_aligned          : in  std_logic;
   linkup_irq               : out std_logic; -- edge
   linkdn_irq               : out std_logic -- edge
);
end eth_100ge_ctl_stat;

architecture Behavioral of eth_100ge_ctl_stat is

ATTRIBUTE X_INTERFACE_INFO : STRING;
ATTRIBUTE X_INTERFACE_PARAMETER : STRING;

ATTRIBUTE X_INTERFACE_INFO of sys_reset: SIGNAL is "xilinx.com:signal:reset:1.0 sys_reset RST";
ATTRIBUTE X_INTERFACE_PARAMETER of sys_reset: SIGNAL is "POLARITY ACTIVE_HIGH";

ATTRIBUTE X_INTERFACE_INFO of core_rx_reset: SIGNAL is "xilinx.com:signal:reset:1.0 core_rx_reset RST";
ATTRIBUTE X_INTERFACE_PARAMETER of core_rx_reset: SIGNAL is "POLARITY ACTIVE_HIGH";

ATTRIBUTE X_INTERFACE_INFO of core_tx_reset: SIGNAL is "xilinx.com:signal:reset:1.0 core_tx_reset RST";
ATTRIBUTE X_INTERFACE_PARAMETER of core_tx_reset: SIGNAL is "POLARITY ACTIVE_HIGH";

ATTRIBUTE X_INTERFACE_INFO of axi_csr_areset: SIGNAL is "xilinx.com:signal:reset:1.0 axi_csr_areset RST";
ATTRIBUTE X_INTERFACE_PARAMETER of axi_csr_areset: SIGNAL is "POLARITY ACTIVE_HIGH";

ATTRIBUTE X_INTERFACE_INFO of gt_reset_tx_done_out: SIGNAL is "xilinx.com:signal:reset:1.0 gt_reset_tx_done_out RST";
ATTRIBUTE X_INTERFACE_PARAMETER of gt_reset_tx_done_out: SIGNAL is "POLARITY ACTIVE_HIGH";

ATTRIBUTE X_INTERFACE_INFO of gt_reset_rx_done_out: SIGNAL is "xilinx.com:signal:reset:1.0 gt_reset_rx_done_out RST";
ATTRIBUTE X_INTERFACE_PARAMETER of gt_reset_rx_done_out: SIGNAL is "POLARITY ACTIVE_HIGH";

ATTRIBUTE X_INTERFACE_INFO of s_axi_csr_aresetn: SIGNAL is "xilinx.com:signal:reset:1.0 s_axi_csr_aresetn RST";
ATTRIBUTE X_INTERFACE_PARAMETER of s_axi_csr_aresetn: SIGNAL is "POLARITY ACTIVE_LOW";

ATTRIBUTE X_INTERFACE_INFO of s_axi_csr_aclk: SIGNAL is "xilinx.com:signal:clock:1.0 s_axi_csr_aclk CLK";
ATTRIBUTE X_INTERFACE_PARAMETER of s_axi_csr_aclk: SIGNAL is "ASSOCIATED_BUSIF s_axi_csr, ASSOCIATED_RESET s_axi_csr_aresetn:axi_csr_areset:sys_reset:core_tx_reset:core_rx_reset";

ATTRIBUTE X_INTERFACE_INFO of linkup_irq: SIGNAL is "xilinx.com:signal:interrupt:1.0 linkup_irq INTERRUPT";
ATTRIBUTE X_INTERFACE_PARAMETER of linkup_irq: SIGNAL is "SENSITIVITY EDGE_RISING";

ATTRIBUTE X_INTERFACE_INFO of linkdn_irq: SIGNAL is "xilinx.com:signal:interrupt:1.0 linkdn_irq INTERRUPT";
ATTRIBUTE X_INTERFACE_PARAMETER of linkdn_irq: SIGNAL is "SENSITIVITY EDGE_RISING";
	
-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------

constant init_lane0_diffctrl   : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane0_diffctrl, 5); 
constant init_lane1_diffctrl   : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane1_diffctrl, 5);
constant init_lane2_diffctrl   : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane2_diffctrl, 5); 
constant init_lane3_diffctrl   : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane3_diffctrl, 5);
constant init_lane0_precursor  : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane0_precursor, 5);
constant init_lane1_precursor  : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane1_precursor, 5);
constant init_lane2_precursor  : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane2_precursor, 5);
constant init_lane3_precursor  : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane3_precursor, 5);
constant init_lane0_postcursor : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane0_postcursor, 5);
constant init_lane1_postcursor : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane1_postcursor, 5);
constant init_lane2_postcursor : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane2_postcursor, 5);
constant init_lane3_postcursor : std_logic_vector(4 downto 0) := conv_std_logic_vector(default_lane3_postcursor, 5);
constant init_diffctrl   : std_logic_vector(31 downto 0) := "000000000000" & init_lane3_diffctrl & init_lane2_diffctrl & init_lane1_diffctrl & init_lane0_diffctrl;
constant init_precursor  : std_logic_vector(31 downto 0) := "000000000000" & init_lane3_precursor & init_lane2_precursor & init_lane1_precursor & init_lane0_precursor;
constant init_postcursor : std_logic_vector(31 downto 0) := "000000000000" & init_lane3_postcursor & init_lane2_postcursor & init_lane1_postcursor & init_lane0_postcursor;

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

type to_state_type is 
(
RESET_STATE,
WAIT_RX_ALIGN_STATE,
ALIGNED_STATE,
TIMEOUT_STATE1,
TIMEOUT_STATE2,
TIMEOUT_STATE3,
TIMEOUT_STATE4,
TIMEOUT_STATE5
);

type reg_array is array (0 to 5) of std_logic_vector(31 downto 0);

constant num_ctl_regs      : integer := 6;

-------------------------------------------------------------------------------
-- Signals
-------------------------------------------------------------------------------
signal to_state         : to_state_type := RESET_STATE;
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
signal cntl_reg         : reg_array;
signal stat_reg         : reg_array;
signal rst1             : std_logic := '0'; 
signal rst2             : std_logic := '0'; 
signal rst3             : std_logic := '0'; 
signal rst4             : std_logic := '0'; 
signal rst5             : std_logic := '0'; 
signal p_sys_reset                : std_logic:= '0';
signal p_core_rx_reset  : std_logic:= '0';
signal p_core_tx_reset  : std_logic:= '0';
signal ctl1_out         : std_logic_vector(11 downto 0) := x"000";
signal stat_vctr        : std_logic_vector(6 downto 0) := "0000000";
signal stat0_in         : std_logic_vector(31 downto 0) := x"00000000";
signal rx_timeout_cntr  : std_logic_vector(27 downto 0) := x"0000000";
signal t1_stat_rx_aligned : std_logic:= '0'; 
signal t2_stat_rx_aligned : std_logic:= '0'; 

-------------------------------------------------------------------------------


begin

gt_powergood <= gt_powergoodout(3) and gt_powergoodout(2) and gt_powergoodout(1) and gt_powergoodout(0);

-------------------------------------------------------------------------------
-- AXI4-Lite Interface State Machine
-------------------------------------------------------------------------------

process(s_axi_csr_aclk)
begin
    if rising_edge(s_axi_csr_aclk) then
        t1_s_axi_csr_aresetn <= s_axi_csr_aresetn;
        axi_csr_areset       <= not t1_s_axi_csr_aresetn;
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

gen_ctl_regs: for i in 0 to 5 generate

process(s_axi_csr_aclk)
begin
    if rising_edge(s_axi_csr_aclk) then
      if  t1_s_axi_csr_aresetn = '0' then
         -- Initialize when reset
         case i is
            when 0 => -- Reset Register
               cntl_reg(i)(31 downto 0) <= x"00000000";
            when 1 => -- Loopback Register
               cntl_reg(i)(31 downto 0) <= x"00000000"; 
            when 2 => -- Differential Control Register
               cntl_reg(i)(31 downto 0) <= init_diffctrl;
            when 3 => -- Pre-Cursor Register
               cntl_reg(i)(31 downto 0) <= init_precursor;
            when 4 => -- Post Cursor Register
               cntl_reg(i)(31 downto 0) <= init_postcursor;
            when 5 => -- Polarity and LPM Register
               if rx_lpm_enable = true then
                  cntl_reg(i)(31 downto 0) <= x"00000100";
               else
                  cntl_reg(i)(31 downto 0) <= x"00000000";
               end if;         
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


gen_stat_regs: for i in 0 to 1 generate

process(s_axi_csr_aclk)
begin
   if rising_edge(s_axi_csr_aclk) then
      case i is
         when 0 =>
            stat_reg(i)(31 downto 0) <= stat0_in;
         when 1 =>
            stat_reg(i)(31 downto 0) <= x"00000000"; 
         when others =>
            stat_reg(i)(31 downto 0) <= x"00000000"; 
       end case;    
       stat0_in(7 downto 0) <= stat_rx_aligned & qpll_lock & gt_reset_rx_done_out & gt_reset_tx_done_out & gt_powergoodout;    
       link_led_n <= not (stat_rx_aligned and gt_reset_rx_done_out and  gt_reset_tx_done_out);
       t1_stat_rx_aligned <= stat_rx_aligned;
       t2_stat_rx_aligned <= t1_stat_rx_aligned;  
       linkup_irq <= t1_stat_rx_aligned and not t2_stat_rx_aligned;
       linkdn_irq <= t2_stat_rx_aligned and not t1_stat_rx_aligned;        
   end if;
end process;

end generate;

stat0_in(31 downto 8) <= (others => '0');

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
-- Control Register Ouputs
--------------------------------------------------------------------------------
process(s_axi_csr_aclk)
begin
   if rising_edge(s_axi_csr_aclk) then
      ctl1_out    <= cntl_reg(1)(11 downto 0);
      loopback    <= ctl1_out;
      diffctrl    <= cntl_reg(2)(19 downto 0);      
      precursor   <= cntl_reg(3)(19 downto 0);         
      postcursor  <= cntl_reg(4)(19 downto 0);          
      rx_polarity <= cntl_reg(5)(3 downto 0);         
      tx_polarity <= cntl_reg(5)(7 downto 4);
      rxlpmen     <= cntl_reg(5)(8) & cntl_reg(5)(8) & cntl_reg(5)(8) & cntl_reg(5)(8);                 
   end if;
end process; 

--------------------------------------------------------------------------------
-- Reset Control
--------------------------------------------------------------------------------

process(s_axi_csr_aclk)
begin
   if rising_edge(s_axi_csr_aclk) then
      sys_reset     <= (not t1_s_axi_csr_aresetn) or cntl_reg(0)(0);
      core_tx_reset <= (not t1_s_axi_csr_aresetn) or cntl_reg(0)(2);
   end if;
end process; 

--------------------------------------------------------------------------------
-- RX Alignment Timeout
--------------------------------------------------------------------------------

process(s_axi_csr_aclk)
begin
   if rising_edge(s_axi_csr_aclk) then
      if  (t1_s_axi_csr_aresetn = '0') or (cntl_reg(0)(1) = '1') then
         rx_timeout_cntr <= x"0000000";
         to_state <= RESET_STATE;
         core_rx_reset <= '1';
      else
         case to_state is
            when RESET_STATE =>
               to_state <= WAIT_RX_ALIGN_STATE;
            when WAIT_RX_ALIGN_STATE =>
               rx_timeout_cntr <= rx_timeout_cntr + 1;
               core_rx_reset <= '0';
               if stat_rx_aligned = '1' then
                  to_state <=  ALIGNED_STATE;
               elsif rx_timeout_cntr = x"FFFFFFF" then
                  to_state <=  TIMEOUT_STATE1;
               end if;
            when TIMEOUT_STATE1 =>  
               core_rx_reset <= '1';
               to_state <=  TIMEOUT_STATE2;
            when TIMEOUT_STATE2 => 
               to_state <=  TIMEOUT_STATE3;
            when TIMEOUT_STATE3 => 
               to_state <=  TIMEOUT_STATE4; 
            when TIMEOUT_STATE4 =>
               to_state <=  TIMEOUT_STATE5;
            when TIMEOUT_STATE5 =>
               core_rx_reset <= '0';
               rx_timeout_cntr <= x"0000000";
               to_state <= RESET_STATE;
            when ALIGNED_STATE =>
               if stat_rx_aligned = '0' then
                  to_state <=  TIMEOUT_STATE1;
               end if;
            when others => 
               to_state <= RESET_STATE;
         end case;
     end if;
  end if;
end process;
              
end Behavioral;