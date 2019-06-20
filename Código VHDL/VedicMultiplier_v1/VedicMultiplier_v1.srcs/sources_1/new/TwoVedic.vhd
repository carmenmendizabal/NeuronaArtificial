library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Multiplicador de palabras de dos bits
entity twoVedic is
    Port ( a : in STD_LOGIC_VECTOR (1 downto 0);        -- señal de entrada         
           b : in STD_LOGIC_VECTOR (1 downto 0);        -- señal de entrada         
           mult : out STD_LOGIC_VECTOR (3 downto 0));   -- resultado de la multiplicación
end twoVedic;

architecture Behavioral of twoVedic is

component HalfAdder
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           s : out STD_LOGIC;
           c : out STD_LOGIC);
end component;

signal aux1, aux2, aux3, aux4 : STD_LOGIC;

begin

mult(0) <= a(0) and b(0);

aux1 <= a(1) and b(0);
aux2 <= a(0) and b(1);

HA_1 : HalfAdder
    port map( a => aux1 ,
              b => aux2 ,
              s => mult(1) ,
              c => aux3 );
              
aux4 <= a(1) and b(1);

HA_2 : HalfAdder
    port map( a => aux3 ,
              b => aux4 ,
              s => mult(2) ,
              c => mult(3) );

end Behavioral;
