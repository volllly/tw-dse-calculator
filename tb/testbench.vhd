library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
    generic(
        N: natural := 4
    );
end testbench;

architecture sim of testbench is
    component shiftregister
        port(
            d_i:    in  std_logic_vector(N - 1 downto 0);
            en_i:   in  std_logic;
            sh_i:   in  std_logic;
            q_o:    out std_logic_vector(N - 1 downto 0);
            clk:    in  std_logic;
            reset:  in  std_logic
        );
    end component;

    signal d_i:     std_logic_vector(N - 1 downto 0);
    signal en_i:    std_logic;
    signal sh_i:    std_logic;
    signal q_o:     std_logic_vector(N - 1 downto 0);
    signal clk:     std_logic;
    signal reset:   std_logic;

    begin
        i_shiftregister: shiftregister
        port map(
            d_i     => d_i,
            en_i    => en_i,
            sh_i    => sh_i,
            q_o     => q_o,
            clk     => clk,
            reset   => reset
        );
        
        p_clk: process
            begin
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end process;

        p_run: process
            begin
                reset <= '1';
                en_i <= '0';
                sh_i <= '0';
                d_i <= x"7";
                wait for 20 ns;
                reset <= '0';
                wait for 20 ns;
                en_i <= '1';
                wait for 20 ns;
                d_i <= x"A";
                wait for 20 ns;
                d_i <= x"E";
                wait for 20 ns;
                en_i <= '0';
                d_i <= x"1";
                wait for 20 ns;
                en_i <= '1';
                wait for 20 ns;
                sh_i <= '1';
                wait for 60 ns;
                en_i <= '0';
                sh_i <= '1';
                wait for 20 ns;
        end process;
end sim;