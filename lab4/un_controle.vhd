library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
    port (     
        estado      :   in std_logic;
        instr       :   in  unsigned(16 downto 0);
        pc_in       :   in  unsigned(6 downto 0);
        pc_out      :   out unsigned(6 downto 0);
        pc_we       :   out std_logic;
        inst_reg_we :   out std_logic
    );
end entity un_controle;

architecture a_un_controle of un_controle is
    signal opcode   :   unsigned(3 downto 0);
    signal delta    :   unsigned(6 downto 0);
    signal jump_en  :   std_logic;
begin
    opcode  <= instr(16 downto 13);     --4 bits para opcode
    delta   <= instr(6 downto 0);       --7 bits para o desloc. relativo (comp. 2)

    jump_en <= '1' when opcode = "1111" else '0';
    pc_we   <= '1' when estado = '1' else '0';
    pc_out <= (pc_in + delta) when jump_en = '1' else (pc_in + 1); --faz salto relativo ou incremento
    
    inst_reg_we <= '1' when estado = '0' else '0';
end architecture a_un_controle;