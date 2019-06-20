library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- sumador completo, FA
entity FA is
    Port ( a : in STD_LOGIC;        --bit de entrada      
           b : in STD_LOGIC;        --bit de entrada      
           cin : in STD_LOGIC;      --bit de acarreo de entrada
           s : out STD_LOGIC;       --resultado de la suma      
           cout : out STD_LOGIC);   --bit de acarreo de salida     
end FA;

architecture Behavioral of FA is

begin

s <= a xor b xor cin;
cout <=(a AND b) OR (cin AND a) OR (cin AND b) ;

end Behavioral;