library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

library UNISIM;
use UNISIM.VComponents.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clk_i : IN  std_logic;
         enc_value_A : IN  std_logic;
         enc_value_B : IN  std_logic;
         btn : IN  std_logic;
         led : OUT  std_logic;
         anode : OUT  std_logic_vector(3 downto 0);
         segment : OUT  std_logic_vector(6 downto 0);
         dp : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal enc_value_A : std_logic := '0';
   signal enc_value_B : std_logic := '0';
   signal btn : std_logic := '0';

 	--Outputs
   signal led : std_logic;
   signal anode : std_logic_vector(3 downto 0);
   signal segment : std_logic_vector(6 downto 0);
   signal dp : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 125 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clk_i => clk_i,
          enc_value_A => enc_value_A,
          enc_value_B => enc_value_B,
          btn => btn,
          led => led,
          anode => anode,
          segment => segment,
          dp => dp
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		wait for 100 ns;

      wait for clk_i_period*10;


      -- insert stimulus here
		enc_value_A <= '1';
		wait for clk_i_period;
		enc_value_B <= '1';
		wait for clk_i_period;
		enc_value_A <= '0';
		wait for clk_i_period;
		enc_value_B <= '0';
		wait for clk_i_period;
		
		enc_value_B <= '1';
		wait for clk_i_period;
		enc_value_A <= '1';
		wait for clk_i_period;
		enc_value_B <= '0';
		wait for clk_i_period;
		enc_value_A <= '0';
		wait for clk_i_period;
		
		btn <= '1';
		wait for 50 ms;
		btn <= '0';
		wait for 80 ms;
		btn <= '1';
      wait;
   end process;

END;