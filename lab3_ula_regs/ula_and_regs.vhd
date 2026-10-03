library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_and_regs is
    port(
        -- seletores para os muxes
        sel_op_ula, sel_mux_data_source_banco, sel_mux_data_source_accum : in unsigned (1 downto 0);
        sel_mux_reg_or_const, sel_mux_acc : in std_logic;

        -- write-enables para os registradores
        we_banco, we_accA, we_accB : in std_logic;

        -- entrada de dados
        data_in_bloco : in unsigned(15 downto 0);

        -- seletores para o banco
        sel_reg_rd, sel_reg_wr : in unsigned (2 downto 0);
        
        -- flags ula
        ula_fz, ula_fn, ula_fv : out std_logic;

        -- saídas de dados
        do_accA, do_accB, do_ula, do_banco, do_acc_input, do_banco_input, do_ula_input_A, do_ula_input_B : out unsigned (15 downto 0);

        -- clock e reset
        clk_bloco : in std_logic;
        rst_bloco : in std_logic
   );
end entity;

architecture a_ula_and_regs of ula_and_regs is
    component mux2x1 is
        port(   
            sel           : in std_logic;
            entr0,entr1   : in unsigned(15 downto 0);
            saida         : out unsigned(15 downto 0)
        );
    end component;

    component mux4x1 is
        port( 
            sel   : in unsigned(1 downto 0);
            entr0,entr1,entr2,entr3 : in unsigned(15 downto 0);
            saida                   : out unsigned(15 downto 0)
        );
    end component;

    component reg16b is
        port( 
            clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component bancoregs is
        port(
            reg_wr : in unsigned(2 downto 0);
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

    component ula is
        port( 
            in_a : in unsigned(15 downto 0);
            in_b : in unsigned(15 downto 0);
            resultado_ula : out unsigned(15 downto 0);
            sel_op_ula : in unsigned(1 downto 0); -- 00 soma, 01 sub, 10 cmp, 11 lsl
            flag_z : out std_logic;--zero
            flag_v : out std_logic; --overflow
            flag_n : out std_logic --negativo
    );
    end component;
    
    signal do_A, do_B, out_mux_acc, out_mux_reg_or_const, do_cte, do_ula_s, di_banco, do_banco_s, di_acc, data_mux_out_A, data_mux_out_B : unsigned(15 downto 0);

begin
    do_cte <= data_in_bloco;

    mux_data_to_banco_from_const_or_acc: mux4x1 port map (
        sel => sel_mux_data_source_banco, 
        saida => di_banco, 
        entr0 => do_A, 
        entr1 => do_B, 
        entr2 => do_cte, 
        entr3 => "0000000000000000"
    );

    mux_data_to_acc_from_ula_or_banco_or_const: mux4x1 port map (
        sel => sel_mux_data_source_accum, 
        saida => di_acc, 
        entr0 => do_ula_s, 
        entr1 => do_banco_s, 
        entr2 => do_cte, 
        entr3 => "0000000000000000"
    );

    data_mux_out_A <= di_acc; --selecionavel por we_accA
    data_mux_out_B <= di_acc; --selecionavel por we_accB

    accA: reg16b port map (
        clk => clk_bloco, 
        data_in => data_mux_out_A, 
        rst => rst_bloco, 
        wr_en => we_accA, 
        data_out => do_A
    );
    accB: reg16b port map (
        clk => clk_bloco, 
        data_in => data_mux_out_B, 
        rst => rst_bloco, 
        wr_en => we_accB, 
        data_out => do_B
    );
    
    mux_acc_to_ula: mux2x1 port map (
        sel => sel_mux_acc, 
        entr0 => do_A, 
        entr1 => do_B, 
        saida => out_mux_acc
    ); --entre os acumuladores e a ULA
    mux_reg_or_const: mux2x1 port map(
        sel => sel_mux_reg_or_const, 
        entr0 => do_banco_s, 
        entr1 => do_cte, 
        saida => out_mux_reg_or_const
    );

    a_ula: ula port map (
        in_a => out_mux_acc, 
        in_b => out_mux_reg_or_const, 
        sel_op_ula => sel_op_ula, 
        resultado_ula => do_ula_s,
        flag_z => ula_fz,
        flag_v => ula_fv,
        flag_n => ula_fn
    );
    banco: bancoregs port map (
        data_in_banco => di_banco, 
        reg_wr => sel_reg_wr, 
        reg_read_1 => sel_reg_rd, 
        reg_read_2 => "000", 
        rd_1 => do_banco_s, 
        clk_banco => clk_bloco, 
        rst_banco => rst_bloco, 
        wr_en_banco => we_banco
    );

    -- deborgling

    do_accA <= do_A;
    do_accB <= do_B;
    do_ula <= do_ula_s;
    do_banco <= do_banco_s;
    do_acc_input <= di_acc;
    do_banco_input <= di_banco;
    do_ula_input_A <= out_mux_acc;
    do_ula_input_B <= out_mux_reg_or_const;

end architecture;