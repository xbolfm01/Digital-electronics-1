library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

  entity comparator is
	 Generic (
				  nBitRefIn : integer;
				  nBitSetIn : integer
				);
				 
    Port ( 
			  refIn : in  STD_LOGIC_VECTOR (nBitRefIn-1 downto 0);
           setIn : in  STD_LOGIC_VECTOR (nBitSetIn-1 downto 0);
           output : out  STD_LOGIC
			 );

end comparator;

architecture Behavioral of comparator is

	begin
	
		output <= '0' when setIn > refIn 
				else
				 '1';

end Behavioral;