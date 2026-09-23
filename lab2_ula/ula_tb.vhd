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

        in_a <= to_unsigned(15, 16);
        in_b <= to_unsigned(25, 16);
        wait for 50 ns;

        in_a <= unsigned(to_signed(-10, 16));
        in_b <= unsigned(to_signed(-5, 16));
        wait for 50 ns;

        in_a <= to_unsigned(50, 16);
        in_b <= unsigned(to_signed(-20, 16));
        wait for 50 ns;

        in_a <= to_unsigned(20000, 16);
        in_b <= to_unsigned(20000, 16);
        wait for 50 ns;

        in_a <= unsigned(to_signed(-20000, 16));
        in_b <= unsigned(to_signed(-20000, 16));
        wait for 50 ns;

        in_a <= x"FFFF";
        in_b <= x"0001";
        wait for 50 ns;

        sel_op_ula <= "01";

        in_a <= to_unsigned(50, 16);
        in_b <= to_unsigned(20, 16);
        wait for 50 ns;

        in_a <= to_unsigned(10, 16);
        in_b <= to_unsigned(30, 16);
        wait for 50 ns;

        in_a <= unsigned(to_signed(-10, 16));
        in_b <= unsigned(to_signed(-15, 16));
        wait for 50 ns;

        in_a <= to_unsigned(25000, 16);
        in_b <= unsigned(to_signed(-15000, 16));
        wait for 50 ns;

        in_a <= unsigned(to_signed(-25000, 16));
        in_b <= to_unsigned(15000, 16);
        wait for 50 ns;

        sel_op_ula <= "10";

        in_a <= to_unsigned(100, 16);
        in_b <= to_unsigned(25, 16);
        wait for 50 ns;

        in_a <= to_unsigned(25, 16);
        in_b <= to_unsigned(100, 16);
        wait for 50 ns;

        in_a <= to_unsigned(50, 16);
        in_b <= to_unsigned(50, 16);
        wait for 50 ns;

        sel_op_ula <= "11";

        in_a <= x"000F";
        in_b <= (others => '0');
        wait for 50 ns;

        in_a <= x"4000";
        in_b <= (others => '0');
        wait for 50 ns;

        wait;
    end process;
end architecture;