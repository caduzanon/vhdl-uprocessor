library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg16bits_tb is
end entity;

architecture  a_banco_reg16bits_tb of banco_reg16bits_tb is

    component banco_reg16bits is
        port (
            clk        : in  std_logic;
            rst        : in  std_logic;
            wr_en      : in  std_logic;
            sel_reg_wr : in  unsigned(2 downto 0);
            sel_reg_rd : in  unsigned(2 downto 0);
            data_in    : in  unsigned(15 downto 0);
            data_out   : out unsigned(15 downto 0)
        );
    end component;
    constant period_time : time := 100 ns;

    signal finished : std_logic := '0';
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal wr_en      : std_logic := '0';
    signal sel_reg_wr : unsigned(2 downto 0);
    signal sel_reg_rd : unsigned(2 downto 0);
    signal data_in    : unsigned(15 downto 0);
    signal data_out   : unsigned(15 downto 0);

begin

    uut: banco_reg16bits port map (
                                    clk        => clk,
                                    rst        => rst,
                                    wr_en      => wr_en,
                                    sel_reg_wr => sel_reg_wr,
                                    sel_reg_rd => sel_reg_rd,
                                    data_in    => data_in,
                                    data_out   => data_out );

    reset_global: process
    begin
            rst <= '1';
            wait for period_time*2; -- espera 2 clocks, pra garantir
            rst <= '0';
            wait;
    end process;

    sim_time_proc: process
    begin 
            wait for 10 us;
            finished <= '1';
            wait;
    end process sim_time_proc;


    clk_proc: process
    begin
        while finished /='1' loop
            clk <= '0';
            wait for period_time/2;--sempre na metada do clock e quando wr_en =1, o data_out pega o valor do data_in na metade do clock do periodo
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process
    begin
        wait for 200 ns;

        wr_en <= '1';
        sel_reg_wr <= "000";--r0, vai escrever
        data_in    <= "0000000000000010";
        wait for 100 ns;

        wr_en <= '0';
        sel_reg_wr <= "000";
        data_in <= "1111111111111111";
        wait for 100 ns;

        sel_reg_rd <= "000"; --deve exibir 2
        wait for 100 ns;

        sel_reg_rd <= "001";--deve exibir 0
        wait for 100 ns;

        wr_en <= '1';
        sel_reg_wr <= "001";--r0, vai escrever
        data_in    <= "0000000000000011";
        wait for 100 ns;

        sel_reg_rd <= "001";
        wait;
    end process;

end architecture a_banco_reg16bits_tb;