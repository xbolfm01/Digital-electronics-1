
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity traffic is 
	port (
				-- Inputs
				clk_i : in std_logic; 		-- clock signal
				srst_n_i : in std_logic; 	-- reset aktivny v 0
				ce_2Hz_i : in std_logic; 	-- zmena frekvencie z 3Hz na 2 Hz
				
				-- Outputs
				lights_o : out std_logic_vector (5 downto 0)
				
			);
end entity traffic;

architecture Behavioral of traffic is

type   state_type is (EWred_NSgreen, EWred_NSyellow, EWred_NSred, EWgreen_NSred, EWyellow_NSred, EWred2_NSred2); 
signal state : state_type;
signal count : unsigned(3 downto 0);
constant SEC5: unsigned(3 downto 0) := "1001"; -- počíta sa len do 9 (1001) nie do 15 (1111) --> 10 period za 5 sekund
constant SEC1: unsigned(3 downto 0) := "0001"; -- počíta sa len do 1, nie do 3 --> 2 periody za sekundu 

begin
	traffic_lights : process (clk_i)
		begin
			
		if rising_edge (clk_i) then
			if srst_n_i = '0' then
				count <= "0000";			
				state <= EWred_NSgreen;
				
				elsif ce_2Hz_i = '1' then
					case state is 
							
							when EWred_NSgreen => 
								if count < SEC5 then
										state <= EWred_NSgreen;
										count <= count + 1;
								else 
									state <= EWred_NSyellow;
									count <= "0000";
								end if;
							
							when EWred_NSyellow =>
								if count < SEC1 then
										state <= EWred_NSyellow;
										count <= count + 1;
								else 
									state <= EWred_NSred;
									count <= "0000";
								end if;
							
							when EWred_NSred =>
								if count < SEC1 then
										state <= EWred_NSred;
										count <= count + 1;
								else
									state <= EWgreen_NSred;
									count <= "0000";
								end if;
									
							when EWgreen_NSred =>
								if count < SEC5 then
										state <= EWgreen_NSred;
										count <= count + 1;
								else
									state <= EWyellow_NSred;
									count <= "0000";
								end if;
							
							when EWyellow_NSred =>
								if count < SEC1 then
										state <= EWyellow_NSred;
										count <= count + 1;
								else 
									state <= EWred2_NSred2;
									count <= "0000";
								end if;
							
							when EWred2_NSred2  =>
								if count < SEC1 then
										state <= EWred2_NSred2;
										count <= count + 1;
								else 
									state <= EWred_NSgreen;
									count <= "0000";
								end if;
							
							when others =>
									state <= EWred_NSgreen;
									
						end case;
					end if;
				end if;
	end process traffic_lights;
				
	definicia_svetiel : process (state)
			begin 
				case state is				  --RYGRYG--		 
					when EWred_NSgreen  => lights_o <= "100001"; 
					when EWred_NSyellow => lights_o <= "100010";
					when EWred_NSred    => lights_o <= "100100";
					when EWgreen_NSred  => lights_o <= "001100";
					when EWyellow_NSred => lights_o <= "010100";
					when EWred2_NSred2  => lights_o <= "100100";
					when others         => lights_o <= "100001";
				end case;
	end process definicia_svetiel;
	
end architecture Behavioral;
