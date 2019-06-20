library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- testbench de TwoVedic.vhd
entity tb_twoVedic is
end tb_twoVedic;

architecture tb of tb_TwoVedic is

-- modulo a probar
component TwoVedic
    port (a    : in std_logic_vector (1 downto 0);
          b    : in std_logic_vector (1 downto 0);
          mult : out std_logic_vector (3 downto 0));
end component;

-- señales auxiliares
signal a    : std_logic_vector (1 downto 0);
signal b    : std_logic_vector (1 downto 0);
signal mult : std_logic_vector (3 downto 0);

begin

UUT : TwoVedic
port map (a    => a,
          b    => b,
          mult => mult);


STIMULI : process
begin
    a <= (others => '0');
    b <= (others => '0');
    wait for 10 ps;
    a <= "01";
    b <= "00";
    wait for 10 ps;
    a <= "01";
    b <= "10";
    wait for 10 ps;
    a <= "10";
    b <= "11";
    wait for 10 ps;
    a <= "11";
    b <= "11";

    wait;
end process;

end tb;
