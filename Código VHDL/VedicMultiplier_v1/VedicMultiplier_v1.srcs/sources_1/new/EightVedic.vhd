library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Multiplicador de palabras de ocho bits
entity EightVedic is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);       -- señal de entrada              
           b : in STD_LOGIC_VECTOR (7 downto 0);       -- señal de entrada              
           p : out STD_LOGIC_VECTOR (15 downto 0));    -- resultado de la multiplicación
end EightVedic;

architecture Behavioral of EightVedic is

component FourVedic
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           mult : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component RCA_8bits
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);    -- first term word
           b : in STD_LOGIC_VECTOR (7 downto 0);    -- second term word
           s : out STD_LOGIC_VECTOR (7 downto 0);   -- sum word
           cout : out STD_LOGIC);
end component;

component HalfAdder
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           s : out STD_LOGIC;
           c : out STD_LOGIC);
end component;

signal v4_out1, v4_out2, v4_out3, v4_out4 : STD_LOGIC_VECTOR (7 downto 0);
signal RCA_out1, RCA_out2, aux1, aux2 : STD_LOGIC_VECTOR (7 downto 0);
signal c1, c2, c3, aux3, aux4 : STD_LOGIC;

begin

V4_1 : FourVedic
    port map( a => a (3 downto 0) ,
              b => b (3 downto 0) ,
              mult => v4_out1 );

V4_2 : FourVedic
    port map( a => a (3 downto 0) ,
              b => b (7 downto 4) ,
              mult => v4_out2 );

V4_3 : FourVedic
    port map( a => a (7 downto 4) ,
              b => b (3 downto 0) ,
              mult => v4_out3 );

V4_4 : FourVedic
    port map( a => a (7 downto 4) ,
              b => b (7 downto 4) ,
              mult => v4_out4 );
              
RCA_1 : RCA_8bits
    port map( a => v4_out2 ,
              b => v4_out3 ,
              s => RCA_out1 ,
              cout => c1 );

aux1 <= "0000" & v4_out1(7 downto 4);
RCA_2 : RCA_8bits
    port map( a => aux1 ,
              b => RCA_out1 ,
              s => RCA_out2 ,
              cout => c2 );

HA_1 : HalfAdder
    port map( a => c1 ,
              b => c2 ,
              s => aux3 ,
              c => aux4 );

aux2 <= "00" & aux4 &  aux3  & RCA_out2 (7 downto 4); 
RCA_3 : RCA_8bits
    port map( a => aux2 ,
              b => v4_out4 ,
              s => p (15 downto 8) ,
              cout => c3 );

p (7 downto 0) <= RCA_out2 (3 downto 0) & v4_out1 (3 downto 0);

end Behavioral;
