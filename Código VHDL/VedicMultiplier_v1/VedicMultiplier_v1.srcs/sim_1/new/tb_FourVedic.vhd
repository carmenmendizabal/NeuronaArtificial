library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- testbench de FourVedic.vhd
entity tb_FourVedic is
end tb_FourVedic;

architecture tb of tb_FourVedic is

-- modulo a probar
component FourVedic
    port (a    : in std_logic_vector (3 downto 0);
          b    : in std_logic_vector (3 downto 0);
          mult : out std_logic_vector (7 downto 0));
end component;

-- señales auxiliares
signal a    : std_logic_vector (3 downto 0):= "1011";
signal b    : std_logic_vector (3 downto 0):= "1111";
signal mult : std_logic_vector (7 downto 0);

begin

UUT : FourVedic
port map (a    => a,
          b    => b,
          mult => mult);

a <= std_logic_vector(unsigned(a)+2) after 10ns;
b <= std_logic_vector(unsigned(b)+7) after 3ns;

end tb;