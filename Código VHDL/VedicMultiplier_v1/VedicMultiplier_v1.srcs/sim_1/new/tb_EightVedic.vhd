library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- testbench de EightVedic.vhd
entity tb_EightVedic is
end tb_EightVedic;

architecture Behavioral of tb_EightVedic is

-- modulo a probar
component EightVedic 
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           p : out STD_LOGIC_VECTOR (15 downto 0));
end component;

-- señales auxiliares
signal a   : std_logic_vector (7 downto 0):= (others => '0');
signal b   : std_logic_vector (7 downto 0):= (others => '0');
signal p   : std_logic_vector (15 downto 0);

begin

UUT : EightVedic
port map (a   => a,
          b   => b,
          p   => p);

a <= std_logic_vector(unsigned(a)+13) after 10ns;
b <= std_logic_vector(unsigned(b)+23) after 5ns;

end Behavioral;
