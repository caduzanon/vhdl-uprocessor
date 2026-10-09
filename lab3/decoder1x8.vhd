library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder1x8 is
   port( sel : in unsigned(2 downto 0);
         sinal : in std_logic;
         saida0, saida1, saida2, saida3, saida4, saida5, saida6, saida7 : out std_logic
   );
end entity;

architecture a_decoder1x8 of decoder1x8 is
begin
    saida0 <=   '1' when sel="000" and sinal='1' else
                '0';
    saida1 <=   '1' when sel="001" and sinal='1' else
                '0';
    saida2 <=   '1' when sel="010" and sinal='1' else
                '0';
    saida3 <=   '1' when sel="011" and sinal='1' else
                '0';
    saida4 <=   '1' when sel="100" and sinal='1' else
                '0';
    saida5 <=   '1' when sel="101" and sinal='1' else
                '0';
    saida6 <=   '1' when sel="110" and sinal='1' else
                '0';
    saida7 <=   '1' when sel="111" and sinal='1' else
                '0';
end architecture;
