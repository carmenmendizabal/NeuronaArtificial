library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
  port( a: in std_logic_vector(7 downto 0);       -- entrada del multiplicador
        b: in std_logic_vector(7 downto 0);       -- entrada del multiplicador
        clk: in std_logic;                        -- señal de reloj
        p: out std_logic_vector(15 downto 0));    -- resultado de la multiplicacion
end TOP;

architecture Behavioral of TOP is

component EightVedic is
  port( a: in std_logic_vector(7 downto 0);
        b: in std_logic_vector(7 downto 0);
        p: out std_logic_vector(15 downto 0));
end component;

-- señales de registro
signal a_reg, b_reg: STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
signal p_next, p_reg: STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');

begin

V8: EightVedic
    port map (a => a_reg,
              b => b_reg,
              p => p_next);

-- proceso de registro de las señales
process(clk)
begin
    if(rising_edge(clk)) then
        a_reg <= a;
        b_reg <= b;
        p_reg <= p_next;
     end if;
 end process;
   
p <= p_reg;

end Behavioral;