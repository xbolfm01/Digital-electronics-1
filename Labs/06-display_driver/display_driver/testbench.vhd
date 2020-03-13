-- NEW: USE ALDEC RIVIERA PRO simulator instead of GHDL

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testbench IS		-- NEW: RENAME TO TESTBENCH
END testbench;
 
ARCHITECTURE tb OF testbench IS		-- NEW: RENAME TO TESTBENCH
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock_enable
    PORT(
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
         clock_enable_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';

 	--Outputs
   signal clock_enable_o : std_logic;

   -- Clock period definitions
--   constant clk_i_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clock_enable PORT MAP (
          clk_i => clk_i,
          srst_n_i => srst_n_i,
          clock_enable_o => clock_enable_o
        );

-- Clock process definitions
--   clk_i_process :process
--   begin
--		clk_i <= '0';
--		wait for clk_i_period/2;
--		clk_i <= '1';
--		wait for clk_i_period/2;
--   end process;

	Clk_gen: process	-- NEW
  	begin
    	while Now < 500 NS loop		-- NEW: DEFINE SIMULATION TIME
      		clk_i <= '0';
      		wait for 5 NS;
      		clk_i <= '1';
      		wait for 5 NS;
    	end loop;
    	wait;
  	end process Clk_gen;

    -- Stimulus process
    stim_proc: process
    begin
        srst_n_i <= '1';
        wait until rising_edge(clk_i);	-- NEW
        wait until rising_edge(clk_i);	-- NEW
        srst_n_i <= '0';
        wait until rising_edge(clk_i);	-- NEW
        wait until rising_edge(clk_i);	-- NEW
        wait until rising_edge(clk_i);	-- NEW
        srst_n_i <= '1';
        wait;
    end process;
END tb;
