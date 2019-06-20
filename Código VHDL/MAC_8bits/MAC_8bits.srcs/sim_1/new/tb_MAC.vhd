library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.mac_utils.all;

entity MAC_tb is
    generic( ninputs : integer := 8);
end MAC_tb;

architecture Behavioral of MAC_tb is

component MAC
    generic( ninputs : integer := 8);
    Port ( data_in : in WORD_ARRAY_type ((ninputs - 1) downto 0); ---a
           weight_in : in WORD_ARRAY_type ((ninputs - 1) downto 0); ---b
           clk : in STD_LOGIC;
           reset, start : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR ((nbits + (((ninputs + ((nMux - (ninputs rem nMux))rem 8))/nMux)-1) + (nbits_RCA - ((nbits + (((ninputs + ((nMux - (ninputs rem nMux))rem 8))/nMux)-1)) rem nbits_RCA)) - 1) downto 0));
end component;

--Inputs
signal X :  WORD_ARRAY_type ((ninputs - 1) downto 0);
signal Y :  WORD_ARRAY_type ((ninputs - 1) downto 0);
signal CLK, RESET, START : std_logic := '0';
 
--Outputs
signal SUM : std_logic_vector((nbits + (((ninputs + ((nMux - (ninputs rem nMux))rem 8))/nMux)-1) + (nbits_RCA - ((nbits + (((ninputs + ((nMux - (ninputs rem nMux))rem 8))/nMux)-1)) rem nbits_RCA)) - 1) downto 0)  := (others => '0');

constant CLK_PERIOD : time := 10 ns;

begin

uut: MAC 
    generic map(ninputs)
    port map (data_in => X, 
              weight_in => Y, 
              clk => CLK,
              reset => RESET,
              start => START,
              s => SUM);

-- Clock process
   clk_proc: process
   begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
   end process;

-- Stimulus process
    stim_proc: process
    begin
    
    X(0) <= "00001010";
    Y(0) <= "00001111";
    
    X(1) <= "10110000";
    Y(1) <= "11110000"; 
    
    X(2) <= "00010000";
    Y(2) <= "10100000";
    for I in 3 to 7 loop
        X(I) <= (others=>'0');
        Y(I) <= (others=>'0');
    end loop;
        RESET <= '1';
        wait for CLK_PERIOD/2;
        START <= '1';
        wait for CLK_PERIOD/2;
        RESET <= '0';
        wait for CLK_PERIOD*2;
        START <= '0';
        wait;        
    end process;

end Behavioral;