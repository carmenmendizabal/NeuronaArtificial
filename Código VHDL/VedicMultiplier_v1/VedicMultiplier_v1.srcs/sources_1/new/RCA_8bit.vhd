library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Ripple Carry Adder, sumador de señales de 8-bits
entity RCA_8bits is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);     -- señal de entrada         
           b : in STD_LOGIC_VECTOR (7 downto 0);     -- señal de entrada         
           s : out STD_LOGIC_VECTOR (7 downto 0);    -- bit de acarreo de entrada
           cout : out STD_LOGIC);                    -- resultado de la suma     
end RCA_8bits;                                       -- bit de acarreo de salida 

architecture Behavioral of RCA_8bits is

component RCA_4bits
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           cin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (3 downto 0);
           cout : out STD_LOGIC);
end component;

signal aux : STD_LOGIC;

begin

RCA_1 : RCA_4bits
    port map( a => a (3 downto 0) ,
              b => b (3 downto 0) ,
              cin => '0' ,
              s => s (3 downto 0) ,
              cout => aux );

RCA_2 : RCA_4bits
    port map( a => a (7 downto 4) ,
              b => b (7 downto 4) ,
              cin => aux ,
              s => s (7 downto 4) ,
              cout => cout );

end Behavioral;
