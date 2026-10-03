library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux1x8 is
   port( sel   : in unsigned(2 downto 0);
         entr : in unsigned(15 downto 0);
         saida0, saida1, saida2, saida3, saida4, saida5, saida6, saida7 : out unsigned(15 downto 0)
   );
end entity;

architecture a_demux1x8 of demux1x8 is
begin
   saida0 <=   entr     when sel="000" else
               "0000000000000000";
   saida1 <=   entr     when sel="001" else
               "0000000000000000";
   saida2 <=   entr     when sel="010" else
               "0000000000000000";   
   saida3 <=   entr     when sel="011" else
               "0000000000000000";         
   saida4 <=   entr     when sel="100" else
               "0000000000000000";
   saida5 <=   entr     when sel="101" else
               "0000000000000000";
   saida6 <=   entr     when sel="110" else
               "0000000000000000";
   saida7 <=   entr     when sel="111" else
               "0000000000000000";
end architecture;