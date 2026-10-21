library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(16 downto 0) 
    );
end entity;

architecture a_rom of rom is
    -- 17bits, assíncrona
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant conteudo_rom : mem := (
        -- caso endereco => conteudo
        0  => "00000000000000000", --nop
        1  => "11110000000000011", --jmpr +3
        2  => "00000000000000000", --nop
        3  => "00000000000000000", --nop
        4  => "00000000000000000", --nop
        5  => "11110000001111111", --jmpr -1
        
        -- abaixo: casos omissos => (zero em todos os bits)
        others => (others=>'0')
   );

begin
    dado <= conteudo_rom(to_integer(endereco));
end architecture;