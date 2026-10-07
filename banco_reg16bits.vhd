library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg16bits is
   port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        wr_en    : in  std_logic;
        sel_reg_wr : in unsigned(2 downto 0);--indica em qual reg o data_in será escrito
        sel_reg_rd: in unsigned(2 downto 0); -- indica em qual reg o data_out será lido(qual valor de qual reg vai para o data_out?)
        data_in  : in  unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;


architecture a_banco_reg16bits of banco_reg16bits is

   component decoder1x8 is 
        port( 
            sel   : in  unsigned(2 downto 0);
            sinal : in  std_logic;
            saida0, saida1, saida2, saida3, saida4, saida5, saida6, saida7 : out std_logic
        );
    end component;
    
    
   component reg16bits is
      port( 
         clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_in  : in unsigned(15 downto 0);
         data_out : out unsigned(15 downto 0)
   );
   end component;
   signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7 : std_logic;--wr enable de cada reg
   signal data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7 : unsigned(15 downto 0);--saida de cada reg

begin
    
    demux_wr_en: decoder1x8 port map (
        sel    => sel_reg_wr,
        sinal  => wr_en,
        saida0 => wr_en0,
        saida1 => wr_en1,
        saida2 => wr_en2,
        saida3 => wr_en3,
        saida4 => wr_en4,
        saida5 => wr_en5,
        saida6 => wr_en6,
        saida7 => wr_en7
    );
    

    r0: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en0, data_in => data_in, data_out => data_out0);
    r1: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en1, data_in => data_in, data_out => data_out1);
    r2: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en2, data_in => data_in, data_out => data_out2);
    r3: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en3, data_in => data_in, data_out => data_out3);
    r4: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en4, data_in => data_in, data_out => data_out4);
    r5: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en5, data_in => data_in, data_out => data_out5);
    r6: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en6, data_in => data_in, data_out => data_out6);
    r7: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en7, data_in => data_in, data_out => data_out7);

    data_out <= data_out0 when sel_reg_rd = "000" else-- a saída sai do reg0
                data_out1 when sel_reg_rd = "001" else
                data_out2 when sel_reg_rd = "010" else
                data_out3 when sel_reg_rd = "011" else
                data_out4 when sel_reg_rd = "100" else
                data_out5 when sel_reg_rd = "101" else
                data_out6 when sel_reg_rd = "110" else
                data_out7 when sel_reg_rd = "111" else
                (others => '0');
        
end architecture;
