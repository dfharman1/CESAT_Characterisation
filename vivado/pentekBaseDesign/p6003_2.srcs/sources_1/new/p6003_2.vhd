----------------------------------------------------------------------------------
-- Company: Pentek, Inc.
-- Engineer: 
-- 
-- Create Date: 09/21/2017 08:11:36 AM
-- Design Name: 
-- Module Name: p6003_2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 8GB DDR4 Variant - 8GB Single die DDR4 support
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0 - Created from 6001_2 project. Updated to 2020.2  
-- Revision 1 - 8/23/22 Fixed channel synchronization issues when in DDC mode. Updated rf_adc_fmtr and dec16fir_8.    
-- Additional Comments:

----------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- (c) Copyright 2021 Pentek, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Pentek, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Pentek, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND PENTEK HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Pentek shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Pentek had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Pentek products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Pentek products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity p6003_2 is
generic (
   rev      : integer                        := 1;  -- Revision 0 to 255
   rev_date : std_logic_vector(23 downto 0)  := x"082522"; -- Revision Date MM/DD/YY 5/29/18 = x"052918" 
   fpga_size: std_logic_vector(11 downto 0)  := x"047"; -- FPGA Size  - x"025", x"027", x"028"
   fpgacodetype: std_logic_vector(31 downto 0) :=  x"00060032";
   swver : in STD_LOGIC_VECTOR ( 31 downto 0 ):=  x"00020202" -- Vivado Software Version
);
port (
--------------------------------------------------------------------------------
-- ADC Input Signals
--------------------------------------------------------------------------------
    ADC_224_01_V_N          : in STD_LOGIC;
    ADC_224_01_V_P          : in STD_LOGIC;
    ADC_224_23_V_N          : in STD_LOGIC;
    ADC_224_23_V_P          : in STD_LOGIC;
    ADC_224_CLK_CLK_N       : in STD_LOGIC;
    ADC_224_CLK_CLK_P       : in STD_LOGIC;
    ADC_225_01_V_N          : in STD_LOGIC;
    ADC_225_01_V_P          : in STD_LOGIC;
    ADC_225_23_V_N          : in STD_LOGIC;
    ADC_225_23_V_P          : in STD_LOGIC;
    ADC_225_CLK_CLK_N       : in STD_LOGIC;
    ADC_225_CLK_CLK_P       : in STD_LOGIC;
    ADC_226_01_V_N          : in STD_LOGIC;
    ADC_226_01_V_P          : in STD_LOGIC;
    ADC_226_23_V_N          : in STD_LOGIC;
    ADC_226_23_V_P          : in STD_LOGIC;
    ADC_226_CLK_CLK_N       : in STD_LOGIC;
    ADC_226_CLK_CLK_P       : in STD_LOGIC;
    ADC_227_01_V_N          : in STD_LOGIC;
    ADC_227_01_V_P          : in STD_LOGIC;
    ADC_227_23_V_N          : in STD_LOGIC;
    ADC_227_23_V_P          : in STD_LOGIC;
    ADC_227_CLK_CLK_N       : in STD_LOGIC;
    ADC_227_CLK_CLK_P       : in STD_LOGIC;
----------------------------------------------------------------------------------
---- DAC Output Signals
---------------------------------------------------------------------------------- 
    SYSREF_228_IN_DIFF_N    : in STD_LOGIC;
    SYSREF_228_IN_DIFF_P    : in STD_LOGIC;
    SYSREF_P                : in STD_LOGIC;
    SYSREF_N                : in STD_LOGIC;
    DAC_228_CLK_CLK_N       : in STD_LOGIC;
    DAC_228_CLK_CLK_P       : in STD_LOGIC;
    DAC_228_VOUT0_V_N       : out STD_LOGIC;
    DAC_228_VOUT0_V_P       : out STD_LOGIC;
    DAC_228_VOUT1_V_N       : out STD_LOGIC;
    DAC_228_VOUT1_V_P       : out STD_LOGIC;
    DAC_228_VOUT2_V_N       : out STD_LOGIC;
    DAC_228_VOUT2_V_P       : out STD_LOGIC;
    DAC_228_VOUT3_V_N       : out STD_LOGIC;
    DAC_228_VOUT3_V_P       : out STD_LOGIC;
    DAC_229_CLK_CLK_N       : in STD_LOGIC;
    DAC_229_CLK_CLK_P       : in STD_LOGIC;
    DAC_229_VOUT0_V_N       : out STD_LOGIC;
    DAC_229_VOUT0_V_P       : out STD_LOGIC;
    DAC_229_VOUT1_V_N       : out STD_LOGIC;
    DAC_229_VOUT1_V_P       : out STD_LOGIC;
    DAC_229_VOUT2_V_N       : out STD_LOGIC;
    DAC_229_VOUT2_V_P       : out STD_LOGIC;
    DAC_229_VOUT3_V_N       : out STD_LOGIC;
    DAC_229_VOUT3_V_P       : out STD_LOGIC;
    
    RF_AXIS_ACLK_P          : in STD_LOGIC; -- LVDS (requires internal 100Ohm termination)
    RF_AXIS_ACLK_N          : in STD_LOGIC; -- LVDS
--------------------------------------------------------------------------------
-- SYNC BUS Signals
--------------------------------------------------------------------------------    
    GATE_P                  : in STD_LOGIC; -- LVDS
    GATE_N                  : in STD_LOGIC; -- LVDS
    SYNC_P                  : in STD_LOGIC; -- LVDS
    SYNC_N                  : in STD_LOGIC; -- LVDS  
    TRIG                    : in STD_LOGIC; -- TTL Trigger  (PL_GPIO0)
--    DAC_GATE_P              : in STD_LOGIC; -- LVDS
--    DAC_GATE_N              : in STD_LOGIC; -- LVDS
--    DAC_SYNC_P              : in STD_LOGIC; -- LVDS
--    DAC_SYNC_N              : in STD_LOGIC; -- LVDS  
----------------------------------------------------------------------------------        
---- DDR4 PL Interface
----------------------------------------------------------------------------------         
    C0_SYS_CLK_P            : IN STD_LOGIC; -- SSTL  (Externally terminated)
    C0_SYS_CLK_N            : IN STD_LOGIC; -- SSTL
    C0_DDR4_ADR             : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
    C0_DDR4_BA              : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    C0_DDR4_CKE             : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    C0_DDR4_CS_N            : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    C0_DDR4_DM_DBI_N        : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    C0_DDR4_DQ              : INOUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    C0_DDR4_DQS_C           : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    C0_DDR4_DQS_T           : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    C0_DDR4_ODT             : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    C0_DDR4_BG              : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    C0_DDR4_RESET_N         : OUT STD_LOGIC;
    C0_DDR4_ACT_N           : OUT STD_LOGIC;
    C0_DDR4_CK_C            : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    C0_DDR4_CK_T            : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
----------------------------------------------------------------------------------
---- 200MHz Reference Clock
----------------------------------------------------------------------------------
    Z_REFCLK_P              : in STD_LOGIC; -- LVDS
    Z_REFCLK_N              : in STD_LOGIC; -- LVDS    
----------------------------------------------------------------------------------
---- PCI Express Interface
----------------------------------------------------------------------------------
    MGTREFCLK131_P        : in STD_LOGIC;  -- PCIe REF Clk 100MHz
    MGTREFCLK131_N        : in STD_LOGIC;
    -- PCIe Interface
    PERST0_N          : in  std_logic;  -- PCIe Reset in
    PER0P0            : in  std_logic;  -- Lane 0 Rx
    PER0N0            : in  std_logic;  -- Lane 0 Rx
    PER0P1            : in  std_logic;  -- Lane 1 Rx
    PER0N1            : in  std_logic;  -- Lane 1 Rx
    PER0P2            : in  std_logic;  -- Lane 2 Rx
    PER0N2            : in  std_logic;  -- Lane 2 Rx
    PER0P3            : in  std_logic;  -- Lane 3 Rx
    PER0N3            : in  std_logic;  -- Lane 3 Rx
    PER0P4            : in  std_logic;  -- Lane 4 Rx
    PER0N4            : in  std_logic;  -- Lane 4 Rx
    PER0P5            : in  std_logic;  -- Lane 5 Rx
    PER0N5            : in  std_logic;  -- Lane 5 Rx
    PER0P6            : in  std_logic;  -- Lane 6 Rx
    PER0N6            : in  std_logic;  -- Lane 6 Rx
    PER0P7            : in  std_logic;  -- Lane 7 Rx
    PER0N7            : in  std_logic;  -- Lane 7 Rx
    PET0P0            : out std_logic;  -- Lane 0 Tx
    PET0N0            : out std_logic;  -- Lane 0 Tx
    PET0P1            : out std_logic;  -- Lane 1 Tx
    PET0N1            : out std_logic;  -- Lane 1 Tx
    PET0P2            : out std_logic;  -- Lane 2 Tx
    PET0N2            : out std_logic;  -- Lane 2 Tx
    PET0P3            : out std_logic;  -- Lane 3 Tx
    PET0N3            : out std_logic;  -- Lane 3 Tx
    PET0P4            : out std_logic;  -- Lane 4 Tx
    PET0N4            : out std_logic;  -- Lane 4 Tx
    PET0P5            : out std_logic;  -- Lane 5 Tx
    PET0N5            : out std_logic;  -- Lane 5 Tx
    PET0P6            : out std_logic;  -- Lane 6 Tx
    PET0N6            : out std_logic;  -- Lane 6 Tx
    PET0P7            : out std_logic;  -- Lane 7 Tx
    PET0N7            : out std_logic;  -- Lane 7 Tx
----------------------------------------------------------------------------------  
---- 100Ge Ports
    MGTREFCLK129_P        : in std_logic;  -- 100Ge REF Clk 156.25
    MGTREFCLK129_N        : in std_logic;   
    
    GTY_0_100GE_RX_0_N   : in  std_logic;     
    GTY_0_100GE_RX_0_P   : in  std_logic;     
    GTY_0_100GE_RX_1_N   : in  std_logic;     
    GTY_0_100GE_RX_1_P   : in  std_logic;     
    GTY_0_100GE_RX_2_N   : in  std_logic;     
    GTY_0_100GE_RX_2_P   : in  std_logic;     
    GTY_0_100GE_RX_3_N   : in  std_logic;     
    GTY_0_100GE_RX_3_P   : in  std_logic;     
    GTY_1_100GE_RX_0_N   : in  std_logic;     
    GTY_1_100GE_RX_0_P   : in  std_logic;     
    GTY_1_100GE_RX_1_N   : in  std_logic;     
    GTY_1_100GE_RX_1_P   : in  std_logic;     
    GTY_1_100GE_RX_2_N   : in  std_logic;     
    GTY_1_100GE_RX_2_P   : in  std_logic;     
    GTY_1_100GE_RX_3_N   : in  std_logic;     
    GTY_1_100GE_RX_3_P   : in  std_logic;     
    GTY_0_100GE_TX_0_N   : out std_logic;     
    GTY_0_100GE_TX_0_P   : out std_logic;     
    GTY_0_100GE_TX_1_N   : out std_logic;     
    GTY_0_100GE_TX_1_P   : out std_logic;     
    GTY_0_100GE_TX_2_N   : out std_logic;     
    GTY_0_100GE_TX_2_P   : out std_logic;     
    GTY_0_100GE_TX_3_N   : out std_logic;     
    GTY_0_100GE_TX_3_P   : out std_logic;     
    GTY_1_100GE_TX_0_N   : out std_logic;     
    GTY_1_100GE_TX_0_P   : out std_logic;     
    GTY_1_100GE_TX_1_N   : out std_logic;     
    GTY_1_100GE_TX_1_P   : out std_logic;     
    GTY_1_100GE_TX_2_N   : out std_logic;     
    GTY_1_100GE_TX_2_P   : out std_logic;     
    GTY_1_100GE_TX_3_N   : out std_logic;     
    GTY_1_100GE_TX_3_P   : out std_logic;     

--------------------------------------------------------------------------------    
      --
    PL_GPIO           : out STD_LOGIC_VECTOR(7 DOWNTO 1); -- 3.3V LVCMOS

    OVR_TMP_N         : in STD_LOGIC; -- 3.3V LVCMOS
      
--    LVDS_P            : in STD_LOGIC_VECTOR(15 DOWNTO 0); -- LVDS
--    LVDS_N            : in STD_LOGIC_VECTOR(15 DOWNTO 0); -- LVDS

    PPS18             : in STD_LOGIC;  -- 1.8V LVCMOS   
--------------------------------------------------------------------------------  
    -- System Management inputs 
--------------------------------------------------------------------------------  
    V3P3V_MON_P       : in STD_LOGIC; -- Analog
    V3P3V_MON_N       : in STD_LOGIC; -- Analog
    V0P85VMGT_MON_P: in STD_LOGIC; -- Analog
    V0P85VMGT_MON_N: in STD_LOGIC; -- Analog
    V2P5V_MON_P: in STD_LOGIC; -- Analog
    V2P5V_MON_N: in STD_LOGIC; -- Analog
    ADC_AVCC_MON_P: in STD_LOGIC; -- Analog
    ADC_AVCC_MON_N: in STD_LOGIC; -- Analog
    V1P8V_MGT_MON_P: in STD_LOGIC; -- Analog
    V1P8V_MGT_MON_N: in STD_LOGIC; -- Analog
    DAC_AVCC_MON_P: in STD_LOGIC; -- Analog
    DAC_AVCC_MON_N: in STD_LOGIC; -- Analog
    V1P2V_MON_P: in STD_LOGIC; -- Analog
    V1P2V_MON_N: in STD_LOGIC; -- Analog                
    ADC_AVCCAUX_MON_P: in STD_LOGIC; -- Analog
    ADC_AVCCAUX_MON_N: in STD_LOGIC; -- Analog
    V1P2V_MGT_MON_P: in STD_LOGIC; -- Analog
    V1P2V_MGT_MON_N: in STD_LOGIC; -- Analog         
    DAC_AVCCAUX_MON_P: in STD_LOGIC; -- Analog
    DAC_AVCCAUX_MON_N: in STD_LOGIC; -- Analog
    V0P9V_MGT_MON_P: in STD_LOGIC; -- Analog
    V0P9V_MGT_MON_N: in STD_LOGIC; -- Analog   
    DAC_AVTT_MON_P: in STD_LOGIC; -- Analog
    DAC_AVTT_MON_N: in STD_LOGIC -- Analog           
    );
end p6003_2;

architecture Behavioral of p6003_2 is

--------------------------------------------------------------------------------
-- Component
--------------------------------------------------------------------------------

component p6003_wrapper
port (
  C0_DDR4_act_n : out STD_LOGIC;
  C0_DDR4_adr : out STD_LOGIC_VECTOR ( 16 downto 0 );
  C0_DDR4_ba : out STD_LOGIC_VECTOR ( 1 downto 0 );
  C0_DDR4_bg : out STD_LOGIC_VECTOR ( 0 to 0 );
  C0_DDR4_ck_c : out STD_LOGIC_VECTOR ( 0 to 0 );
  C0_DDR4_ck_t : out STD_LOGIC_VECTOR ( 0 to 0 );
  C0_DDR4_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
  C0_DDR4_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
  C0_DDR4_dm_n : inout STD_LOGIC_VECTOR ( 7 downto 0 );
  C0_DDR4_dq : inout STD_LOGIC_VECTOR ( 63 downto 0 );
  C0_DDR4_dqs_c : inout STD_LOGIC_VECTOR ( 7 downto 0 );
  C0_DDR4_dqs_t : inout STD_LOGIC_VECTOR ( 7 downto 0 );
  C0_DDR4_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
  C0_DDR4_reset_n : out STD_LOGIC;
  C0_SYS_CLK_clk_n : in STD_LOGIC;
  C0_SYS_CLK_clk_p : in STD_LOGIC;
  rf_axis_aclk : in STD_LOGIC;
  MGTREFCLK131_clk_n : in STD_LOGIC_VECTOR ( 0 to 0 );
  MGTREFCLK131_clk_p : in STD_LOGIC_VECTOR ( 0 to 0 );
  Vaux0_v_n : in STD_LOGIC;
  Vaux0_v_p : in STD_LOGIC;
  Vaux10_v_n : in STD_LOGIC;
  Vaux10_v_p : in STD_LOGIC;
  Vaux11_v_n : in STD_LOGIC;
  Vaux11_v_p : in STD_LOGIC;
  Vaux12_v_n : in STD_LOGIC;
  Vaux12_v_p : in STD_LOGIC;
  Vaux13_v_n : in STD_LOGIC;
  Vaux13_v_p : in STD_LOGIC;
  Vaux1_v_n : in STD_LOGIC;
  Vaux1_v_p : in STD_LOGIC;
  Vaux2_v_n : in STD_LOGIC;
  Vaux2_v_p : in STD_LOGIC;
  Vaux3_v_n : in STD_LOGIC;
  Vaux3_v_p : in STD_LOGIC;
  Vaux4_v_n : in STD_LOGIC;
  Vaux4_v_p : in STD_LOGIC;
  Vaux5_v_n : in STD_LOGIC;
  Vaux5_v_p : in STD_LOGIC;
  Vaux8_v_n : in STD_LOGIC;
  Vaux8_v_p : in STD_LOGIC;
  Vaux9_v_n : in STD_LOGIC;
  Vaux9_v_p : in STD_LOGIC;
  adc0_clk_clk_n : in STD_LOGIC;
  adc0_clk_clk_p : in STD_LOGIC;
  adc1_clk_clk_n : in STD_LOGIC;
  adc1_clk_clk_p : in STD_LOGIC;
  adc2_clk_clk_n : in STD_LOGIC;
  adc2_clk_clk_p : in STD_LOGIC;
  adc3_clk_clk_n : in STD_LOGIC;
  adc3_clk_clk_p : in STD_LOGIC;
  adc_224_01_v_n : in STD_LOGIC;
  adc_224_01_v_p : in STD_LOGIC;
  adc_224_23_v_n : in STD_LOGIC;
  adc_224_23_v_p : in STD_LOGIC;
  adc_225_01_v_n : in STD_LOGIC;
  adc_225_01_v_p : in STD_LOGIC;
  adc_225_23_v_n : in STD_LOGIC;
  adc_225_23_v_p : in STD_LOGIC;
  adc_226_01_v_n : in STD_LOGIC;
  adc_226_01_v_p : in STD_LOGIC;
  adc_226_23_v_n : in STD_LOGIC;
  adc_226_23_v_p : in STD_LOGIC;
  adc_227_01_v_n : in STD_LOGIC;
  adc_227_01_v_p : in STD_LOGIC;
  adc_227_23_v_n : in STD_LOGIC;
  adc_227_23_v_p : in STD_LOGIC;
  carrier_pps : in STD_LOGIC;
  --dac0_clk_clk_n : in STD_LOGIC;
  --dac0_clk_clk_p : in STD_LOGIC;
  dac1_clk_clk_n : in STD_LOGIC;
  dac1_clk_clk_p : in STD_LOGIC;
  dac_228_vout0_v_n : out STD_LOGIC;
  dac_228_vout0_v_p : out STD_LOGIC;
  dac_228_vout1_v_n : out STD_LOGIC;
  dac_228_vout1_v_p : out STD_LOGIC;
  dac_228_vout2_v_n : out STD_LOGIC;
  dac_228_vout2_v_p : out STD_LOGIC;
  dac_228_vout3_v_n : out STD_LOGIC;
  dac_228_vout3_v_p : out STD_LOGIC;
  dac_229_vout0_v_n : out STD_LOGIC;
  dac_229_vout0_v_p : out STD_LOGIC;
  dac_229_vout1_v_n : out STD_LOGIC;
  dac_229_vout1_v_p : out STD_LOGIC;
  dac_229_vout2_v_n : out STD_LOGIC;
  dac_229_vout2_v_p : out STD_LOGIC;
  dac_229_vout3_v_n : out STD_LOGIC;
  dac_229_vout3_v_p : out STD_LOGIC;
  eth0_link_led_n : out STD_LOGIC;
  eth100ge_ch0123_gt_grx_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
  eth100ge_ch0123_gt_grx_p : in STD_LOGIC_VECTOR ( 3 downto 0 );
  eth100ge_ch0123_gt_gtx_n : out STD_LOGIC_VECTOR ( 3 downto 0 );
  eth100ge_ch0123_gt_gtx_p : out STD_LOGIC_VECTOR ( 3 downto 0 );
  eth100ge_ch4567_gt_grx_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
  eth100ge_ch4567_gt_grx_p : in STD_LOGIC_VECTOR ( 3 downto 0 );
  eth100ge_ch4567_gt_gtx_n : out STD_LOGIC_VECTOR ( 3 downto 0 );
  eth100ge_ch4567_gt_gtx_p : out STD_LOGIC_VECTOR ( 3 downto 0 );
  eth1_link_led_n : out STD_LOGIC;
  ext_temp_irq_n : in STD_LOGIC;
  fpgacodetype : in STD_LOGIC_VECTOR ( 31 downto 0 );
  gate_in : in STD_LOGIC;
  gate_trig_ttl_in : in STD_LOGIC;
  gt_ref_clk : in STD_LOGIC;
  pcie_link_up_led_n : out STD_LOGIC;
  pcie_lane_led0_n : out STD_LOGIC;
  pcie_lane_led1_n : out STD_LOGIC;
  pcie_mgt_rxn : in STD_LOGIC_VECTOR ( 7 downto 0 );
  pcie_mgt_rxp : in STD_LOGIC_VECTOR ( 7 downto 0 );
  pcie_mgt_txn : out STD_LOGIC_VECTOR ( 7 downto 0 );
  pcie_mgt_txp : out STD_LOGIC_VECTOR ( 7 downto 0 );
  pcie_perstn_in : in STD_LOGIC;
  ref_clk : in STD_LOGIC;
  rev : in STD_LOGIC_VECTOR ( 7 downto 0 );
  rev_date : in STD_LOGIC_VECTOR ( 23 downto 0 );
  size : in STD_LOGIC_VECTOR ( 11 downto 0 );
  swver : in STD_LOGIC_VECTOR ( 31 downto 0 );
  sync_in : in STD_LOGIC;
  sysref : in STD_LOGIC;
  sysref_in_diff_n : in STD_LOGIC;
  sysref_in_diff_p : in STD_LOGIC
);
end component p6003_wrapper;

--------------------------------------------------------------------------------
-- Signals
--------------------------------------------------------------------------------

signal refclk_in: std_logic;
signal ref_clk: std_logic;
signal user_sysref                  : std_logic; 
signal ddr4_ui_clk                        : std_logic;
signal pcie_perstn_in                     : std_logic;
signal sys_clk                            : std_logic;   
signal sys_clk_gt                         : std_logic;
signal ddr4_sys_rst                       : std_logic;                      
signal ddr4_ui_app_addr                   : std_logic_vector ( 28 downto 0 );
signal ddr4_ui_app_cmd                    : std_logic_vector ( 2 downto 0 );
signal ddr4_ui_app_en                     : std_logic;                      
signal ddr4_ui_app_hi_pri                 : std_logic;                      
signal ddr4_ui_app_rd_data                : std_logic_vector ( 639 downto 0 );
signal ddr4_ui_app_rd_data_end            : std_logic;                      
signal ddr4_ui_app_rd_data_valid          : std_logic;                      
signal ddr4_ui_app_rdy                    : std_logic;                      
signal ddr4_ui_app_wdf_data               : std_logic_vector ( 639 downto 0 );
signal ddr4_ui_app_wdf_end                : std_logic;                      
signal ddr4_ui_app_wdf_mask               : std_logic_vector ( 79 downto 0 );
signal ddr4_ui_app_wdf_rdy                : std_logic;                      
signal ddr4_ui_app_wdf_wren               : std_logic;                      
signal init_calib_complete                : std_logic;
signal ddr4_ui_rstn                       : std_logic;
signal ddr4_ui_clk_sync_rst               : std_logic;
signal idelayctrl_rst                     : std_logic; 
signal idelayctrl_cntr                    : std_logic_vector(7 downto 0) := x"00";
signal pcie_link_up_led_n                 : std_logic;
signal pcie_lane_led0_n                   : std_logic;
signal pcie_lane_led1_n                   : std_logic;
signal gate_in                            : std_logic;
signal sync_in                            : std_logic;
signal dac_gate_in                        : std_logic;
signal dac_sync_in                        : std_logic;
signal gt_ref_clk_100ge                   : std_logic;
signal sysref                             : std_logic;
signal rf_axis_aclk                       : std_logic;
        
--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

constant rev_vctr : std_logic_vector(7 downto 0) := conv_std_logic_vector(rev, 8);

--------------------------------------------------------------------------------
-- Attributes
--------------------------------------------------------------------------------

--attribute IODELAY_GROUP: string;
--attribute IODELAY_GROUP of IDELAYCTRL_inst1: label is "IODELAY_GRP"; --"iodelay_grp1";

--------------------------------------------------------------------------------

begin

-- GPIO to 5950 Lattice

PL_GPIO(1) <= '0'; -- 
PL_GPIO(2) <= '0'; -- 
--PL_GPIO(3) <= '0'; -- use for LINK1 LED
--PL_GPIO(4) <= '0'; -- use for LINK2 LED
PL_GPIO(5) <= not pcie_link_up_led_n; 
PL_GPIO(6) <= not pcie_lane_led0_n; 
PL_GPIO(7) <= not pcie_lane_led1_n;


gate_IBUFDS_inst : IBUFDS
   generic map (
      DQS_BIAS => "FALSE"  -- (FALSE, TRUE)
   )
   port map (
      O  => gate_in,   -- 1-bit output: Buffer output
      I  => GATE_P,   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
      IB => GATE_N  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
   );

sync_IBUFDS_inst : IBUFDS
   generic map (
      DQS_BIAS => "FALSE"  -- (FALSE, TRUE)
   )
   port map (
      O  => sync_in,   -- 1-bit output: Buffer output
      I  => SYNC_P,   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
      IB => SYNC_N  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
   );
   
--dac_gate_IBUFDS_inst : IBUFDS
--   generic map (
--       DQS_BIAS => "FALSE"  -- (FALSE, TRUE)
--    )
--    port map (
--       O  => dac_gate_in,   -- 1-bit output: Buffer output
--       I  => DAC_GATE_P,   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
--       IB => DAC_GATE_N  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
--    );
 
--dac_sync_IBUFDS_inst : IBUFDS
--      generic map (
--         DQS_BIAS => "FALSE"  -- (FALSE, TRUE)
--      )
--      port map (
--         O  => dac_sync_in,   -- 1-bit output: Buffer output
--         I  => DAC_SYNC_P,   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
--         IB => DAC_SYNC_N  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
--      );
   
sysref_IBUFDS_inst : IBUFDS
  generic map (
     DQS_BIAS => "FALSE"  -- (FALSE, TRUE)
  )
  port map (
     O  => sysref,   -- 1-bit output: Buffer output
     I  => SYSREF_P,   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
     IB => SYSREF_N  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
  );

p6003_wrapper_inst: p6003_wrapper
  port map (
--------------------------------------------------------------------------------
-- Indentification Parameters
--------------------------------------------------------------------------------  
    rev                        => rev_vctr,
    rev_date                   => rev_date,
    size                       => fpga_size,
    fpgacodetype               => fpgacodetype,
    swver                      => swver,
    
    sysref                     => sysref,
--------------------------------------------------------------------------------
-- Indentification Parameters
--------------------------------------------------------------------------------  
    Vaux0_v_n                  => V3P3V_MON_N,            
    Vaux0_v_p                  => V3P3V_MON_P,            
    Vaux1_v_n                  => V2P5V_MON_N,            
    Vaux1_v_p                  => V2P5V_MON_P,            
    Vaux2_v_n                  => V1P8V_MGT_MON_N,        
    Vaux2_v_p                  => V1P8V_MGT_MON_P,        
    Vaux3_v_n                  => V1P2V_MON_N,            
    Vaux3_v_p                  => V1P2V_MON_P,            
    Vaux4_v_n                  => V1P2V_MGT_MON_N,        
    Vaux4_v_p                  => V1P2V_MGT_MON_P,        
    Vaux5_v_n                  => V0P9V_MGT_MON_N,        
    Vaux5_v_p                  => V0P9V_MGT_MON_P,        
    Vaux8_v_n                  => V0P85VMGT_MON_N,        
    Vaux8_v_p                  => V0P85VMGT_MON_P,        
    Vaux9_v_n                  => ADC_AVCC_MON_N,         
    Vaux9_v_p                  => ADC_AVCC_MON_P,         
    Vaux10_v_n                 => DAC_AVCC_MON_N,         
    Vaux10_v_p                 => DAC_AVCC_MON_P,         
    Vaux11_v_n                 => ADC_AVCCAUX_MON_N,      
    Vaux11_v_p                 => ADC_AVCCAUX_MON_P,      
    Vaux12_v_n                 => DAC_AVCCAUX_MON_N,      
    Vaux12_v_p                 => DAC_AVCCAUX_MON_P,      
    Vaux13_v_n                 => DAC_AVTT_MON_N,         
    Vaux13_v_p                 => DAC_AVTT_MON_P,      
    ext_temp_irq_n             => OVR_TMP_N, 
    --------------------------------------------------------------------------------
    -- ADC Tile 224
    --------------------------------------------------------------------------------
    adc_224_01_v_n             => ADC_224_01_V_N,          
    adc_224_01_v_p             => ADC_224_01_V_P,          
    adc_224_23_v_n             => ADC_224_23_V_N,          
    adc_224_23_v_p             => ADC_224_23_V_P,            
    adc0_clk_clk_n             => ADC_224_CLK_CLK_N,        
    adc0_clk_clk_p             => ADC_224_CLK_CLK_P,
    --------------------------------------------------------------------------------
    -- ADC Tile 225
    --------------------------------------------------------------------------------
    adc_225_01_v_n             => ADC_225_01_V_N,          
    adc_225_01_v_p             => ADC_225_01_V_P,          
    adc_225_23_v_n             => ADC_225_23_V_N,          
    adc_225_23_v_p             => ADC_225_23_V_P,          
    adc1_clk_clk_n             => ADC_225_CLK_CLK_N,        
    adc1_clk_clk_p             => ADC_225_CLK_CLK_P,
    --------------------------------------------------------------------------------
    -- ADC Tile 226
    --------------------------------------------------------------------------------           
    adc_226_01_v_n             => ADC_226_01_V_N,          
    adc_226_01_v_p             => ADC_226_01_V_P,          
    adc_226_23_v_n             => ADC_226_23_V_N,          
    adc_226_23_v_p             => ADC_226_23_V_P,            
    adc2_clk_clk_n             => ADC_226_CLK_CLK_N,        
    adc2_clk_clk_p             => ADC_226_CLK_CLK_P,  
    --------------------------------------------------------------------------------
    -- ADC Tile 227
    --------------------------------------------------------------------------------       
    adc_227_01_v_n             => ADC_227_01_V_N,          
    adc_227_01_v_p             => ADC_227_01_V_P,          
    adc_227_23_v_n             => ADC_227_23_V_N,          
    adc_227_23_v_p             => ADC_227_23_V_P,           
    adc3_clk_clk_n             => ADC_227_CLK_CLK_N,        
    adc3_clk_clk_p             => ADC_227_CLK_CLK_P,   
    --------------------------------------------------------------------------------
    -- DAC Tile 228
    --------------------------------------------------------------------------------             
    dac_228_vout0_v_n          => DAC_228_VOUT0_V_N,       
    dac_228_vout0_v_p          => DAC_228_VOUT0_V_P,       
    dac_228_vout1_v_n          => DAC_228_VOUT1_V_N,       
    dac_228_vout1_v_p          => DAC_228_VOUT1_V_P,       
    dac_228_vout2_v_n          => DAC_228_VOUT2_V_N,       
    dac_228_vout2_v_p          => DAC_228_VOUT2_V_P,       
    dac_228_vout3_v_n          => DAC_228_VOUT3_V_N,       
    dac_228_vout3_v_p          => DAC_228_VOUT3_V_P, 
    sysref_in_diff_n           => SYSREF_228_IN_DIFF_N,     
    sysref_in_diff_p           => SYSREF_228_IN_DIFF_P,     
    --dac0_clk_clk_n             => DAC_228_CLK_CLK_N,       
    --dac0_clk_clk_p             => DAC_228_CLK_CLK_P, 
    --------------------------------------------------------------------------------
    -- DAC Tile 229
    --------------------------------------------------------------------------------    
    dac1_clk_clk_n             => DAC_229_CLK_CLK_N,       
    dac1_clk_clk_p             => DAC_229_CLK_CLK_P,          
    dac_229_vout0_v_n          => DAC_229_VOUT0_V_N,       
    dac_229_vout0_v_p          => DAC_229_VOUT0_V_P,       
    dac_229_vout1_v_n          => DAC_229_VOUT1_V_N,       
    dac_229_vout1_v_p          => DAC_229_VOUT1_V_P,       
    dac_229_vout2_v_n          => DAC_229_VOUT2_V_N,       
    dac_229_vout2_v_p          => DAC_229_VOUT2_V_P,       
    dac_229_vout3_v_n          => DAC_229_VOUT3_V_N,       
    dac_229_vout3_v_p          => DAC_229_VOUT3_V_P, 
    --------------------------------------------------------------------------------
    -- Externally generated AXIS ACLK for ADC and DAC
    --------------------------------------------------------------------------------
    rf_axis_aclk               => rf_axis_aclk,
    --------------------------------------------------------------------------------
    -- DDR4
    --------------------------------------------------------------------------------     
    C0_DDR4_act_n              => C0_DDR4_ACT_N,
    C0_DDR4_adr                => C0_DDR4_ADR,
    C0_DDR4_ba                 => C0_DDR4_BA, 
    C0_DDR4_bg                 => C0_DDR4_BG(0 downto 0),
    C0_DDR4_ck_c               => C0_DDR4_CK_C,
    C0_DDR4_ck_t               => C0_DDR4_CK_T,
    C0_DDR4_cke                => C0_DDR4_CKE,
    C0_DDR4_cs_n               => C0_DDR4_CS_N,
    C0_DDR4_dm_n               => C0_DDR4_DM_DBI_N,
    C0_DDR4_dq                 => C0_DDR4_DQ,
    C0_DDR4_dqs_c              => C0_DDR4_DQS_C,
    C0_DDR4_dqs_t              => C0_DDR4_DQS_T,
    C0_DDR4_odt                => C0_DDR4_ODT,
    C0_DDR4_reset_n            => C0_DDR4_RESET_N,
    C0_SYS_CLK_clk_n           => C0_SYS_CLK_N,
    C0_SYS_CLK_clk_p           => C0_SYS_CLK_P,
    --------------------------------------------------------------------------------
    -- Gate/Trigger Interface
    --------------------------------------------------------------------------------  
    gate_in                    => gate_in,
    gate_trig_ttl_in           => TRIG,    
    sync_in                    => sync_in, 
    carrier_pps                => PPS18,
--    dac_gate_in                => dac_gate_in, 
--    dac_sync_in                => dac_sync_in,
    --------------------------------------------------------------------------------
    -- PCIe Interface
    --------------------------------------------------------------------------------      
    pcie_mgt_rxp(0)             => PER0P0,
    pcie_mgt_rxp(1)             => PER0P1,
    pcie_mgt_rxp(2)             => PER0P2,
    pcie_mgt_rxp(3)             => PER0P3,
    pcie_mgt_rxp(4)             => PER0P4,
    pcie_mgt_rxp(5)             => PER0P5,
    pcie_mgt_rxp(6)             => PER0P6,
    pcie_mgt_rxp(7)             => PER0P7,
       
    pcie_mgt_rxn(0)             => PER0N0,
    pcie_mgt_rxn(1)             => PER0N1,
    pcie_mgt_rxn(2)             => PER0N2,
    pcie_mgt_rxn(3)             => PER0N3,
    pcie_mgt_rxn(4)             => PER0N4,
    pcie_mgt_rxn(5)             => PER0N5,
    pcie_mgt_rxn(6)             => PER0N6,
    pcie_mgt_rxn(7)             => PER0N7,     
    
    pcie_mgt_txp(0)             => PET0P0,
    pcie_mgt_txp(1)             => PET0P1,
    pcie_mgt_txp(2)             => PET0P2,
    pcie_mgt_txp(3)             => PET0P3,
    pcie_mgt_txp(4)             => PET0P4,
    pcie_mgt_txp(5)             => PET0P5,
    pcie_mgt_txp(6)             => PET0P6,
    pcie_mgt_txp(7)             => PET0P7,
       
    pcie_mgt_txn(0)             => PET0N0,
    pcie_mgt_txn(1)             => PET0N1,
    pcie_mgt_txn(2)             => PET0N2,
    pcie_mgt_txn(3)             => PET0N3,
    pcie_mgt_txn(4)             => PET0N4,
    pcie_mgt_txn(5)             => PET0N5,
    pcie_mgt_txn(6)             => PET0N6,
    pcie_mgt_txn(7)             => PET0N7,                
    pcie_perstn_in              => pcie_perstn_in,  
    MGTREFCLK131_clk_p(0)       => MGTREFCLK131_P,
    MGTREFCLK131_clk_n(0)       => MGTREFCLK131_N,
    pcie_lane_led0_n            => pcie_lane_led0_n,           
    pcie_lane_led1_n            => pcie_lane_led1_n,                     
    pcie_link_up_led_n          => pcie_link_up_led_n,     
    --------------------------------------------------------------------------------
    -- 200MHz Reference Clock
    --------------------------------------------------------------------------------
    ref_clk                         => ref_clk,
    --------------------------------------------------------------------------------
    -- 100G Ethernet
    --------------------------------------------------------------------------------
    gt_ref_clk                   => gt_ref_clk_100ge,
    eth0_link_led_n              => PL_GPIO(3),  -- FP LINK 1  100G Ethernet Link LED
    eth1_link_led_n              => PL_GPIO(4),  -- FP LINK 2  100G Ethernet Link LED
    eth100ge_ch0123_gt_grx_p(0) => GTY_0_100GE_RX_0_P,
    eth100ge_ch0123_gt_grx_p(1) => GTY_0_100GE_RX_1_P,
    eth100ge_ch0123_gt_grx_p(2) => GTY_0_100GE_RX_2_P,
    eth100ge_ch0123_gt_grx_p(3) => GTY_0_100GE_RX_3_P,
        
    eth100ge_ch0123_gt_grx_n(0) => GTY_0_100GE_RX_0_N,
    eth100ge_ch0123_gt_grx_n(1) => GTY_0_100GE_RX_1_N,
    eth100ge_ch0123_gt_grx_n(2) => GTY_0_100GE_RX_2_N,
    eth100ge_ch0123_gt_grx_n(3) => GTY_0_100GE_RX_3_N,

    eth100ge_ch0123_gt_gtx_p(0) => GTY_0_100GE_TX_0_P,
    eth100ge_ch0123_gt_gtx_p(1) => GTY_0_100GE_TX_1_P,
    eth100ge_ch0123_gt_gtx_p(2) => GTY_0_100GE_TX_2_P,
    eth100ge_ch0123_gt_gtx_p(3) => GTY_0_100GE_TX_3_P,
        
    eth100ge_ch0123_gt_gtx_n(0) => GTY_0_100GE_TX_0_N,
    eth100ge_ch0123_gt_gtx_n(1) => GTY_0_100GE_TX_1_N,
    eth100ge_ch0123_gt_gtx_n(2) => GTY_0_100GE_TX_2_N,
    eth100ge_ch0123_gt_gtx_n(3) => GTY_0_100GE_TX_3_N,
    
    eth100ge_ch4567_gt_grx_p(0) => GTY_1_100GE_RX_0_P,
    eth100ge_ch4567_gt_grx_p(1) => GTY_1_100GE_RX_1_P,
    eth100ge_ch4567_gt_grx_p(2) => GTY_1_100GE_RX_2_P,
    eth100ge_ch4567_gt_grx_p(3) => GTY_1_100GE_RX_3_P,
    
    eth100ge_ch4567_gt_grx_n(0) => GTY_1_100GE_RX_0_N,
    eth100ge_ch4567_gt_grx_n(1) => GTY_1_100GE_RX_1_N,
    eth100ge_ch4567_gt_grx_n(2) => GTY_1_100GE_RX_2_N,
    eth100ge_ch4567_gt_grx_n(3) => GTY_1_100GE_RX_3_N,

    eth100ge_ch4567_gt_gtx_p(0) => GTY_1_100GE_TX_0_P,
    eth100ge_ch4567_gt_gtx_p(1) => GTY_1_100GE_TX_1_P,  
    eth100ge_ch4567_gt_gtx_p(2) => GTY_1_100GE_TX_2_P, 
    eth100ge_ch4567_gt_gtx_p(3) => GTY_1_100GE_TX_3_P,
      
    eth100ge_ch4567_gt_gtx_n(0) => GTY_1_100GE_TX_0_N,
    eth100ge_ch4567_gt_gtx_n(1) => GTY_1_100GE_TX_1_N,
    eth100ge_ch4567_gt_gtx_n(2) => GTY_1_100GE_TX_2_N,
    eth100ge_ch4567_gt_gtx_n(3) => GTY_1_100GE_TX_3_N
  );
  
c0_ddr4_bg(1) <= '0';

--------------------------------------------------------------------------------
-- PCIe System Reset
--------------------------------------------------------------------------------

PERST0_N_ibuf : IBUF
port map (
      O => pcie_perstn_in, -- 1-bit output: Buffer output
      I => PERST0_N   -- 1-bit input: Buffer input
   );

--------------------------------------------------------------------------------------------
-- Ref Clock Buffer -- 200MHz
--------------------------------------------------------------------------------------------

   IBUFDS_inst : IBUFDS
   generic map (
      DQS_BIAS => "FALSE"  -- (FALSE, TRUE)
   )
   port map (
      O  => refclk_in,   -- 1-bit output: Buffer output
      I  => Z_REFCLK_P,   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
      IB => Z_REFCLK_N  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
   );

   sysrefBUFG_inst : BUFG
   port map (
      O => ref_clk, -- 1-bit output: Clock output
      I => refclk_in  -- 1-bit input: Clock input
   );

   rfaxis_IBUFDS_inst : IBUFDS
   generic map (
      DQS_BIAS => "FALSE"  -- (FALSE, TRUE)
   )
   port map (
      O  => rf_axis_aclk,   -- 1-bit output: Buffer output
      I  => RF_AXIS_ACLK_P,   -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
      IB => RF_AXIS_ACLK_N  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
   );

--------------------------------------------------------------------------------------------
-- IDELAY CTRL
--------------------------------------------------------------------------------------------

---- Generate idelaycntrl reset
--process(ref_clk)
--begin 
--    if rising_edge(ref_clk) then
--        if idelayctrl_cntr /= x"FF" then
--           idelayctrl_cntr <= idelayctrl_cntr + 1;
--        end if;   
--        if idelayctrl_cntr(7) = '0' then  
--            idelayctrl_rst <= '1';
--        else
--            idelayctrl_rst <= '0';
--        end if;       
--    end if;
--end process;

--IDELAYCTRL_inst1 : IDELAYCTRL
--generic map (
--      SIM_DEVICE => "ULTRASCALE"  -- Set the device version (7SERIES, ULTRASCALE)
--   )
--port map (
--  RDY    => open,           -- 1-bit output: Ready output
--  REFCLK => ref_clk,        -- 1-bit input: Reference clock input
--  RST    => idelayctrl_rst  -- 1-bit input: Active high reset input
--);


--------------------------------------------------------------------------------------------
-- 100G Ethernet Port Clock Buffer
--------------------------------------------------------------------------------------------

-- GTX Clock Buffer
GE_IBUFDS_GTE4_inst : IBUFDS_GTE4
   port map (
   I     => MGTREFCLK129_P,
   IB    => MGTREFCLK129_N,
   O     => gt_ref_clk_100ge, -- 156.25MHz
   ODIV2 => open,
   CEB   => '0'
   );


end Behavioral;
