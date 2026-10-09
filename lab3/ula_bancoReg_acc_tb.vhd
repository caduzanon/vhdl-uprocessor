library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_bancoReg_acc_tb is
end entity;

architecture a_ula_bancoReg_acc_tb of ula_bancoReg_acc_tb is

    component ula_bancoReg_acc is
        port(
            clk              : in  std_logic;
            rst              : in  std_logic;

            we_banco         : in  std_logic;
            we_accA          : in  std_logic;
            we_accB          : in  std_logic;

            sel_reg_wr       : in  unsigned(2 downto 0);
            sel_reg_rd       : in  unsigned(2 downto 0);

            sel_mux_acc_in   : in  unsigned(1 downto 0);
            sel_mux_banco_in : in  unsigned(1 downto 0);
            sel_mux_acc_ula  : in  std_logic;
            sel_mux_b_ula    : in  std_logic;

            sel_op_ula       : in  unsigned(1 downto 0);
            const_in         : in  unsigned(15 downto 0);

            flag_z, flag_v, flag_n : out std_logic;
            out_accA, out_accB, out_ula, out_banco : out unsigned(15 downto 0)
        );
    end component;

    constant period_time : time := 100 ns;

    signal finished         : std_logic := '0';
    signal clk              : std_logic := '0';
    signal rst              : std_logic := '0';

    signal we_banco         : std_logic := '0';
    signal we_accA          : std_logic := '0';
    signal we_accB          : std_logic := '0';

    signal sel_reg_wr       : unsigned(2 downto 0) := "000";
    signal sel_reg_rd       : unsigned(2 downto 0) := "000";

    signal sel_mux_acc_in   : unsigned(1 downto 0) := "00";
    signal sel_mux_banco_in : unsigned(1 downto 0) := "00";
    signal sel_mux_acc_ula  : std_logic := '0';
    signal sel_mux_b_ula    : std_logic := '0';

    signal sel_op_ula       : unsigned(1 downto 0) := "00";
    signal const_in         : unsigned(15 downto 0) := (others => '0');

    signal flag_z, flag_v, flag_n : std_logic;
    signal out_accA, out_accB, out_ula, out_banco : unsigned(15 downto 0);

begin

    uut: ula_bancoReg_acc port map (
        clk              => clk,
        rst              => rst,
        we_banco         => we_banco,
        we_accA          => we_accA,
        we_accB          => we_accB,
        sel_reg_wr       => sel_reg_wr,
        sel_reg_rd       => sel_reg_rd,
        sel_mux_acc_in   => sel_mux_acc_in,
        sel_mux_banco_in => sel_mux_banco_in,
        sel_mux_acc_ula  => sel_mux_acc_ula,
        sel_mux_b_ula    => sel_mux_b_ula,
        sel_op_ula       => sel_op_ula,
        const_in         => const_in,
        flag_z           => flag_z,
        flag_v           => flag_v,
        flag_n           => flag_n,
        out_accA         => out_accA,
        out_accB         => out_accB,
        out_ula          => out_ula,
        out_banco        => out_banco
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

        -- 1. LD AccA, #10
        sel_mux_acc_in <= "10";              -- MUX Acc -> constante
        const_in       <= "0000000000001010"; -- 10
        we_accA        <= '1';               -- escreve no AccA
        wait for period_time;
        we_accA        <= '0';

        -- 2. LD R2, #5
        sel_mux_banco_in <= "10";             -- MUX Banco -> constante
        const_in         <= "0000000000000101";-- 5
        sel_reg_wr       <= "010";            -- reg R2
        we_banco         <= '1';              -- escreve no banco
        wait for period_time;
        we_banco         <= '0';

        -- 3. ADD AccA, R2
        sel_reg_rd      <= "010";            -- le R2
        sel_mux_acc_ula <= '0';              -- in_a ula -> AccA
        sel_mux_b_ula   <= '0';              -- in_b ula -> banco
        sel_op_ula      <= "00";             -- ula soma

        sel_mux_acc_in  <= "00";             -- MUX Acc -> ula
        we_accA         <= '1';              -- salva resultado no AccA
        wait for period_time;
        we_accA         <= '0';

        -- 4. MOV R3, AccA
        sel_mux_banco_in <= "00";             -- MUX Banco -> AccA
        sel_reg_wr       <= "011";            -- reg R3
        we_banco         <= '1';              -- escreve no banco
        wait for period_time;
        we_banco         <= '0';

        -- 5. CMPI AccA, #15
        sel_mux_acc_ula <= '0';              -- in_a ula -> AccA
        sel_mux_b_ula   <= '1';              -- in_b ula -> constante
        const_in        <= "0000000000001111";-- 15
        sel_op_ula      <= "10";             -- ula cmp
        wait for period_time;

        -- 6. le R3 para checar valor
        sel_reg_rd <= "011";
        wait for period_time;

        -- 7. SUB AccA, #25 (testa flag_z = '1')
        sel_mux_acc_in <= "10";              -- MUX Acc -> constante
        const_in       <= "0000000000011001"; -- 25, 19 em hexadecimal
        we_accA        <= '1';               -- escreve no AccA
        wait for period_time;
        we_accA        <= '0';

        sel_mux_acc_ula <= '0';              -- in_a ula -> AccA
        sel_mux_b_ula   <= '1';              -- in_b ula -> constante
        const_in        <= "0000000000011001";-- 25
        sel_op_ula      <= "01";             -- ula sub (25 - 25 = 0)
        wait for period_time;                -- flag_z deve ir para '1'

        -- 8. SUB AccA, #20 (testa flag_n = '1') é para aparecer FFF6(-10)
        sel_mux_acc_in <= "10";              -- MUX Acc -> constante
        const_in       <= "0000000000001010"; -- 10
        we_accA        <= '1';               -- escreve no AccA
        wait for period_time;
        we_accA        <= '0';

        sel_mux_acc_ula <= '0';              -- in_a ula -> AccA
        sel_mux_b_ula   <= '1';              -- in_b ula -> constante
        const_in        <= "0000000000010100";-- 20
        sel_op_ula      <= "01";             -- ula sub (10 - 20 = -10)
        wait for period_time;                -- flag_n deve ir para '1'

        -- 9. ADD AccA, #1 (testa flag_v = '1'), é para aparecer 8000(32767)
        sel_mux_acc_in <= "10";              -- MUX Acc -> constante
        const_in       <= "0111111111111111"; -- 32767
        we_accA        <= '1';               -- escreve no AccA
        wait for period_time;
        we_accA        <= '0';

        sel_mux_acc_ula <= '0';              -- in_a ula -> AccA
        sel_mux_b_ula   <= '1';              -- in_b ula -> constante
        const_in        <= "0000000000000001";-- 1
        sel_op_ula      <= "00";             -- ula soma (overflow)
        wait for period_time;                -- flag_v deve ir para '1'

        -- 10. LSL AccB (opera com AccB) 001E -> 003C
        sel_mux_acc_in <= "10";              -- MUX Acc -> constante
        const_in       <= "0000000000001111"; -- 15
        we_accB        <= '1';               -- escreve no AccB
        wait for period_time;
        we_accB        <= '0';

        sel_mux_acc_ula <= '1';              -- in_a ula -> AccB
        sel_op_ula      <= "11";             -- ula lsl (15 << 1 = 30)
        sel_mux_acc_in  <= "00";              -- MUX Acc -> ula
        we_accB         <= '1';               -- salva resultado no AccB
        wait for period_time;
        we_accB         <= '0';

        finished <= '1';
        wait;
    end process;

end architecture;