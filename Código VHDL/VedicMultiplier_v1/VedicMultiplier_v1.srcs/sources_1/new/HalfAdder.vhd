library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- semisumador, HA
entity HalfAdder is
    Port ( a : in STD_LOGIC;    --bit de entrada
           b : in STD_LOGIC;    --bit de entrada
           s : out STD_LOGIC;   --resultado de la suma
           c : out STD_LOGIC);  --bit de acarreo
end HalfAdder;

architecture Behavioral of HalfAdder is

begin

    s <= a xor b;
    c <= a and b;

end Behavioral;
