library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

library UNISIM;
use UNISIM.VComponents.all;
entity top is
    Port ( 
	    --Inputs 
	   clk_i : in  STD_LOGIC;
           enc_value_A : in  STD_LOGIC;										
           enc_value_B  : in  STD_LOGIC;										
           btn : in  STD_LOGIC :='1';
				
	    -- Outputs
           led : out  STD_LOGIC;
           anode : out  STD_LOGIC_VECTOR (3 downto 0);
           segment : out  STD_LOGIC_VECTOR (6 downto 0);
           dp : out  STD_LOGIC

	 );
end top;

architecture Behavioral of top is

    signal seconds, tens_of_seconds : std_logic_vector(3 downto 0) := "0000";			
    signal minutes, tens_of_minutes : std_logic_vector(3 downto 0) := "0000";				
	 signal counter : std_logic_vector(7 downto 0);
	 signal counter_disp : std_logic_vector(9 downto 0):="0000000000";
	 signal afterCounter : std_logic_vector(23 downto 0):=(others => '0');
	 signal debounceCounter : std_logic_vector(19 downto 0):=(others => '0');
	 signal refIn : std_logic_vector(9 downto 0):=(others => '0');
	 signal setIn : std_logic_vector(9 downto 0):=(others => '0');
	 signal pulse_200Hz : std_logic;
	 signal pulse_1sec : std_logic;
	 signal pulse_1ms : std_logic;
	 signal enc_value_A_prev : std_logic;
	 signal enc_value_B_prev : std_logic;
	 signal enc_value_A_new : std_logic;
	 signal enc_value_B_new : std_logic;
	 signal countingDone : std_logic :='0';
	 signal countingStart : std_logic :='0';
	 signal ledHelp : std_logic :='1';
	 signal ledHelp2 : std_logic :='1';
	 signal btnFlag : std_logic :='0';

begin

comparator : entity work.comparator
generic map(nBitRefIn => 10, nBitSetIn => 10)
port map (
		refIn => refIn,
		setIn => setIn,
		output	=> ledHelp2
			);

display : entity work.driver_7seg
port map(
				clk_i => clk_i, 
				srst_n_i => '1', 
				data0_i => seconds, 
				data1_i => tens_of_seconds, 
				data2_i => minutes, 
				data3_i => tens_of_minutes, 
				dp_i =>"1111",
				dp_o => dp, 
				seg_o => segment, 
				dig_o => anode
			);

CLK_200Hz : entity work.clock_enable
generic map (g_NPERIOD => x"9C40")		
port map (
				clk_i => clk_i,
				srst_n_i => '1',
				clock_enable_o => pulse_200Hz
			);

CLK_1000Hz : entity work.clock_enable
generic map (g_NPERIOD => x"1F40")		
port map (
				clk_i => clk_i,
				srst_n_i => '1',
				clock_enable_o => pulse_1ms
			);


bin_cnt : entity work.binary_cnt
generic map ( g_NBIT => 24)
port map (
				srst_n_i => countingStart,
				en_i => pulse_1sec,
				clk_i => clk_i,
				cnt_o => afterCounter
			);

-- Counter for referential level.
bin_cnt2 : entity work.counter_down
generic map ( g_NBIT => 10)
port map (
				srst_n_i => btn -- here was : srst_n_i => '1' before the correction
				en_i => '1',
				clk_i => clk_i,
				cnt_o => refIn
			);

--Counter for comparational level.
bin_cnt3 : entity work.counter_down
generic map ( g_NBIT => 10)
port map (
				srst_n_i => countingDone,
				en_i => pulse_1ms,
				clk_i => clk_i,
				cnt_o => setIn
			);


-- Test if button is pressed or not
process(clk_i,btn)
begin
-- If button is unpressed, then debounceCounter goes to 0, but if button is pressed debounceCounter counts
-- to 5 ms then reset itself and after that this process invoke btnFlag
-- btnFlag indicates that button is really pressed by us and not by some parasite impulse	
	if(btn='1') then
		debounceCounter <= (others => '0');
		
	elsif(rising_edge(clk_i)) then
			debounceCounter <= debounceCounter + 1; 
		
		if(debounceCounter>=x"9C40") then 
			debounceCounter <=  (others => '0');
		
		end if;
	end if;
end process;

-- checking if button was pressed 
btnFlag <= '1' when debounceCounter=x"9C40" else '0';

-- Button is pressed
process(clk_i, btnFlag)
begin
-- This process is synchronised with clock signal. If button is pressed then counting from the set value of time
-- is started (countingStart <= '1'). CountingDone signal is in 0 because this signal is in 1 only if the counting
-- from the set value of time is finished. LedHelp is in 0 this indicates that LED is brighting. When comparing 
-- level (setIn) is in 0, it means that LED is completely turned off. 	
	if (clk_i'event and clk_i='1') then 
	
	if btnFlag = '1' then
			countingStart <= '1';		-- enable counter
			countingDone <= '0';
			ledHelp <= '0';			-- light up LED
		
		elsif (afterCounter = counter_disp) then	
			-- counter_disp goes to zero then LED starts dim
			countingDone <= '1';
			
		elsif(setIn = x"000") then	
			-- LED is turned off
				countingStart <= '0';	-- turning off the counter which countes seconds
				countingDone <= '1';			
				ledHelp <= '1';
		
	end if;
	end if;

end process;

-- Creating pulse with frequency 200 Hz. When counter counts to (C8 hex) = (200 decimal), it means that we have
-- one pulse and counter is going to reset itself.
process(clk_i)
begin
	
	if (clk_i'event and clk_i='1') then
		pulse_1sec <= '0';
		
		if (pulse_200Hz='1' and countingStart='1') then
			counter <= counter + 1;
			
			if counter = x"C8" then

				counter <= (others => '0');
				pulse_1sec <= '1';
				
			end if;
		end if;
	end if;
end process;

-- Brightning the LED. 
-- When setIn goes to 0 it means, LED is turned off. But after that the process restarts and setIn set itself to 1 
--	and LED will bright. However we want to turn off the LED, therefore we use OR. So, if setIn is in 0, ledHelp2 is 
-- still in 0 and ledHelp is in 1. So 1 OR 0 = 1 (LED is brightning in 0 and LED is turned off in 1).
led <= ledHelp2 OR ledHelp;



-- Encoder
-- Setting the time to display.
process(clk_i)
begin
	if	(clk_i'event and clk_i='1') then			
			enc_value_A_prev <= enc_value_A_new;
			enc_value_B_prev <= enc_value_B_new;
			enc_value_A_new <= enc_value_A;
			enc_value_B_new <= enc_value_B;
		
		 -- If some position of encoder was changed, then starts the counting. 
		 -- To control the positions we use XOR. So if positions is unchanged (0 XOR 0 = 0) => no change.
		 -- But if some position change, then 1 XOR 0 = 1 => encoder changed his position. 
		if (((enc_value_A_prev XOR enc_value_A_new) OR (enc_value_B_prev XOR enc_value_B_new)) = '1') then	
			if((enc_value_A_new XOR enc_value_B_prev) = '1') then
				
				-- Incrementing.
				-- Time is increasing.
				counter_disp <= counter_disp + 1;
				
				seconds <= seconds + 1;
				
					if (seconds = "1001") then
						seconds <= "0000";
						tens_of_seconds <= (others => '0');
						tens_of_seconds<= tens_of_seconds + 1;
					if (tens_of_seconds = "1001") then
						tens_of_seconds <= "0000";
						tens_of_seconds <= (others => '0');
						minutes <= minutes + 1;
					end if;
				end if;
			else
				
				-- Decrementing
				-- Time is decrementing.
				if counter_disp = x"000" then
					null;							
				else
					counter_disp <= counter_disp - 1;
					
					
					seconds <= seconds - 1;
					if (seconds = "0000") then		
						seconds <= "1001";
						tens_of_seconds <= tens_of_seconds - 1;
						if (tens_of_seconds = "0000") then		
							tens_of_seconds <= "1001";
							minutes <= minutes - 1;
						
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;			

end process;

end architecture Behavioral;
