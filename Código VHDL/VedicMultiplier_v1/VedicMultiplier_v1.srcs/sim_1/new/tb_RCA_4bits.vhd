library ieee;
use ieee.std_logic_1164.all;

-- testbench de RCA_4bits.vhd
entity tb_RCA_4bits is
end tb_RCA_4bits;

architecture tb of tb_RCA_4bits is

-- modulo a probar
component RCA_4bits
    port (a    : in std_logic_vector (3 downto 0);
          b    : in std_logic_vector (3 downto 0);
          cin  : in std_logic;
          s    : out std_logic_vector (3 downto 0);
          cout : out std_logic);
end component;

-- señales auxiliares
signal a    : std_logic_vector (3 downto 0);
signal b    : std_logic_vector (3 downto 0);
signal cin  : std_logic;
signal s    : std_logic_vector (3 downto 0);
signal cout : std_logic;

begin

UUT : RCA_4bits
port map (a    => a,
          b    => b,
          cin  => cin,
          s    => s,
          cout => cout);

STIMULI : process
begin
    a <= (others => '0');
    b <= (others => '0');
    cin <= '0';
    
    wait for 10 ps;
    a <= "1111";
    b <= "1111";
    cin <= '1';
    wait for 10 ps;
    a <= "1111";
    b <= "0010";
    
    
    wait;
end process;

end tb;