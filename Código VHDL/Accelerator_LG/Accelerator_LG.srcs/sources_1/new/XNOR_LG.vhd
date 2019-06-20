library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.accelerator_utils.all;

entity XNOR_LG is
    generic( ninputs : integer := 3);
    Port ( input : in STD_LOGIC_VECTOR ((ninputs - 2) downto 0);    -- señales de entrada de la neurona
           clk : in STD_LOGIC;                                      -- señal de reloj
           reset, start : in STD_LOGIC;                             -- bits de control reset y start
           finish : out STD_LOGIC;                                  -- bit de control finish
           output : out STD_LOGIC_VECTOR (7 downto 0));             -- salida de la neurona
end XNOR_LG;

architecture Behavioral of XNOR_LG is

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

signal clk_94M : STD_LOGIC := '0'; -- señal de reloj adaptada

signal input_1, input_2 : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
signal weight_array_a1, weight_array_a2, weight_array_a3 : WORD_ARRAY_type ((ninputs - 1) downto 0);
signal data_in_array_a1, data_in_array_a2, data_in_array_a3 : WORD_ARRAY_type ((ninputs - 1) downto 0);
signal output_reg_a1, output_reg_a2, output_reg_a3 : STD_LOGIC_VECTOR (7 downto 0);
signal finish_reg_a1, finish_reg_a2, start_a3, finish_reg_a3 : STD_LOGIC := '0';


begin

clk_94: clk_aux
    port map (clk_in1 => clk,
              clk_out1 => clk_94M);

-- ajuste de las señales para la entrada en la neurona
input_1 <= (dec => input(1), others=>'0');
input_2 <= (dec => input(0), others=>'0');

--a1: AND
data_in_array_a1(0) <= one;
data_in_array_a1(1) <= input_1;
data_in_array_a1(2) <= input_2;
weight_array_a1(0) <= "10000000"; --(-30)
weight_array_a1(1) <= "01010100"; --(+20)
weight_array_a1(2) <= "01010100"; --(+20)

--a2: (NOT x1) AND (NOT x2)
data_in_array_a2(0) <= one;
data_in_array_a2(1) <= input_1;
data_in_array_a2(2) <= input_2;
weight_array_a2(0) <= "00101010"; --(+10)
weight_array_a2(1) <= "10101100"; --(+20)
weight_array_a2(2) <= "10101100"; --(+20)

--a3: OR
data_in_array_a3(0) <= one;
data_in_array_a3(1) <= output_reg_a1;
data_in_array_a3(2) <= output_reg_a2;
weight_array_a3(0) <= "11010110"; --(-10)
weight_array_a3(1) <= "01010100"; --(+20)
weight_array_a3(2) <= "01010100"; --(+20)

start_a3 <= finish_reg_a1 AND finish_reg_a2;

A1: Accelerator
    generic map(ninputs => 3)
    port map (data_in => data_in_array_a1,
              weight_in => weight_array_a1,
              clk => clk_94M,
              reset => reset,
              start => start,
              finish => finish_reg_a1,
              data_out => output_reg_a1);

A2: Accelerator
    generic map(ninputs => 3)
    port map (data_in => data_in_array_a2,
              weight_in => weight_array_a2,
              clk => clk_94M,
              reset => reset,
              start => start,
              finish => finish_reg_a2,
              data_out => output_reg_a2);

A3: Accelerator
    generic map(ninputs => 3)
    port map (data_in => data_in_array_a3,
              weight_in => weight_array_a3,
              clk => clk_94M,
              reset => reset,
              start => start_a3,
              finish => finish_reg_a3,
              data_out => output_reg_a3);

process (clk_94M)
begin
    if(rising_edge(clk_94M)) then
        output <= output_reg_a3;
        finish <= finish_reg_a3;
    end if;
end process;

end Behavioral;
