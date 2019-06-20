library ieee;
use ieee.std_logic_1164.all;

package mac_utils is
  constant nbits : integer := 19;
  constant nbits_RCA : integer := 4;
  constant nMux : integer := 8;
  constant nSum : integer := 7;
  constant nSum_1 : integer := 4;
  constant nSum_2 : integer := 2;
  constant nSum_3 : integer := 1;
  type WORD_ARRAY_type is array (integer range <>) of STD_LOGIC_VECTOR (7 downto 0);
  type B16_ARRAY_type is array (integer range <>) of STD_LOGIC_VECTOR (15 downto 0);
  type B19_ARRAY_type is array (integer range <>) of STD_LOGIC_VECTOR (18 downto 0);
end;