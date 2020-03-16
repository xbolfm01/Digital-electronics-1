-- NEW: USE ALDEC RIVIERA PRO simulator instead of GHDL
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


entity testbench is
--
end testbench;

architecture tb of testbench is
 -- Component Declaration for the Unit Under Test (UUT)
component driver_7seg is
port(
	--Inputs
	clk_i : in  std_logic; --clock
    srst_n_i : in  std_logic;  --reset (low)
    data0_i  : in  unsigned(3 downto 0);  -- vstup do MX
    data1_i  : in  unsigned(3 downto 0);  -- vstup do MX
    data2_i  : in  unsigned(3 downto 0);  -- vstup do MX
    data3_i  : in  unsigned(3 downto 0);  -- vstup do MX
    dp_i     : in  unsigned(3 downto 0);  -- desatinna ciarka
    
    --Outputs
    dp_o  : out std_logic;               
    seg_o : out unsigned(6 downto 0);  --vystup
    dig_o : out unsigned(3 downto 0)   --vystup
);
end component;

signal clk_in  : std_logic := '0';
signal srst_n_in : std_logic := '0';  
signal data0_in : unsigned(3 downto 0) := "0100";
signal data1_in : unsigned(3 downto 0) := "0001";
signal data2_in : unsigned(3 downto 0) := "0011";
signal data3_in : unsigned(3 downto 0) := "0000";
signal dp_in : unsigned(3 downto 0) := "0100"; 
    
signal dp_out : std_logic;                      
signal seg_out : unsigned(6 downto 0);
signal dig_out : unsigned(3 downto 0);

constant clk_i_period : time := 10 ns;

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
	
-- Clock process definitions --> S tymto clock procesom nejde spustit simulacia
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