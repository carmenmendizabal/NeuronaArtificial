library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.accelerator_utils.all;

entity AND16_LG is
    generic( ninputs : integer := 16);
    Port ( input : in STD_LOGIC_VECTOR ((ninputs - 2) downto 0);    -- señales de entrada de la neurona
           clk : in STD_LOGIC;                                      -- señal de reloj
           reset, start : in STD_LOGIC;                             -- bits de control reset y start
           finish : out STD_LOGIC;                                  -- bit de control finish
           output : out STD_LOGIC_VECTOR (7 downto 0));             -- salida de la neurona
end AND16_LG;

architecture Behavioral of AND16_LG is

component clk_aux
    Port ( clk_in1 : in STD_LOGIC;   -- Clock in
           clk_out1 : out STD_LOGIC); -- Clock out
end component;

component Accelerator is
    generic( ninputs : integer);
    Port ( data_in : in WORD_ARRAY_type ((ninputs - 1) downto 0);     -- numero de señales de entradas de la neurona                         
           weight_in : in WORD_ARRAY_type ((ninputs -1) downto 0);    -- señales de entrada de la neurona                                    
           clk : in STD_LOGIC;                                        -- señales de pesos de la neurona                                      
           reset, start : in STD_LOGIC;                               -- señal de reloj                                                      
           finish : out STD_LOGIC;                                    -- señales de control reset y start                                    
           data_out : out STD_LOGIC_VECTOR (7 downto 0));             -- señal de control finish: indica cuando se ha terminado el calculo   
end component;                                                        -- salida de la neurona                                                

-- constants
constant sign : integer := 1;  -- constante que representa el numero de bits usados para el signo
constant int : integer := 4;   -- constante que representa el numero de bits usados para el parte entera
constant dec : integer := 3;   -- constante que representa el numero de bits usados para el parte decimal
constant one : STD_LOGIC_VECTOR (7 downto 0) := (dec => '1', others=>'0');   -- señal constante que representa un uno

signal clk_88_5M : STD_LOGIC := '0'; -- señal de reloj adaptada

signal input_1,input_2,input_3,input_4,input_5,input_6,input_7,input_8,input_9,input_10,input_11,input_12,input_13,input_14,input_15 : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
signal weight_array : WORD_ARRAY_type ((ninputs - 1) downto 0);
signal data_in_array : WORD_ARRAY_type ((ninputs - 1) downto 0);
signal output_reg : STD_LOGIC_VECTOR (7 downto 0);
signal finish_reg : STD_LOGIC;


begin

clk_88_5: clk_aux
    port map (clk_in1 => clk,
              clk_out1 => clk_88_5M);

-- ajuste de las señales para la entrada en la neurona
input_1 <= (dec => input(0), others=>'0');
input_2 <= (dec => input(1), others=>'0');
input_3 <= (dec => input(2), others=>'0');
input_4 <= (dec => input(3), others=>'0');
input_5 <= (dec => input(4), others=>'0');
input_6 <= (dec => input(5), others=>'0');
input_7 <= (dec => input(6), others=>'0');
input_8 <= (dec => input(7), others=>'0');
input_9 <= (dec => input(8), others=>'0');
input_10 <= (dec => input(9), others=>'0');
input_11 <= (dec => input(10), others=>'0');
input_12 <= (dec => input(11), others=>'0');
input_13 <= (dec => input(12), others=>'0');
input_14 <= (dec => input(13), others=>'0');
input_15 <= (dec => input(14), others=>'0');

data_in_array(0) <= one;
data_in_array(1) <= input_1;
data_in_array(2) <= input_2;
data_in_array(3) <= input_3;
data_in_array(4) <= input_4;
data_in_array(5) <= input_5;
data_in_array(6) <= input_6;
data_in_array(7) <= input_7;
data_in_array(8) <= input_8;
data_in_array(9) <= input_9;
data_in_array(10) <= input_10;
data_in_array(11) <= input_11;
data_in_array(12) <= input_12;
data_in_array(13) <= input_13;
data_in_array(14) <= input_14;
data_in_array(15) <= input_15;
weight_array(0) <= "10000000"; --(-16)
weight_array(1) <= "00001001"; --(+1,125)
weight_array(2) <= "00001001"; --(+1,125)
weight_array(3) <= "00001001"; --(+1,125)
weight_array(4) <= "00001001"; --(+1,125)
weight_array(5) <= "00001001"; --(+1,125)
weight_array(6) <= "00001001"; --(+1,125)
weight_array(7) <= "00001001"; --(+1,125)
weight_array(8) <= "00001001"; --(+1,125)
weight_array(9) <= "00001001"; --(+1,125)
weight_array(10) <= "00001001"; --(+1,125)
weight_array(11) <= "00001001"; --(+1,125)
weight_array(12) <= "00001001"; --(+1,125)
weight_array(13) <= "00001001"; --(+1,125)
weight_array(14) <= "00001001"; --(+1,125)
weight_array(15) <= "00001001"; --(+1,125)

A: Accelerator
    generic map(ninputs => 16)
    port map (data_in => data_in_array,
              weight_in => weight_array,
              clk => clk_88_5M,
              reset => reset,
              start => start,
              finish => finish_reg,
              data_out => output_reg);

process (clk_88_5M)
begin

    if(rising_edge(clk_88_5M)) then
        output <= output_reg;
        finish <= finish_reg;
    end if;

end process;


end Behavioral;
