library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(   clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(16 downto 0) 
    );
end entity;

architecture a_rom of rom is
    -- 17bits, assíncrona
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant conteudo_rom : mem := (
        -- caso endereco => conteudo
        0  => "00000000000000010", --00002
        1  => "00000100000000000", --00800
        2  => "00000000000000000", --00000
        3  => "00000000000000000", --00000
        4  => "00000100000000000", --00800
        5  => "00000000000000010", --00002
        6  => "00000111100000011", --00F03
        7  => "00000000000000010", --00002
        8  => "00000000000000010", --00002
        9  => "00000000000000000", --00000
        10 => "00000000000000000", --00000
        -- abaixo: casos omissos => (zero em todos os bits)
        others => (others=>'0')
   );

begin
    dado <= conteudo_rom(to_integer(endereco));
end architecture;