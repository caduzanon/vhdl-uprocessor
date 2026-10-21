library ieee;
use ieee.std_logic_1164.all;

entity maquina_estados is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        estado : out std_logic
    );
end entity maquina_estados;

architecture a_maquina_estados of maquina_estados is
    signal estado_reg : std_logic := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            estado_reg <= '0';
        elsif rising_edge(clk) then
            estado_reg <= not estado_reg;
        end if;
    end process;

    estado <= estado_reg;
end architecture a_maquina_estados;