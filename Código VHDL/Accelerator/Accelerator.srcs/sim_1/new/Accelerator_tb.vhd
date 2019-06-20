library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.accelerator_utils.all;


entity Accelerator_tb is
    generic( ninputs : integer := 16);
end Accelerator_tb;

architecture Behavioral of Accelerator_tb is

component Accelerator
    generic( ninputs : integer := 16);    -- number of inputs of the neuron, the rest of the modules inherit it from here
    Port ( data_in : in WORD_ARRAY_type ((ninputs - 1) downto 0);   -- signals of this array are the inputs of the neuron
           weight_in : in WORD_ARRAY_type ((ninputs - 1) downto 0);
           clk : in STD_LOGIC;  -- clock signal
           reset, start : in STD_LOGIC; -- reset and start signals
           finish : out STD_LOGIC; -- finish signal
           data_out : out STD_LOGIC_VECTOR (7 downto 0));   -- output of the neuron
end component;

--INPUTS
signal X, Y :  WORD_ARRAY_type ((ninputs - 1) downto 0);
signal CLK, RESET, START : std_logic := '0';

--OUTPUTS
signal Z : std_logic_vector(7 downto 0) := (others => '0');
signal FIN : STD_LOGIC;

--constant CLK_PERIOD : time := 10 ns;
constant CLK_PERIOD : time := 100 ns;

begin

UUT: Accelerator
    generic map(ninputs)
    port map (data_in => X,
              weight_in =>Y,
              clk => CLK,
              reset => RESET,
              start => START,
              finish => fin,
              data_out => z);

-- Clock process
clk_proc: process
begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
end process;


stim_proc: process                
begin
    for I in 0 to (ninputs - 1) loop
        X(I) <= std_logic_vector(to_unsigned((I*3), 8));
    end loop;
    for I in 0 to (ninputs - 1) loop
        Y(I) <= std_logic_vector(to_unsigned((I+1), 8));
    end loop;

    RESET <= '1';
    wait for CLK_PERIOD;
    RESET <= '0';
    START <= '1';
    wait for CLK_PERIOD;
    START <= '0';
    wait for 8*CLK_PERIOD;
    
    for I in 0 to (ninputs - 1) loop
        X(I) <= std_logic_vector(to_unsigned((I*4), 8));
    end loop;
    for I in 0 to (ninputs - 1) loop
        Y(I) <= std_logic_vector(to_unsigned((I+2), 8));
    end loop;
    RESET <= '1';
    wait for CLK_PERIOD;
    RESET <= '0';
    wait for CLK_PERIOD;
    START <= '1';
    wait for CLK_PERIOD;
    START <= '0';
    wait for 8*CLK_PERIOD;
    
    for I in 0 to (ninputs - 1) loop
        X(I) <= std_logic_vector(to_unsigned((I), 8));
    end loop;
    for I in 0 to (ninputs - 1) loop
        Y(I) <= std_logic_vector(to_unsigned((I+2), 8));
    end loop;
    RESET <= '1';
    wait for CLK_PERIOD;
    RESET <= '0';
    wait for CLK_PERIOD;
    START <= '1';
    wait for CLK_PERIOD;
    START <= '0';
    wait for 8*CLK_PERIOD;
    
    RESET <= '1';
    wait for CLK_PERIOD;
    RESET <= '0';
    wait;
    
end process;

end Behavioral;
