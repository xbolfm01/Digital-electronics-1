------------------------------------------------------------------------
--
-- Implementation of seven-segment display driver.
-- Xilinx XC2C256-TQ144 CPLD, ISE Design Suite 14.7
--
-- Copyright (c) 2019-2020 Tomas Fryza
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for top level
------------------------------------------------------------------------
entity top is
port (
    clk_i : in std_logic;       -- 10 kHz clock signal
    BTN0  : in std_logic;       -- Synchronous reset
    SW0_CPLD,  SW1_CPLD,  SW2_CPLD,  SW3_CPLD  : in std_logic; -- Input 0
    SW4_CPLD,  SW5_CPLD,  SW6_CPLD,  SW7_CPLD  : in std_logic; -- Input 1
    SW8_CPLD,  SW9_CPLD,  SW10_CPLD, SW11_CPLD : in std_logic; -- Input 2
    SW12_CPLD, SW13_CPLD, SW14_CPLD, SW15_CPLD : in std_logic; -- Input 3

    disp_dp    : out std_logic; -- Decimal point
    disp_seg_o : out std_logic_vector(7-1 downto 0);
    disp_dig_o : out std_logic_vector(4-1 downto 0)
);
end entity top;

------------------------------------------------------------------------
-- Architecture declaration for top level
------------------------------------------------------------------------
architecture Behavioral of top is
    signal s_data0, s_data1 : std_logic_vector(4-1 downto 0);
    signal s_data2, s_data3 : std_logic_vector(4-1 downto 0);
begin

    -- Combine 4-bit inputs to internal signals
    -- WRITE YOUR CODE HERE
    
    
    
    

    --------------------------------------------------------------------
    -- Sub-block of driver_7seg entity
    --- WRITE YOUR CODE HERE
  
    
    driver_7seg : entity work.driver_7seg
       port map {
                    clk_i <= clk_i,
                    srst_n_i <= BNT0,
                    data0_i <= s_data0,
                    data1_i <= s_data1,
                    data2_i <= s_data2,
                    data3_i <= s_data3,
                    dp_o <= disp_dp,
                    seg_o <= disp_seg_o,
                    dig_o <= disp_dig_o
    );


end architecture Behavioral;
