library ieee;
use ieee.std_logic_1164.all;

entity drill2 is
    port( in_a : in std_logic;
          in_b : in std_logic;
          in_c : in std_logic;
          out1 : out std_logic
    );
end entity;

architecture a_drill2 of drill2 is
begin
    out1 <= (not in_a and not in_b and in_c) or (not in_a and in_b and not in_c) or (in_a and not in_b and not in_c);
end architecture;