library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for top level
------------------------------------------------------------------------
entity top is
    port (BTN1, BTN0:    in  std_logic;
          LD2, LD1, LD0: out std_logic);
end entity top;

------------------------------------------------------------------------
-- Architecture declaration for top level
------------------------------------------------------------------------
architecture Behavioral of top is
begin
    LD2 <=  (BTN0 and not BTN1);
    LD1 <= ((not BTN0 and not BTN1) or (BTN0 and BTN1));
    LD0 <=  BTN1 and not BTN0;
end architecture Behavioral;