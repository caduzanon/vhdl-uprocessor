library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_bancoReg_acc is
    port(
        clk             : in  std_logic;
        rst             : in  std_logic;

        we_banco        : in  std_logic;
        we_accA         : in  std_logic;
        we_accB         : in  std_logic;

        sel_reg_wr      : in  unsigned(2 downto 0);
        sel_reg_rd      : in  unsigned(2 downto 0);

        sel_mux_acc_in  : in  unsigned(1 downto 0); -- ula->00, banco(Mov Acc, Rn)->01, LD(acc, const)->10 
        sel_mux_banco_in: in  unsigned(1 downto 0); -- AccA(Mov Rn, AccA) -> 00,  AccB(Mov Rn, AccB) -> 01, LD(Rn, const)->10
        sel_mux_acc_ula : in  std_logic;            -- AccA->0, AccB -> 1
        sel_mux_b_ula   : in  std_logic;            -- vem do banco -> 0, vem das constantes -> 1

        sel_op_ula      : in  unsigned(1 downto 0); -- 00 soma, 01 sub, 10 cmp, 11 lsl

        const_in        : in  unsigned(15 downto 0); -- entrada de constante externa

        flag_z, flag_v, flag_n : out std_logic; -- flags ula

        out_accA, out_accB, out_ula, out_banco : out unsigned(15 downto 0)--debug
    );
end entity;

architecture a_ula_bancoReg_acc of ula_bancoReg_acc is

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

    component acumulador is
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            data_in  : in  unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component ula is
        port (
            in_a          : in  unsigned(15 downto 0);
            in_b          : in  unsigned(15 downto 0);
            sel_op_ula    : in  unsigned(1 downto 0);
            resultado_ula : out unsigned(15 downto 0);
            flag_z        : out std_logic;
            flag_v        : out std_logic;
            flag_n        : out std_logic
        );
    end component;

    signal data_in_acc    : unsigned(15 downto 0);
    signal data_in_banco  : unsigned(15 downto 0);
    signal data_out_accA  : unsigned(15 downto 0);
    signal data_out_accB  : unsigned(15 downto 0);
    signal data_out_banco : unsigned(15 downto 0);
    signal data_out_ula   : unsigned(15 downto 0);
    signal ula_in_a       : unsigned(15 downto 0);
    signal ula_in_b       : unsigned(15 downto 0);

begin
   -- mux 4:1 entrada dos acumuladores 
    data_in_acc <= data_out_ula   when sel_mux_acc_in = "00" else -- ula
                   data_out_banco when sel_mux_acc_in = "01" else -- banco (MOV Acc, Rn)
                   const_in       when sel_mux_acc_in = "10" else -- constante (LD Acc, const)
                   (others => '0');

    -- mux 4:1 entrada do banco 
    data_in_banco <= data_out_accA when sel_mux_banco_in = "00" else -- AccA (MOV Rn, AccA)
                     data_out_accB when sel_mux_banco_in = "01" else -- AccB (MOV Rn, AccB)
                     const_in      when sel_mux_banco_in = "10" else -- constante (LD Rn, const)
                     (others => '0');

    -- mux 2:1 entrada A da ula 
    ula_in_a <= data_out_accA when sel_mux_acc_ula = '0' else data_out_accB; -- AccA->0, AccB->1

    -- mux 2:1 entrada B da ula 
    ula_in_b <= data_out_banco when sel_mux_b_ula = '0' else const_in; -- banco->0, constante->1

    acc_A: acumulador port map ( -- acumulador accA
        clk      => clk,
        rst      => rst,
        wr_en    => we_accA,
        data_in  => data_in_acc,
        data_out => data_out_accA
    );

    acc_B: acumulador port map (  -- acumulador accB
        clk      => clk,
        rst      => rst,
        wr_en    => we_accB,
        data_in  => data_in_acc,
        data_out => data_out_accB
    );

    banco: banco_reg16bits port map (
        clk        => clk,
        rst        => rst,
        wr_en      => we_banco,
        sel_reg_wr => sel_reg_wr,
        sel_reg_rd => sel_reg_rd,
        data_in    => data_in_banco,
        data_out   => data_out_banco
    );

    ulaa: ula port map (
        in_a          => ula_in_a,
        in_b          => ula_in_b,
        sel_op_ula    => sel_op_ula,
        resultado_ula => data_out_ula,
        flag_z        => flag_z,
        flag_v        => flag_v,
        flag_n        => flag_n
    );

    -- saidas para debug
    out_accA  <= data_out_accA;
    out_accB  <= data_out_accB;
    out_banco <= data_out_banco;
    out_ula   <= data_out_ula;
end architecture;