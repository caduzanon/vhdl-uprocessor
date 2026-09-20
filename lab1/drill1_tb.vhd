library ieee;
use ieee.std_logic_1164.all;

entity drill1_tb is
end;

architecture a_drill1_tb of drill1_tb is
    component drill1
        port( in_a : in std_logic;
          in_b : in std_logic;
          out1 : out std_logic;
          out2 : out std_logic;
          out3 : out std_logic;
          out4 : out std_logic
        );
    end component;
    signal in_a, in_b, out1, out2, out3, out4: std_logic;
begin
    uut: drill1 port map( in_a => in_a, in_b => in_b, out1 => out1, out2 => out2, out3 => out3, out4 => out4);
    process
        begin
            in_a <= '0';
            in_b <= '0';
            wait for 50 ns;
            in_a <= '0';
            in_b <= '1';
            wait for 50 ns;
            in_a <= '1';
            in_b <= '0';
            wait for 50 ns;
            in_a <= '1';
            in_b <= '1';
            wait for 50 ns;
            wait;
    end process;
end architecture;