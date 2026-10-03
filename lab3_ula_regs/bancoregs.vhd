library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoregs is
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
end entity;

architecture a_bancoregs of bancoregs is
    component decoder1x8 is 
        port( sel : in unsigned(2 downto 0);
            sinal : in std_logic;
            saida0, saida1, saida2, saida3, saida4, saida5, saida6, saida7 : out std_logic
        );
    end component;
    component reg16b is
        port( clk : in std_logic;
            rst : in std_logic;
            wr_en : in std_logic;
            data_in : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal do_r0, do_r1, do_r2, do_r3, do_r4, do_r5, do_r6, do_r7 : unsigned(15 downto 0);
    signal write_en_decoder_out_0, write_en_decoder_out_1, write_en_decoder_out_2, write_en_decoder_out_3, write_en_decoder_out_4, write_en_decoder_out_5, write_en_decoder_out_6, write_en_decoder_out_7 : std_logic;
begin
    reg0: reg16b port map (clk => clk_banco, data_in => data_in_banco, rst => rst_banco, wr_en => write_en_decoder_out_0, data_out => do_r0);
    reg1: reg16b port map (clk => clk_banco, data_in => data_in_banco, rst => rst_banco, wr_en => write_en_decoder_out_1, data_out => do_r1);
    reg2: reg16b port map (clk => clk_banco, data_in => data_in_banco, rst => rst_banco, wr_en => write_en_decoder_out_2, data_out => do_r2);
    reg3: reg16b port map (clk => clk_banco, data_in => data_in_banco, rst => rst_banco, wr_en => write_en_decoder_out_3, data_out => do_r3);
    reg4: reg16b port map (clk => clk_banco, data_in => data_in_banco, rst => rst_banco, wr_en => write_en_decoder_out_4, data_out => do_r4);
    reg5: reg16b port map (clk => clk_banco, data_in => data_in_banco, rst => rst_banco, wr_en => write_en_decoder_out_5, data_out => do_r5);
    reg6: reg16b port map (clk => clk_banco, data_in => data_in_banco, rst => rst_banco, wr_en => write_en_decoder_out_6, data_out => do_r6);
    reg7: reg16b port map (clk => clk_banco, data_in => data_in_banco, rst => rst_banco, wr_en => write_en_decoder_out_7, data_out => do_r7);

    decode_we: decoder1x8 port map (
        sel => reg_wr, 
        sinal => wr_en_banco, 
        saida0 => write_en_decoder_out_0, 
        saida1 => write_en_decoder_out_1, 
        saida2 => write_en_decoder_out_2,
        saida3 => write_en_decoder_out_3,
        saida4 => write_en_decoder_out_4,
        saida5 => write_en_decoder_out_5,
        saida6 => write_en_decoder_out_6,
        saida7 => write_en_decoder_out_7
    );

    rd_1 <= do_r0   when reg_read_1 = "000" else
            do_r1   when reg_read_1 = "001" else
            do_r2   when reg_read_1 = "010" else
            do_r3   when reg_read_1 = "011" else
            do_r4   when reg_read_1 = "100" else
            do_r5   when reg_read_1 = "101" else
            do_r6   when reg_read_1 = "110" else
            do_r7   when reg_read_1 = "111"
                    else "0000000000000000";
    
    
    rd_2 <= do_r0   when reg_read_2 = "000" else
            do_r1   when reg_read_2 = "001" else
            do_r2   when reg_read_2 = "010" else
            do_r3   when reg_read_2 = "011" else
            do_r4   when reg_read_2 = "100" else
            do_r5   when reg_read_2 = "101" else
            do_r6   when reg_read_2 = "110" else
            do_r7   when reg_read_2 = "111"
                    else "0000000000000000";

end architecture;