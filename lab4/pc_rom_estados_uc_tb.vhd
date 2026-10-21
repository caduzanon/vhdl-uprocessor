library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_rom_estados_uc_tb is
end entity;

architecture a_pc_rom_estados_uc_tb of pc_rom_estados_uc_tb is
    component pc_rom_estados_uc is
        port (
            clk        : in  std_logic;
            rst        : in  std_logic;
            pc_out     : out unsigned(6 downto 0);
            instrucao  : out unsigned(16 downto 0);
            estado : out std_logic
        );
    end component;

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal pc_out_s     : unsigned(6 downto 0);
    signal instrucao_s  : unsigned(16 downto 0);
    signal estado_out_s : std_logic;
    signal finished   : std_logic := '0';

    constant period_time : time := 100 ns;

begin
    uut: pc_rom_estados_uc port map (
        clk        => clk,
        rst        => rst,
        pc_out     => pc_out_s,
        instrucao  => instrucao_s,
        estado => estado_out_s
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
        -- reset inicial
        wait for period_time * 2;

        -- rodar por 20 clocks (10 instruções)
        -- observar os saltos e o loop
        wait for period_time * 20;

        finished <= '1';
        wait;
    end process;

end architecture;