library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_rom_estados_uc is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        pc_out     : out unsigned(6 downto 0);
        instrucao  : out unsigned(16 downto 0);
        estado : out std_logic
    );
end entity pc_rom_estados_uc;

architecture a_pc_rom_estados_uc of pc_rom_estados_uc is
    component pc is
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            data_in  : in  unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    component rom is
        port (
            endereco : in  unsigned(6 downto 0);
            dado     : out unsigned(16 downto 0)
        );
    end component;

    component reg_instrucao is
        port(   
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(16 downto 0);
            data_out : out unsigned(16 downto 0)
        );
    end component;

    component maquina_estados is
        port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            estado : out std_logic
        );
    end component;

    component un_controle is
        port (     
            estado      :   in std_logic;
            instr       :   in  unsigned(16 downto 0);
            pc_in       :   in  unsigned(6 downto 0);
            pc_out      :   out unsigned(6 downto 0);
            pc_we       :   out std_logic;
            inst_reg_we :   out std_logic
        );
    end component;

    signal estado_s         : std_logic;
    signal pc_atual_s       : unsigned(6 downto 0);
    signal pc_update_s      : unsigned(6 downto 0);
    signal pc_we_s          : std_logic;
    signal reg_inst_we_s    : std_logic;
    signal dado_rom_s       : unsigned(16 downto 0);
    signal dado_reg_inst_s  : unsigned(16 downto 0);

begin
    maq_est: maquina_estados port map (
        clk    => clk,
        rst    => rst,
        estado => estado_s
    );

    o_pc: pc port map (
        clk      => clk,
        rst      => rst,
        wr_en    => pc_we_s,
        data_in  => pc_update_s,
        data_out => pc_atual_s
    );

    a_rom: rom port map (
        endereco => pc_atual_s,
        dado     => dado_rom_s
    );

    reg_inst: reg_instrucao port map (
        clk      => clk,
        rst      => rst,
        wr_en    => reg_inst_we_s,
        data_in  => dado_rom_s,
        data_out => dado_reg_inst_s
    );

    un_ctl: un_controle port map (
        estado      => estado_s,
        instr       => dado_reg_inst_s,
        pc_in       => pc_atual_s,
        pc_out      => pc_update_s,
        pc_we       => pc_we_s,
        inst_reg_we => reg_inst_we_s
    );

    pc_out     <= pc_atual_s;
    instrucao  <= dado_reg_inst_s;
    estado <= estado_s;

end architecture;