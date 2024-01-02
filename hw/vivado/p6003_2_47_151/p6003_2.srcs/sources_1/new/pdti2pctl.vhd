----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2018 09:43:53 AM
-- Design Name: 
-- Module Name: pdti2pctl - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
--
-- MODIFIED for John Jakabosky, USN 7/14/2020 to fix issue with CHIRP Generator
-- 
--
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pdti2pctl is
port (
--------------------------------------------------------------------------------
-- Input AXI-Stream (Pentek PDTI Format)   (s_axis_pdti_aclk)
--------------------------------------------------------------------------------
   -- tuser[63:0]    = timestamp[63:0]
   -- tuser[71:64]   = Gate Positions  
   -- tuser[79:72]   = Sync Positions      
   -- tuser[87:80]   = PPS  Positions  
   -- tuser[91:88]   = Samples/Cycle
   -- tuser[92]      = IQ of first sample in data 0 = I, 1 = Q
   -- tuser[94:93]   = Data Format 0 = 8-bit 1= 16 bit 2 = 24-bit 3 = 32-bit
   -- tuser[95]      = Data Type 0 = Real 1 = I/Q
   -- tuser[103:96]  = channel[7:0] 
   -- tuser[127:104] = Reserved 
   s_axis_pdti_aclk         : in  std_logic;
   s_axis_aresetn           : in  std_logic; -- reset  
   s_axis_pdti_tdata        : in  std_logic_vector(255 downto 0);
   s_axis_pdti_tuser        : in  std_logic_vector(127 downto 0);
   s_axis_pdti_tvalid       : in  std_logic;
--------------------------------------------------------------------------------
-- Output AXI-Stream (Pentek PCTL Format)   (s_axis_pdti_aclk)
--------------------------------------------------------------------------------   
   -- tdata[n-1:0]       = Gate Positions
   -- tdata[2n-1:n]      = Sync Positions   
   -- tdata[3n-1:2n]     = PPS Positions  
   m_axis_ptctl_tdata        : out std_logic_vector(31 downto 0);
   m_axis_ptctl_tvalid       : out std_logic
);
end pdti2pctl;

architecture Behavioral of pdti2pctl is

ATTRIBUTE X_INTERFACE_INFO : STRING;
ATTRIBUTE X_INTERFACE_INFO of s_axis_pdti_aclk: SIGNAL is "xilinx.com:signal:clock:1.0 s_axis_pdti_aclk CLK";
ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
ATTRIBUTE X_INTERFACE_PARAMETER of s_axis_pdti_aclk: SIGNAL is "ASSOCIATED_BUSIF s_axis_pdti:m_axis_ptctl, ASSOCIATED_RESET s_axis_aresetn";
		

begin

-- process(s_axis_pdti_aclk)
-- begin
   -- if rising_edge(s_axis_pdti_aclk) then
      -- m_axis_ptctl_tdata <= x"00" & s_axis_pdti_tuser(87 downto 64);
      -- m_axis_ptctl_tvalid <= s_axis_pdti_tvalid;
   -- end if;
-- end process;


process(s_axis_pdti_aclk)
begin
   if rising_edge(s_axis_pdti_aclk) then
      if s_axis_pdti_tvalid = '1' then
      m_axis_ptctl_tdata <= x"00" & s_axis_pdti_tuser(87 downto 64);
      end if;
   end if;   
end process;
   
m_axis_ptctl_tvalid <= '1';

end Behavioral;
