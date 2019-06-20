-- módulo basado en sumador de:
-- https://github.com/sromerop/ArtificialNeuron

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.csa_utils.all;

entity CSA is
    Port ( a : in STD_LOGIC_VECTOR (18 downto 0); -- señal de entrada de 18 bits
           b : in STD_LOGIC_VECTOR (18 downto 0); -- señal de entrada de 18 bits
           cin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (18 downto 0); -- señal de salida
           cout : out STD_LOGIC);
end CSA;

architecture Behavioral of CSA is

-- CSA sums the addends both with carry-in = 0 and carry-in = 1 by the use of several RCAs, but the sum has a value or another depending on the value of carry-in
component RCA_4b
    Port ( a : in STD_LOGIC_VECTOR ((nbits_RCA - 1) downto 0);
           b : in STD_LOGIC_VECTOR ((nbits_RCA - 1) downto 0);
           cin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR ((nbits_RCA - 1) downto 0);
           cout : out STD_LOGIC);
end component;

component mux_2to1
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           ctrl : in STD_LOGIC;
           s : out STD_LOGIC);
end component;

-- adjustment of inputs
signal cin_input : STD_LOGIC;
signal a_input : STD_LOGIC_VECTOR (18 downto 0);
signal b_input : STD_LOGIC_VECTOR (18 downto 0);

constant remaining : integer := 1;  -- in order to fill all the inputs of the RCAs
signal zeros_RCA : STD_LOGIC_VECTOR ((remaining - 1) downto 0) := (others=>'0');   -- in order to be multiple of 4
signal ones_RCA : STD_LOGIC_VECTOR ((remaining - 1) downto 0) := (others=>'1');   -- in order to be multiple of 4
signal addend_a_fin, addend_b_fin : STD_LOGIC_VECTOR (19 downto 0);    -- final width of the addends (same width and filling all the inputs of the RCAs)

-- intermediate signal handling
constant nRCA : integer := 10;   -- sum is processed twice using ceiling function (+1)
signal carry_1 : cout_1_type((nRCA/2 - 1) downto 0);    -- signals of this array connect the carry-out of the previous RCA to the carry-in of the next RCA when carry-in is 1
signal carry_0 : cout_0_type((nRCA/2 - 1) downto 0);    -- signals of this array connect the carry-out of the previous RCA to the carry-in of the next RCA when carry-in is 0
signal sum_1 : sum_1_type ((nRCA/2 - 1) downto 0);    -- signals of this ay connect the sum of the RCA to the MUX when carry-in is 1
signal sum_0 : sum_0_type ((nRCA/2 - 1) downto 0);    -- signals of this array connect the sum of the RCA to the MUX when carry-in is 0

-- output signal handling
signal cout_output : STD_LOGIC;
signal sum_output : STD_LOGIC_VECTOR (19 downto 0);

begin

-- adjustment of inputs
a_input <= a;
b_input <= b;
cin_input <= cin;

addend_a_fin <= zeros_RCA & a_input when a(18) = '0' else  -- sign extension
                ones_RCA & a_input;
addend_b_fin <= zeros_RCA & b_input when a(18) = '0' else  -- sign extension
                ones_RCA & b_input;

-- sum of the adjusted inputs
    -- First stage gets the carry-in
    RCA_03_1: RCA_4b    -- carry-in bit is 1
        port map(a => addend_a_fin((nbits_RCA - 1) downto 0),
                 b => addend_b_fin((nbits_RCA - 1) downto 0),
                 cin => '1',
                 s => sum_1(0)((nbits_RCA - 1) downto 0),
                 cout => carry_1(0));
    RCA_03_0: RCA_4b    -- carry-in bit is 0
        port map(a => addend_a_fin((nbits_RCA - 1) downto 0),
                 b => addend_b_fin((nbits_RCA - 1) downto 0),
                 cin => '0',
                 s => sum_0(0)((nbits_RCA - 1) downto 0),
                 cout => carry_0(0));
    gen_stage_mux_ini:
        for I in 0 to (nbits_RCA - 1) generate
           MUX_X: mux_2to1  -- MUX to select the final value of the sum
               port map(a => sum_0(0)(I),
                        b => sum_1(0)(I),
                        ctrl => cin_input,
                        s => sum_output(I));
        end generate gen_stage_mux_ini;

    -- Middle stages follow the same pattern
    gen_stage:
        for I in 1 to nRCA/2 - 2 generate   -- Neither the first nor the last stages
            RCA_X_1: RCA_4b    -- carry-in bit is 1
                port map(a => addend_a_fin((nbits_RCA*I+(nbits_RCA - 1)) downto (nbits_RCA*I)),
                         b => addend_b_fin((nbits_RCA*I+(nbits_RCA - 1)) downto (nbits_RCA*I)),
                         cin => carry_1(I-1),
                         s => sum_1(I)((nbits_RCA - 1) downto 0),
                         cout => carry_1(I));
            RCA_X_0: RCA_4b    -- carry-in bit is 0
                port map(a => addend_a_fin((nbits_RCA*I+(nbits_RCA - 1)) downto (nbits_RCA*I)),
                         b => addend_b_fin((nbits_RCA*I+(nbits_RCA - 1)) downto (nbits_RCA*I)),
                         cin => carry_0(I-1),
                         s => sum_0(I)((nbits_RCA - 1) downto 0),
                         cout => carry_0(I));
            gen_stage_mux_med:
                for J in 0 to (nbits_RCA - 1) generate
                    MUX_X: mux_2to1  -- MUX to select the final value of the sum
                        port map(a => sum_0(I)(J),
                                 b => sum_1(I)(J),
                                 ctrl => cin_input,
                                 s => sum_output(nbits_RCA*I+J));
                end generate gen_stage_mux_med;
        end generate gen_stage;

    -- Last stage spits the carry-out
    RCA_N4N1_1: RCA_4b    -- carry-in bit is 1
        port map(a => addend_a_fin((nbits_RCA*(nRCA/2 - 1)+(nbits_RCA - 1)) downto (nbits_RCA*(nRCA/2 - 1))),
                 b => addend_b_fin((nbits_RCA*(nRCA/2 - 1)+(nbits_RCA - 1)) downto (nbits_RCA*(nRCA/2 - 1))),
                 cin => carry_1(nRCA/2 - 2),
                 s => sum_1(nRCA/2 - 1)((nbits_RCA - 1) downto 0),
                 cout => carry_1(nRCA/2 - 1));
    RCA_N4N1_0: RCA_4b    -- carry-in bit is 0 
        port map(a => addend_a_fin((nbits_RCA*(nRCA/2 - 1)+(nbits_RCA - 1)) downto (nbits_RCA*(nRCA/2 - 1))),
                 b => addend_b_fin((nbits_RCA*(nRCA/2 - 1)+(nbits_RCA - 1)) downto (nbits_RCA*(nRCA/2 - 1))),
                 cin => carry_0(nRCA/2 - 2),
                 s => sum_0(nRCA/2 - 1)((nbits_RCA - 1) downto 0),
                 cout => carry_0(nRCA/2 - 1));
    gen_stage_mux_fin:
        for I in 0 to (nbits_RCA - 1) generate
           MUX_X: mux_2to1  -- MUX to select the final value of the sum
               port map(a => sum_0(nRCA/2 - 1)(I),
                        b => sum_1(nRCA/2 - 1)(I),
                        ctrl => cin_input,
                        s => sum_output(nbits_RCA*(nRCA/2 - 1) + I));
        end generate gen_stage_mux_fin;
    MUX_COUT: mux_2to1  -- MUX to select the final value of the carry-out bit
        port map(a => carry_0(nRCA/2 - 1),
                 b => carry_1(nRCA/2 - 1),
                 ctrl => cin_input,
                 s => cout_output);

s <= sum_output(18 downto 0);
cout <= cout_output;

end Behavioral;