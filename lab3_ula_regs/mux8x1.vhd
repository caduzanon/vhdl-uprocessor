library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8x1 is
   port( sel   : in unsigned(2 downto 0);
         entr0,entr1,entr2,entr3, entr4, entr5, entr6, entr7 : in unsigned(15 downto 0);
         saida                   : out unsigned(15 downto 0)
   );
end entity;

architecture a_mux8x1 of mux8x1 is
begin
   saida <=    entr0    when sel="000" else
               entr1    when sel="001" else
               entr2    when sel="010" else
               entr3    when sel="011" else
               entr4    when sel="100" else
               entr5    when sel="101" else
               entr6    when sel="110" else
               entr7    when sel="111" else
               "0000000000000000";     -- esse '0' é pra quando "der pau" em sel
end architecture;