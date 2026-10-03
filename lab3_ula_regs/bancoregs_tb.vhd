library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoregs_tb is
end entity;

architecture a_bancoregs_tb of bancoregs_tb is
    component bancoregs is
        port(reg_wr : in unsigned(2 downto 0);
            reg_read_1 : in unsigned(2 downto 0);
            reg_read_2 : in unsigned(2 downto 0);
            data_in_banco : in unsigned(15 downto 0);
            wr_en_banco : in std_logic;
            clk_banco : in std_logic;
            rst_banco : in std_logic;

            rd_1 : out unsigned(15 downto 0);
            rd_2 : out unsigned(15 downto 0)
        );
    end component;

    signal data_in_banco                        : unsigned(15 downto 0);
    signal rd_1, rd_2                           : unsigned(15 downto 0);
    signal reg_wr, reg_read_1, reg_read_2       : unsigned(2 downto 0);
    signal clk_banco, rst_banco, wr_en_banco    : std_logic;
    constant period_time                        : time := 50 ns;
    signal finished                             : std_logic := '0';
begin
    uut: bancoregs port map (
        data_in_banco   =>  data_in_banco,
        rd_1            =>  rd_1,
        rd_2            =>  rd_2,
        reg_wr          =>  reg_wr,
        reg_read_1      =>  reg_read_1,
        reg_read_2      =>  reg_read_2,
        clk_banco       =>  clk_banco,
        rst_banco       =>  rst_banco,
        wr_en_banco     =>  wr_en_banco
    );

    sim_time_proc: process
        begin
        wait for 3 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk_banco <= '0';
            wait for period_time/2;
            clk_banco <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process --casos de teste
    begin
        data_in_banco <= x"0000";
        rst_banco   <= '1';
        wr_en_banco <= '0';
        reg_wr      <= "000";
        reg_read_1  <= "000";
        reg_read_2  <= "000";
        wait for period_time * 2; -- espera 100 ns sob reset
        
        rst_banco   <= '0';       -- solta o reset
        wait for period_time;     -- espera estabilizar

        
        --colocar dado mas sem we, duas leituras no reg0.
        reg_read_1 <= "000";
        reg_read_2 <= "000";
        data_in_banco <= x"CAFE";
        wait for period_time;

        --escrever no reg 1, ler o reg1.
        reg_wr <= "001";
        wr_en_banco <= '1';
        reg_read_2 <= "001";
        wait for period_time;

        --ler o reg0 e reg1.
        wr_en_banco <= '0';
        reg_read_2 <= "001";
        wait for period_time;

        --escrever no reg2, ler reg 0 e 1
        reg_wr <= "010";
        data_in_banco <= x"FE10";
        wr_en_banco <= '1';
        reg_read_1 <= "000";
        reg_read_2 <= "001";
        wait for period_time;

        --ler o reg2 e reg3.
        wr_en_banco <= '0';
        reg_read_1 <= "010";
        reg_read_2 <= "011";
        wait for period_time;

        --ler o reg4 e reg5.
        reg_read_1 <= "100";
        reg_read_2 <= "101";
        wait for period_time;

        --ler o reg6 e reg7.
        reg_read_1 <= "110";
        reg_read_2 <= "111";
        wait for period_time;

        --escrever no reg3, ler reg 0 e 1
        reg_wr <= "011";
        data_in_banco <= x"F0F0";
        wr_en_banco <= '1';
        reg_read_1 <= "000";
        reg_read_2 <= "001";
        wait for period_time;

        --ler o reg2 e reg3.
        wr_en_banco <= '0';
        reg_read_1 <= "010";
        reg_read_2 <= "011";
        wait for period_time;

        --ler o reg4 e reg5.
        reg_read_1 <= "100";
        reg_read_2 <= "101";
        wait for period_time;

        --ler o reg6 e reg7.
        reg_read_1 <= "110";
        reg_read_2 <= "111";
        wait for period_time;

        --escrever no reg4, ler reg 0 e 1
        reg_wr <= "100";
        data_in_banco <= x"ABCD";
        wr_en_banco <= '1';
        reg_read_1 <= "000";
        reg_read_2 <= "001";
        wait for period_time;

        --ler o reg2 e reg3.
        wr_en_banco <= '0';
        reg_read_1 <= "010";
        reg_read_2 <= "011";
        wait for period_time;

        --ler o reg4 e reg5.
        reg_read_1 <= "100";
        reg_read_2 <= "101";
        wait for period_time;

        --ler o reg6 e reg7.
        reg_read_1 <= "110";
        reg_read_2 <= "111";
        wait for period_time;

        --escrever no reg5, ler reg 0 e 1
        reg_wr <= "101";
        data_in_banco <= x"FAFA";
        wr_en_banco <= '1';
        reg_read_1 <= "000";
        reg_read_2 <= "001";
        wait for period_time;

        --ler o reg2 e reg3.
        wr_en_banco <= '0';
        reg_read_1 <= "010";
        reg_read_2 <= "011";
        wait for period_time;

        --ler o reg4 e reg5.
        reg_read_1 <= "100";
        reg_read_2 <= "101";
        wait for period_time;

        --ler o reg6 e reg7.
        reg_read_1 <= "110";
        reg_read_2 <= "111";
        wait for period_time;

        --escrever no reg6, ler reg 0 e 1
        reg_wr <= "110";
        data_in_banco <= x"FEFE";
        wr_en_banco <= '1';
        reg_read_1 <= "000";
        reg_read_2 <= "001";
        wait for period_time;

        --ler o reg2 e reg3.
        wr_en_banco <= '0';
        reg_read_1 <= "010";
        reg_read_2 <= "011";
        wait for period_time;

        --ler o reg4 e reg5.
        reg_read_1 <= "100";
        reg_read_2 <= "101";
        wait for period_time;

        --ler o reg6 e reg7.
        reg_read_1 <= "110";
        reg_read_2 <= "111";
        wait for period_time;

        --escrever no reg7, ler reg 0 e 1
        reg_wr <= "111";
        data_in_banco <= x"BABA";
        wr_en_banco <= '1';
        reg_read_1 <= "000";
        reg_read_2 <= "001";
        wait for period_time;

        --ler o reg2 e reg3.
        wr_en_banco <= '0';
        reg_read_1 <= "010";
        reg_read_2 <= "011";
        wait for period_time;

        --ler o reg4 e reg5.
        reg_read_1 <= "100";
        reg_read_2 <= "101";
        wait for period_time;

        --ler o reg6 e reg7.
        reg_read_1 <= "110";
        reg_read_2 <= "111";
        wait for period_time;

        data_in_banco <= x"CACA";
        reg_wr <= "111";
        wr_en_banco <= '1';
        reg_read_1 <= "000";
        reg_read_2 <= "001";
        wait for period_time;

        reg_wr <= "000";
        --ler o reg2 e reg3.
        reg_read_1 <= "010";
        reg_read_2 <= "011";
        wait for period_time;

        reg_wr <= "001";
        --ler o reg4 e reg5.
        reg_read_1 <= "100";
        reg_read_2 <= "101";
        wait for period_time;

        reg_wr <= "010";
        --ler o reg6 e reg7.
        reg_read_1 <= "110";
        reg_read_2 <= "111";
        wait for period_time;

        reg_wr <= "011";
        reg_read_1 <= "000";
        reg_read_2 <= "001";
        wait for period_time;

        reg_wr <= "100";
        --ler o reg2 e reg3.
        reg_read_1 <= "010";
        reg_read_2 <= "011";
        wait for period_time;

        reg_wr <= "101";
        --ler o reg4 e reg5.
        reg_read_1 <= "100";
        reg_read_2 <= "101";
        wait for period_time;

        reg_wr <= "110";
        --ler o reg6 e reg7.
        reg_read_1 <= "110";
        reg_read_2 <= "111";
        wait for period_time;

        reg_wr <= "000";
        wr_en_banco <= '0';
        wait for period_time;

        rst_banco <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        rst_banco <= '0';
        wait for period_time;

        --escrever no reg5, ler reg 0 e 1
        reg_wr <= "101";
        data_in_banco <= x"FFFF";
        wr_en_banco <= '1';
        reg_read_1 <= "000";
        reg_read_2 <= "001";
        wait for period_time;

        --ler o reg2 e reg3.
        wr_en_banco <= '0';
        reg_read_1 <= "010";
        reg_read_2 <= "011";
        wait for period_time;

        --ler o reg4 e reg5.
        reg_read_1 <= "100";
        reg_read_2 <= "101";
        wait for period_time;

        --ler o reg6 e reg7.
        reg_read_1 <= "110";
        reg_read_2 <= "111";
        wait for period_time;

        wait;
    end process;
end architecture a_bancoregs_tb;
