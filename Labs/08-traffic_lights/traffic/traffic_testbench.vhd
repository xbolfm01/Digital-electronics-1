LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY traffic_testbench IS
END traffic_testbench;
 
ARCHITECTURE behavior OF traffic_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT traffic
    PORT(
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
	 ce_2Hz_i : IN std_logic;
         lights_o : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';
   signal ce_2Hz_i : std_logic :='0';

 	--Outputs
   signal lights_o : std_logic_vector(5 downto 0);
	
	constant clk_i_period : time := 10 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: traffic PORT MAP 
		 (
          clk_i => clk_i,
          srst_n_i => srst_n_i,
			 ce_2Hz_i => ce_2Hz_i,
          lights_o => lights_o
        );

   -- Clock process definitions
   clk_i_process : process
			begin
			clk_i <= '0';
			wait for clk_i_period/2;
			clk_i <= '1';
			wait for clk_i_period/2;
			end process;
			
	ce_2Hz_i_process :process
   begin
		ce_2Hz_i <= '0';
		wait for clk_i_period;
		ce_2Hz_i <= '1';
		wait for clk_i_period;
   end process;
 
   stim_proc: process
   begin
	
		srst_n_i <= '1';
			wait until rising_edge(clk_i);
			wait until rising_edge(clk_i);
		srst_n_i <= '0';
			wait until rising_edge(clk_i);
			wait until rising_edge(clk_i);
			wait until rising_edge(clk_i);
      srst_n_i <= '1';
      wait;
   end process;

END;
