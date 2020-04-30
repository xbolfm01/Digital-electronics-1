----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:15:56 04/30/2020 
-- Design Name: 
-- Module Name:    PWM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PWM is
    Port ( input : in  STD_LOGIC_VECTOR (3 downto 0);
           clk_i : in  STD_LOGIC;
           pwm_o : out  STD_LOGIC (g_NBIT-1 downto 0);
end PWM;

architecture Behavioral of PWM is

signal cnt: unsigned (3 downto 0) := "0000";
signal a: STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal k: STD_LOGIC := '0';

begin
--Counter
	process (clk_i)
	begin
		if (rising_edge(clk_i)) then
			cnt <= cnt + 1;
		end if;
	end process;

--Sample
	process (clk_i)
	begin
		if (rising_edge(clk_i)) then
			if (cnt = "1110") then
				a <= input;
			end if;
		end if;
	end process;

--Compare
k <= '1' when a = "1111" else
	  '0' when a = "0000" else
	  '0' when STD_LOGIC_VECTOR(cnt) > a else
	  '1';
				
--Neg. DKO
	process(clk_i)
	begin
		if(rising_edge(clk_i)) then
			pwm_o <= not k;
		end if;
	end process;

end Behavioral;

