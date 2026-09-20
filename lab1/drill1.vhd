library ieee;
use ieee.std_logic_1164.all;

entity drill1 is
    port( in_a : in std_logic;
          in_b : in std_logic;
          out1 : out std_logic;
          out2 : out std_logic;
          out3 : out std_logic;
          out4 : out std_logic
    );
end entity;

architecture a_drill1 of drill1 is
begin
    out1 <= (not in_a) and (not in_b);
    out2 <= (not in_a) and in_b;
    out3 <= in_a and (not in_b);
    out4 <= in_a and in_b;
end architecture;