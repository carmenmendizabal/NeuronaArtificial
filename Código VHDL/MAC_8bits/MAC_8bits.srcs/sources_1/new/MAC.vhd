library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.mac_utils.all;

-- modulo encargado de realizar la funcion MACC formado por:
--      8 multiplicadores DADDA
--      7 sumadores CSA
--      1 accumulador CSA
entity MAC is
    generic( ninputs : integer := 2);                                -- numero de señales de entradas en el módulo
    Port ( data_in : in WORD_ARRAY_type ((ninputs - 1) downto 0);    -- a
           weight_in : in WORD_ARRAY_type ((ninputs - 1) downto 0);  -- b
           clk : in STD_LOGIC;                                       -- señal de reloj
           reset, start : in STD_LOGIC;                              -- señales de control reset y start
           s : out STD_LOGIC_VECTOR ((nbits + (((ninputs + ((nMux - (ninputs rem nMux))rem 8))/nMux)-1) + (nbits_RCA - ((nbits + (((ninputs + ((nMux - (ninputs rem nMux))rem 8))/nMux)-1)) rem nbits_RCA)) - 1) downto 0)); -- señal de salida de tamaño variable

-- uso de los recursos DSP
attribute use_dsp48 : string;
attribute use_dsp48 of MAC : entity is "yes";

end MAC;

architecture Behavioral of MAC is

component dadda_multi is
    Port( a : in STD_LOGIC_VECTOR(7 downto 0);
          b : in STD_LOGIC_VECTOR(7 downto 0);
          p : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component CSA
    Port ( a : in STD_LOGIC_VECTOR (18 downto 0);
           b : in STD_LOGIC_VECTOR (18 downto 0);
           cin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (18 downto 0);
           cout : out STD_LOGIC);
end component;

component CSA_ACC
    generic( ncycles: integer);
    Port ( a : in STD_LOGIC_VECTOR ((nbits - 1) downto 0);           -- entrada que procede el arbol sumador
           b : in STD_LOGIC_VECTOR ((nbits + ncycles + (nbits_RCA - ((nbits + ncycles) rem nbits_RCA)) - 1) downto 0); -- entrada retroalimentada
           cin : in STD_LOGIC;                                       -- bit de acarreo de entrada
           s : out STD_LOGIC_VECTOR ((nbits + ncycles + (nbits_RCA - ((nbits + ncycles) rem nbits_RCA)) - 1) downto 0); -- señal de salida
           cout : out STD_LOGIC);                                    -- bit de acarreo de salida
end component;

-- señales de control del sistema
constant remaining : integer := ((nMux - (ninputs rem nMux))rem 8);
constant ncycles : integer := ((ninputs + remaining)/nMux)-1;     -- numero de ciclos necesarios para registrar todas las señales de entrada
signal count_reg, count_next : STD_LOGIC_VECTOR (4 downto 0) := (others=>'0');   -- contador
signal started_next, started_reg : STD_LOGIC;
signal input_zeros : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
signal zeros :STD_LOGIC_VECTOR (2 downto 0) := (others=>'0');
signal ones :STD_LOGIC_VECTOR (2 downto 0) := (others=>'1');

-- señales auxiliares de multiplicadores
signal a_reg, a_next, b_reg, b_next : WORD_ARRAY_type (7 downto 0);
signal product : B16_ARRAY_type (7 downto 0);

-- Señales auxiliares de los sumadores
signal c_reg, c_next : B19_ARRAY_type (7 downto 0);
signal sum_1, d_reg, d_next : B19_ARRAY_type (3 downto 0);
signal sum_2, e_reg, e_next : B19_ARRAY_type (1 downto 0);
signal sum_3 : B19_ARRAY_type ((nSum_3-1) downto 0);
signal s_next, s_reg : STD_LOGIC_VECTOR ((nbits - 1) downto 0) := (others=>'0');

--Señales auxiliares del acumulador
signal acc, acc_next, acc_reg : STD_LOGIC_VECTOR ((nbits + ncycles + (nbits_RCA - ((nbits + ncycles) rem nbits_RCA)) - 1) downto 0) := (others=>'0');

begin

gen_stage_mux:
    for I in 0 to (nMux-1) generate
        MUX_X: dadda_multi
            port map(a => a_reg(I),
                     b => b_reg(I),
                     p => product(I));
    end generate gen_stage_mux;
 
gen_stage_sum_1:
    for I in 0 to ((nSum_1)-1) generate
        SUM_X: CSA
            port map(a => c_reg(I*2),
                     b => c_reg((I*2)+1),
                     cin => '0',
                     s => sum_1(I),
                     cout => open);
    end generate gen_stage_sum_1;
gen_stage_sum_2:
    for I in 0 to ((nSum_2)-1) generate
        SUM_X: CSA
            port map(a => d_reg(I*2),
                     b => d_reg((I*2)+1),
                     cin => '0',
                     s => sum_2(I),
                     cout => open);
    end generate gen_stage_sum_2;
gen_stage_sum_3:
    for I in 0 to ((nSum_3)-1) generate
        SUM_X: CSA
            port map(a => e_reg(I*2),
                     b => e_reg((I*2)+1),
                     cin => '0',
                     s => sum_3(I),
                     cout => open);
    end generate gen_stage_sum_3;

CSA_FINAL: CSA_ACC
    generic map(ncycles)
    port map (a => s_reg,
              b => acc_reg,
              cin => '0',
              s => acc,---s
              cout => open);

process(clk, reset)
begin
    if reset = '1' then
        for I in 0 to (nMux-1) loop
            a_reg(I) <= (others=>'0');
            b_reg(I) <= (others=>'0');
        end loop;
        for I in 0 to ((nSum_1)*2 -1) loop
            c_reg(I) <= (others=>'0');
        end loop;
        for I in 0 to ((nSum_2)*2 -1) loop
            d_reg(I) <= (others=>'0');
        end loop;
        for I in 0 to ((nSum_3)*2 -1) loop
            e_reg(I) <= (others=>'0');
        end loop;
        s_reg <= (others=>'0');
        acc_reg <= (others=>'0');
        count_reg <= (others=>'0');
        started_reg <= '0';
    elsif(rising_edge(clk)) then
        for I in 0 to (nMux-1) loop
            a_reg(I) <= a_next(I);
            b_reg(I) <= b_next(I);
        end loop;
        for I in 0 to ((nSum_1)*2 -1) loop
            c_reg(I) <= c_next(I);
        end loop;
        for I in 0 to ((nSum_2)*2 -1) loop
            d_reg(I) <= d_next(I);
        end loop;
        for I in 0 to ((nSum_3)*2 -1) loop
            e_reg(I) <= e_next(I);
        end loop;
        s_reg <= s_next;
        acc_reg <= acc_next;
        count_reg <= count_next;
        started_reg <= started_next;
    end if;
 end process;

process (start, count_reg, product, sum_1, sum_2, sum_3, acc, data_in, weight_in, input_zeros, a_reg, b_reg, c_reg, d_reg, e_reg, s_reg, acc_reg, started_reg)
begin
    --Valores por defecto, se mantienen
    for I in 0 to (nMux-1) loop
        a_next(I) <= a_reg(I);
        b_next(I) <= b_reg(I);
    end loop;
    for I in 0 to ((nSum_1)*2 -1) loop
        c_next(I) <= c_reg(I);
    end loop;
    for I in 0 to ((nSum_2)*2 -1) loop
        d_next(I) <= d_reg(I);
    end loop;
    for I in 0 to ((nSum_3)*2 -1) loop
        e_next(I) <= e_reg(I);
    end loop;
    s_next <= s_reg;
    acc_next <= acc_reg;
    count_next<= count_reg;
    started_next <= started_reg;
    
    --Comienza le ejecucion:
    --Se meten los valores a los multiplicadores y empieza la cuenta
    if(start = '1' AND started_reg='0') then
        if (ninputs >= nMux) then
            for I in 0 to (nMux-1) loop
                a_next(I) <= data_in(I);
                b_next(I) <= weight_in(I);
            end loop;
        else
            for I in 0 to (ninputs-1) loop
                a_next(I) <= data_in(I);
                b_next(I) <= weight_in(I);
            end loop;
            for I in ninputs to (nMux-1) loop
                a_next(I) <= input_zeros;
                b_next(I) <= input_zeros;
            end loop;
        end if;
        count_next <= std_logic_vector(to_unsigned(1, count_reg'length));
        started_next <= '1';
    
    elsif(count_reg >= STD_LOGIC_VECTOR(to_unsigned(1, count_reg'length)) and count_reg <= STD_LOGIC_VECTOR(to_unsigned(ncycles + 1 , count_reg'length))) then
        if (ninputs <= (unsigned(count_reg)*nMux)) then
            for I in 0 to (nMux-1) loop
                a_next(I) <= input_zeros;
                b_next(I) <= input_zeros;
            end loop;
        elsif (ninputs >= (to_integer(unsigned(count_reg)))*nMux + nMux) then
            for I in 0 to (nMux-1) loop
                a_next(I) <= data_in(((to_integer(unsigned(count_reg)))*nMux)+I);
                b_next(I) <= weight_in(((to_integer(unsigned(count_reg)))*nMux)+I);
            end loop;
        else
            for I in 0 to (nMux-remaining-1) loop
                a_next(I) <= data_in(((to_integer(unsigned(count_reg)))*nMux)+I);
                b_next(I) <= weight_in(((to_integer(unsigned(count_reg)))*nMux)+I);
            end loop;
            for I in (nMux-remaining) to (nMux-1) loop
                a_next(I) <= input_zeros;
                b_next(I) <= input_zeros;
            end loop;
        end if;
        --Se sigue el flujo de los sumadores
        for I in 0 to ((nSum_1)*2 -1) loop
            c_next(I) <= std_logic_vector(resize(signed(product(I)), c_next(I)'length));
        end loop;
        for I in 0 to ((nSum_2)*2 -1) loop
            d_next(I) <= sum_1(I);
        end loop;
        for I in 0 to ((nSum_3)*2 -1) loop
            e_next(I) <= sum_2(I);
        end loop;
        s_next <= sum_3(0);
        acc_next <= acc;
        count_next <= STD_LOGIC_VECTOR(unsigned(count_reg) + 1);
        
    elsif(count_reg > STD_LOGIC_VECTOR(to_unsigned(ncycles + 1, count_reg'length)) AND count_reg<=STD_LOGIC_VECTOR(to_unsigned((5+ncycles), count_reg'length))) then
        for I in 0 to (nMux-1) loop
            a_next(I) <= input_zeros;
            b_next(I) <= input_zeros;
        end loop;
        --Se sigue el flujo de los sumadores
        for I in 0 to ((nSum_1)*2 -1) loop
            c_next(I) <= std_logic_vector(resize(signed(product(I)), c_next(I)'length));
        end loop;
        for I in 0 to ((nSum_2)*2 -1) loop
            d_next(I) <= sum_1(I);
        end loop;
        for I in 0 to ((nSum_3)*2 -1) loop
            e_next(I) <= sum_2(I);
        end loop;
        s_next <= sum_3(0);
        acc_next <= acc;
        count_next <= STD_LOGIC_VECTOR(unsigned(count_reg) + 1); 
    end if;
    
end process;

s <= acc_reg;

end Behavioral;