library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--duas entradas de 16b, uma saída de 16b, duas flags de 1b cada, uma entrada de seleção de 2b.
-- soma: a+b
-- sub: a-b
-- cmp: a>b
-- lsl: logic shift left (descarta o msb, desloca os 15 bits para a esquerda e insere 0 no lsb)
-- mux na saída escolhe o resultado relevante

entity ula is
    port( in_a : in unsigned(15 downto 0);
         in_b : in unsigned(15 downto 0);

         resultado_ula : out unsigned(15 downto 0);
         sel_op_ula : in unsigned(1 downto 0); -- 00 soma, 01 sub, 10 cmp, 11 lsl
         flag_z : out std_logic;--zero
         flag_v : out std_logic --overflow
   );
end entity;

architecture a_ula of ula is
    component mux4x1 is 
        port( 
            sel                   : in unsigned(1 downto 0);
            entr0,entr1,entr2,entr3 : in unsigned(15 downto 0);
            saida                   : out unsigned(15 downto 0)
        );
    end component;
    signal out_soma, out_sub, out_cmp, out_lsl, saida_mux : unsigned(15 downto 0);
begin
    mux: mux4x1 port map (entr0 => out_soma, entr1 => out_sub, entr2 => out_cmp, entr3 => out_lsl, sel => sel_op_ula, saida => saida_mux);

    out_soma <= in_a + in_b;
    out_sub <= in_a - in_b;
    out_cmp <= "1111111111111111" when signed(in_a) > signed(in_b) else
              "0000000000000000" when in_a<=in_b else
              "0000000000000000";
    out_lsl <= in_a(14 downto 0) & '0';

    flag_z <= '1' when saida_mux = "0000000000000000" else '0';
    flag_v <= ((not in_a(15) and not in_b(15)) and saida_mux(15)) or (in_a(15) and in_b(15) and not saida_mux(15)) when sel_op_ula = "00" else
              ((not in_a(15) and in_b(15)) and saida_mux(15)) or ((in_a(15) and not in_b(15)) and not saida_mux(15)) when sel_op_ula = "01" else
              in_a(15) xor in_a(14) when sel_op_ula = "11" else
              '0';
              
    resultado_ula <= saida_mux;
end architecture;