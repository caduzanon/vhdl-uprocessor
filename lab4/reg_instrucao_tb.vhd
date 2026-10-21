library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_instrucao_tb is
end entity;

architecture a_reg_instrucao_tb of reg_instrucao_tb is
    component reg_instrucao is
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            data_in  : in  unsigned(16 downto 0);
            data_out : out unsigned(16 downto 0)
        );
    end component;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal wr_en    : std_logic := '0';
    signal data_in  : unsigned(16 downto 0) := (others => '0');
    signal data_out : unsigned(16 downto 0);
    signal finished : std_logic := '0';

    constant period_time : time := 100 ns;

begin
    uut: reg_instrucao port map (
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en,
        data_in  => data_in,
        data_out => data_out
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

        -- tentar gravar com wr_en = '0'
        data_in <= "11110000000000011";
        wr_en   <= '0';
        wait for period_time * 2;

        -- wr_en = 1
        wr_en   <= '1';
        wait for period_time * 2;

        -- outro valor
        data_in <= "00000000000000000";
        wait for period_time * 2;

        -- wr_en = 0
        wr_en   <= '0';
        data_in <= "11111111111111111";
        wait for period_time * 2;

        finished <= '1';
        wait;
    end process;

end architecture;