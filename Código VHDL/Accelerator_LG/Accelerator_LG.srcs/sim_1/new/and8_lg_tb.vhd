library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.accelerator_utils.all;

entity and8_lg_tb is
    generic( ninputs : integer := 8);
end and8_lg_tb;

architecture Behavioral of and8_lg_tb is

component and8_lg
    generic( ninputs : integer := 3);    -- number of inputs of the neuron, the rest of the modules inherit it from here
    Port ( input : in STD_LOGIC_VECTOR ((ninputs - 2) downto 0);   -- signals of this array are the inputs of the neuron
           clk : in STD_LOGIC;  -- clock signal
           reset, start : in STD_LOGIC; -- reset and start signals
           finish : out STD_LOGIC; -- finish signal
           output : out STD_LOGIC_VECTOR (7 downto 0));   -- output of the neuron
end component;
--INPUTS
signal X :  STD_LOGIC_VECTOR ((ninputs - 2) downto 0);
signal CLK, RESET, START : std_logic := '0';

--OUTPUTS
signal Z : std_logic_vector(7 downto 0) := (others => '0');
signal FIN : STD_LOGIC;

constant CLK_PERIOD : time := 10 ns;
--constant CLK_PERIOD : time := 100 ns;

begin

UUT: and8_lg
    generic map(ninputs)
    port map (input => X,
              clk => CLK,
              reset => RESET,
              start => START,
              finish => fin,
              output => z);

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

--ENTRAN TODO 1s
    X<="1111111";
    
    wait for 500*CLK_PERIOD;
    RESET <= '1';
    wait for CLK_PERIOD;
    RESET <= '0';
    wait for CLK_PERIOD;
    START <= '1';
    wait for CLK_PERIOD;
    START <= '0';
    wait for 15*CLK_PERIOD;
    
--ENTRAN 4 1s
    X<="1110001";
    RESET <= '1';
    wait for CLK_PERIOD;
    RESET <= '0';
    wait for CLK_PERIOD;
    START <= '1';
    wait for CLK_PERIOD;
    START <= '0';
    wait for 15*CLK_PERIOD;

--ENTRAN 7 1s
    X<="1111101";
    RESET <= '1';
    wait for CLK_PERIOD;
    RESET <= '0';
    wait for CLK_PERIOD;
    START <= '1';
    wait for CLK_PERIOD;
    START <= '0';
    wait for 15*CLK_PERIOD;
    
--ENTRAN 0 1s
    X<="0000000";
    RESET <= '1';
    wait for CLK_PERIOD;
    RESET <= '0';
    wait for CLK_PERIOD;
    START <= '1';
    wait for CLK_PERIOD;
    START <= '0';
    wait for 15*CLK_PERIOD;
    
    RESET <= '1';
    wait for CLK_PERIOD;
    RESET <= '0';
    wait;
    
    
end process;

end Behavioral;
