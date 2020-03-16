-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
--empty
end testbench;

architecture tb of testbench is
-- DUT component
component driver_7seg is
port(
	clk_i    : in  std_logic;
    srst_n_i : in  std_logic;   -- Synchronous reset (active low)
    data0_i  : in  unsigned(4-1 downto 0);  -- Input values
    data1_i  : in  unsigned(4-1 downto 0);
    data2_i  : in  unsigned(4-1 downto 0);
    data3_i  : in  unsigned(4-1 downto 0);
    dp_i     : in  unsigned(4-1 downto 0);  -- Decimal points
--OUT    
    dp_o     : out std_logic;                   
    seg_o    : out unsigned(7-1 downto 0);
    dig_o    : out unsigned(4-1 downto 0)
);
end component;

signal clk_in   : 	 std_logic := '0';
signal srst_n_in :   std_logic := '0';   -- Synchronous reset (active low)
signal data0_in  :   unsigned(4-1 downto 0) := x"4";  -- Input values
signal data1_in  :   unsigned(4-1 downto 0) := x"1";
signal data2_in  :   unsigned(4-1 downto 0) := x"3";
signal data3_in  :   unsigned(4-1 downto 0) := x"0";
signal dp_in     :   unsigned(4-1 downto 0) := "0100";  -- Decimal points
    
signal dp_out     :  std_logic;                       -- Decimal point
signal seg_out    :  unsigned(7-1 downto 0);
signal dig_out    :  unsigned(4-1 downto 0);

--constant clk_i_period : time := 10 ns;
BEGIN
	UUT: driver_7seg port map(
      clk_i => clk_in, 
      srst_n_i => srst_n_in, 
      data0_i => data0_in, 
      data1_i => data1_in, 
      data2_i => data2_in, 
      data3_i => data3_in, 
      dp_i => dp_in, 
      dp_o => dp_out, 
      seg_o => seg_out, 
      dig_o => dig_out
    );
	
-- Clock process definitions
--   clk_i_process : process
--   begin
--		clk_in <= '0';
--		wait for clk_i_period/2;
--		clk_in <= '1';
--		wait for clk_i_period/2;
--   end process;

	Clk_gen: process	-- NEW
  	begin
    	while Now < 500 NS loop		-- NEW: DEFINE SIMULATION TIME
      		clk_in <= '0';
      		wait for 0.5 NS;
      		clk_in <= '1';
      		wait for 0.5 NS;
    	end loop;
    	wait;
  	end process Clk_gen;
   
   -- Stimulus process
   stim_proc: process
   begin		
      --data0_in <= "0100";
      --data1_in <= "0001";
      --data2_in <= "0011";
      --data3_in <= "0000";
      --dp_in <= "0100";
 
      srst_n_in <= '1';
      wait until rising_edge(clk_in);	-- NEW
      wait until rising_edge(clk_in);	-- NEW
      srst_n_in <= '0';
      wait until rising_edge(clk_in);	-- NEW
      wait until rising_edge(clk_in);	-- NEW
      wait until rising_edge(clk_in);	-- NEW
      srst_n_in <= '1';
      
      wait;
   end process;
end tb;