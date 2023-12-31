//------------------------------------------------------------------------------
//  (c) Copyright 2013 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES.
//------------------------------------------------------------------------------

`timescale 1ps / 1ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module cmac_usplus_0_shared_logic_wrapper
(
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 gt_ref_clk CLK" *)
    input         gt_ref_clk,
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 gt_txusrclk2 CLK" *)
    input         gt_txusrclk2,
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 gt_rxusrclk2 CLK" *)
    input         gt_rxusrclk2,
    output        gt_ref_clk_out,
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 rx_clk CLK" *)
    input         rx_clk,
    input         gt_powergood,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 gt_tx_reset_in RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    input         gt_tx_reset_in,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 gt_rx_reset_in RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    input         gt_rx_reset_in,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 core_drp_reset RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    input         core_drp_reset,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axi_usr_tx_reset RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    input         axi_usr_tx_reset,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axi_usr_rx_reset RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    input         axi_usr_rx_reset,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axi_usr_rx_serdes_reset RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    input [9:0]   axi_usr_rx_serdes_reset,
    input [9:0]   rx_serdes_clk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 core_tx_reset RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    input         core_tx_reset,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 tx_reset_out RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    output        tx_reset_out,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 core_rx_reset RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    input         core_rx_reset,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rx_reset_out RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    output        rx_reset_out,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rx_serdes_reset_out RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)    
    output [9:0]  rx_serdes_reset_out,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 tx_reset_done_sync RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)      
    output        tx_reset_done_sync,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 usr_tx_reset RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)    
    output        usr_tx_reset,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 usr_rx_reset RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)    
    output        usr_rx_reset,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 qpll0reset RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)       
    input  [0 :0] qpll0reset,
    output [0 :0] qpll0lock,
    output [0 :0] qpll0outclk,
    output [0 :0] qpll0outrefclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 qpll1reset RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)   
    input  [0 :0] qpll1reset,
    output [0 :0] qpll1lock,
    output [0 :0] qpll1outclk,
    output [0 :0] qpll1outrefclk,
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 drpclk_common_in CLK" *)
    input         drpclk_common_in,  
    input  [15:0] common0_drpaddr,
    input  [15:0] common0_drpdi,
    input         common0_drpwe,
    input         common0_drpen,
    output        common0_drprdy,
    output [15:0] common0_drpdo
);

assign gt_ref_clk_out = gt_ref_clk;

cmac_usplus_0_reset_wrapper i_cmac_usplus_0_reset_wrapper
(
    .gt_txusrclk2                         (gt_txusrclk2),
    .gt_rxusrclk2                         (gt_rxusrclk2),
    .rx_clk                               (rx_clk),
    .gt_tx_reset_in                       (gt_tx_reset_in),
    .gt_rx_reset_in                       (gt_rx_reset_in),
    .core_drp_reset                       (core_drp_reset),
    .axi_usr_tx_reset                     (axi_usr_tx_reset),
    .axi_usr_rx_reset                     (axi_usr_rx_reset),
    .axi_usr_rx_serdes_reset              (axi_usr_rx_serdes_reset),
    .rx_serdes_clk                        (rx_serdes_clk),
    .core_tx_reset                        (core_tx_reset),
    .tx_reset_out                         (tx_reset_out),
    .core_rx_reset                        (core_rx_reset),
    .rx_reset_out                         (rx_reset_out),
    .rx_serdes_reset_out                  (rx_serdes_reset_out),
    .tx_reset_done_sync                   (tx_reset_done_sync),
    .usr_tx_reset                         (usr_tx_reset),
    .usr_rx_reset                         (usr_rx_reset)
);

cmac_usplus_0_common_wrapper i_cmac_usplus_0_common_wrapper
(
    .refclk                               (gt_ref_clk),
    .qpll0reset                           (qpll0reset),
    .qpll0lock                            (qpll0lock),
    .qpll0outclk                          (qpll0outclk),
    .qpll0outrefclk                       (qpll0outrefclk),
    .drpclk_common_in                     (drpclk_common_in),
    .common0_drpaddr                      (common0_drpaddr),
    .common0_drpdi                        (common0_drpdi),
    .common0_drpwe                        (common0_drpwe),
    .common0_drpen                        (common0_drpen),
    .common0_drprdy                       (common0_drprdy),
    .common0_drpdo                        (common0_drpdo),
    .qpll1reset                           (qpll1reset),
    .qpll1lock                            (qpll1lock),
    .qpll1outclk                          (qpll1outclk),
    .qpll1outrefclk                       (qpll1outrefclk)
);

endmodule

