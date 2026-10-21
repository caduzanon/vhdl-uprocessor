library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_instrucao is
   port( clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_in  : in unsigned(16 downto 0);
         data_out : out unsigned(16 downto 0)
   );
end entity;

architecture a_reg_instrucao of reg_instrucao is
      signal registro: unsigned(16 downto 0);
      begin
           process(clk,rst) -- acionado se houver mudança em clk ou rst
           begin
                  if rst='1' then--if then apenas para criar registrador. sempre deve ter clock, clock enable ou reset
                        registro <= "00000000000000000";
                  elsif falling_edge(clk) then
                        if wr_en='1' then
                              registro <= data_in;
                        end if;
                  end if;
            end process;
            data_out <= registro;
end architecture a_reg_instrucao;