library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity;

architecture a_ula_tb of ula_tb is
    component ula is
        port (
            in_a          : in  unsigned(15 downto 0);
            in_b          : in  unsigned(15 downto 0);
            resultado_ula : out unsigned(15 downto 0);
            sel_op_ula    : in  unsigned(1 downto 0);
            flag_z        : out std_logic;
            flag_v        : out std_logic
        );
    end component;

   
    signal in_a, in_b    : unsigned(15 downto 0);
    signal resultado_ula : unsigned(15 downto 0);
    signal sel_op_ula    : unsigned(1 downto 0);
    signal flag_z, flag_v : std_logic;
begin
    uut: ula port map (
        in_a          => in_a,
        in_b          => in_b,
        resultado_ula => resultado_ula,
        sel_op_ula    => sel_op_ula,
        flag_z        => flag_z,
        flag_v        => flag_v
    );

    process
    begin
        sel_op_ula <= "00";
        in_a <= "0000000000001111";
        in_b <= "0000000000011001";
        wait for 50 ns;

        in_a <= "1111111111110110";
        in_b <= "1111111111111011";
        wait for 50 ns;

        in_a <= "0000000000110010";
        in_b <= "1111111111101100";
        wait for 50 ns;

        in_a <= "0100111000100000";
        in_b <= "0100111000100000";
        wait for 50 ns;

        in_a <= "1011000111100000";
        in_b <= "1011000111100000";
        wait for 50 ns;

        in_a <= "1111111111111111";
        in_b <= "0000000000000001";
        wait for 50 ns;

        sel_op_ula <= "01";

        in_a <= "0000000000110010";
        in_b <= "0000000000010100";
        wait for 50 ns;

        in_a <= "0000000000001010";
        in_b <= "0000000000011110";
        wait for 50 ns;

        in_a <= "1111111111110110";
        in_b <= "1111111111110001";
        wait for 50 ns;

        in_a <= "0110000110101000";
        in_b <= "1100010101101000";
        wait for 50 ns;

        in_a <= "1001111001011000";
        in_b <= "0011101010011000";
        wait for 50 ns;

        sel_op_ula <= "10";

        in_a <= "0000000001100100";
        in_b <= "0000000000011001";
        wait for 50 ns;

        in_a <= "0000000000011001";
        in_b <= "0000000001100100";
        wait for 50 ns;

        in_a <= "0000000000110010";
        in_b <= "0000000000110010";
        wait for 50 ns;

        sel_op_ula <= "11";

        in_a <= "0000000000001111";
        in_b <= (others => '0');
        wait for 50 ns;

        in_a <= "0100000000000000";
        in_b <= (others => '0');
        wait for 50 ns;

        wait;
    end process;
end architecture;
