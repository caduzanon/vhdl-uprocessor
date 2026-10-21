library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end entity;

architecture a_pc_tb of pc_tb is
    component pc is
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            data_in  : in  unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    constant period_time : time := 100 ns;
    
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal wr_en    : std_logic := '0';
    signal data_in  : unsigned(6 downto 0) := (others => '0');
    signal data_out : unsigned(6 downto 0);
    

    signal finished : std_logic := '0';
begin

    uut: pc port map (
        clk              => clk,
        rst              => rst,
        wr_en            => wr_en,
        data_in          => data_in,
        data_out         => data_out
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
        wait for period_time * 2;

        -- carregar valor com we 0
        data_in <= "0000101"; -- 5
        wr_en   <= '0';
        wait for period_time;

        -- we 1 (gravar 5 no PC na borda de subida)
        wr_en   <= '1';
        wait for period_time;

        -- we ainda em 1, grava 12 no PC
        data_in <= "0001100"; -- 12
        wait for period_time;

        -- we em 0, deve manter o 12
        wr_en   <= '0';
        data_in <= "1111111"; -- 127
        wait for period_time * 2;

        -- we em 1, carregar o 127
        wr_en   <= '1';
        wait for period_time;
        wr_en   <= '0';
        wait for period_time;

        -- fim
        finished <= '1';
        wait;
    end process;

end architecture;