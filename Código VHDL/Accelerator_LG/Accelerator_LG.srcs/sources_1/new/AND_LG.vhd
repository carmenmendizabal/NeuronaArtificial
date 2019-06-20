library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.accelerator_utils.all;

entity AND_LG is
    generic( ninputs : integer := 3);
    Port ( input : in STD_LOGIC_VECTOR ((ninputs - 2) downto 0);    -- señales de entrada de la neurona
           clk : in STD_LOGIC;                                      -- señal de reloj
           reset, start : in STD_LOGIC;                             -- bits de control reset y start
           finish : out STD_LOGIC;                                  -- bit de control finish
           output : out STD_LOGIC_VECTOR (7 downto 0));             -- salida de la neurona
end AND_LG;

architecture Behavioral of AND_LG is

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

signal clk_94_9M : STD_LOGIC := '0'; -- señal de reloj adaptada

signal input_1, input_2 : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
signal weight_array : WORD_ARRAY_type ((ninputs - 1) downto 0);
signal data_in_array : WORD_ARRAY_type ((ninputs - 1) downto 0);
signal output_reg : STD_LOGIC_VECTOR (7 downto 0);
signal finish_reg : STD_LOGIC;


begin

clk_94_9: clk_aux
    port map (clk_in1 => clk,
              clk_out1 => clk_94_9M);

-- ajuste de las señales para la entrada en la neurona
input_1 <= (dec => input(1), others=>'0');
input_2 <= (dec => input(0), others=>'0');

data_in_array(0) <= one;
data_in_array(1) <= input_1;
data_in_array(2) <= input_2;
weight_array(0) <= "10000000"; --(-16)
weight_array(1) <= "01010100"; --(+10,5)
weight_array(2) <= "01010100"; --(+10,5)



A: Accelerator
    generic map(ninputs => 3)
    port map (data_in => data_in_array,
              weight_in => weight_array,
              clk => clk_94_9M,
              reset => reset,
              start => start,
              finish => finish_reg,
              data_out => output_reg);

process (clk_94_9M)
begin

if(rising_edge(clk_94_9M)) then
    output <= output_reg;
    finish <= finish_reg;
end if;

end process;


end Behavioral;
