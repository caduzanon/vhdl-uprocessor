library ieee;
use ieee.std_logic_1164.all;

entity maquina_estados_tb is
end entity;

architecture a_maquina_estados_tb of maquina_estados_tb is
    component maquina_estados is
        port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            estado : out std_logic
        );
    end component;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal estado   : std_logic;
    signal finished : std_logic := '0';

    constant period_time : time := 100 ns;

begin
    uut: maquina_estados port map (
        clk    => clk,
        rst    => rst,
        estado => estado
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time * 2;
        rst <= '0';
        wait;
    end process;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    stimulus_proc: process
    begin
        -- reset
        wait for period_time * 2;

        -- oscilar por 6 ciclos
        wait for period_time * 6;

        finished <= '1';
        wait;
    end process;

end architecture;