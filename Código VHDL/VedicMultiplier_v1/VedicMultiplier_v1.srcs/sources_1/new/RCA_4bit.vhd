library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Ripple Carry Adder, sumador de señales de 4-bits
entity RCA_4bits is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);    -- señal de entrada
           b : in STD_LOGIC_VECTOR (3 downto 0);    -- señal de entrada
           cin : in STD_LOGIC;                      -- bit de acarreo de entrada
           s : out STD_LOGIC_VECTOR (3 downto 0);   -- resultado de la suma
           cout : out STD_LOGIC);                   -- bit de acarreo de salida
end RCA_4bits;

architecture Behavioral of RCA_4bits is

--Full Adder
component FullAdder
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           cin : in STD_LOGIC;
           s : out STD_LOGIC;
           cout : out STD_LOGIC);
end component;

signal carry : STD_LOGIC_VECTOR (2 downto 0);

begin

FA0: FullAdder
    port map(a => a(0),
             b => b(0),
             cin => cin,
             s => s(0),
             cout => carry(0));

FA1: FullAdder
    port map(a => a(1),
             b => b(1),
             cin => carry(0),
             s => s(1),
             cout => carry(1));

FA2: FullAdder
    port map(a => a(2),
             b => b(2),
             cin => carry(1),
             s => s(2),
             cout => carry(2));

FA3: FullAdder
    port map(a => a(3),
             b => b(3),
             cin => carry(2),
             s => s(3),
             cout => cout);

end Behavioral;