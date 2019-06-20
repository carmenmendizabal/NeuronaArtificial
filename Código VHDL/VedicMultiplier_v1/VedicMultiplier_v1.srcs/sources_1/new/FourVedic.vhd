library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Multiplicador de palabras de cuatro bits
entity FourVedic is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);        -- señal de entrada              
           b : in STD_LOGIC_VECTOR (3 downto 0);        -- señal de entrada              
           mult : out STD_LOGIC_VECTOR (7 downto 0));   -- resultado de la multiplicación
end FourVedic;

architecture Behavioral of FourVedic is

component twoVedic
    Port ( a : in STD_LOGIC_VECTOR (1 downto 0);
           b : in STD_LOGIC_VECTOR (1 downto 0);
           mult : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component RCA_4bits
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);    -- first term word
           b : in STD_LOGIC_VECTOR (3 downto 0);    -- second term word
           cin : in STD_LOGIC;  -- carry-in bit
           s : out STD_LOGIC_VECTOR (3 downto 0);   -- sum word
           cout : out STD_LOGIC);
end component;

component HalfAdder
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           s : out STD_LOGIC;
           c : out STD_LOGIC);
end component;


signal v2_out1, v2_out2, v2_out3, v2_out4 : STD_LOGIC_VECTOR (3 downto 0);
signal RCA_out1, RCA_out2, aux1, aux2 : STD_LOGIC_VECTOR (3 downto 0);
signal c1, c2, c3, aux3, aux4 : STD_LOGIC;

begin

V2_1 : twoVedic
    port map( a => a (1 downto 0) ,
              b => b (1 downto 0) ,
              mult => v2_out1 );

V2_2 : twoVedic
    port map( a => a (1 downto 0) ,
              b => b (3 downto 2) ,
              mult => v2_out2 );

V2_3 : twoVedic
    port map( a => a (3 downto 2) ,
              b => b (1 downto 0) ,
              mult => v2_out3 );

V2_4 : twoVedic
    port map( a => a (3 downto 2) ,
              b => b (3 downto 2) ,
              mult => v2_out4 );
              
RCA_1 : RCA_4bits
    port map( a => v2_out2 ,
              b => v2_out3 ,
              cin => '0' ,
              s => RCA_out1 ,
              cout => c1 );

aux1 <=  "00" & v2_out1(3 downto 2)  ;
RCA_2 : RCA_4bits
    port map( a => aux1 ,
              b => RCA_out1 ,
              cin => '0' ,
              s => RCA_out2 ,
              cout => c2 );

HA_1 : HalfAdder
    port map( a => c1 ,
              b => c2 ,
              s => aux3 ,
              c => aux4 );

aux2 <=  aux4 & aux3  & RCA_out2 (3 downto 2) ; 
RCA_3 : RCA_4bits
    port map( a => aux2 ,
              b => v2_out4 ,
              cin => '0' ,
              s => mult (7 downto 4) ,
              cout => c3 );
              
mult (3 downto 2) <= RCA_out2 (1 downto 0);
mult (1 downto 0) <= v2_out1 (1 downto 0);

end Behavioral;
