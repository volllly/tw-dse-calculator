library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_calc_top is

end tb_calc_top;

architecture sim of tb_calc_top is
    component calc_top
        port(
            clk_i:    in  std_logic;
            reset_i:  in  std_logic;
            sw_i:     in  std_logic_vector(15 downto 0);
            pb_i:     in  std_logic_vector(3  downto 0);
            
            ss_o:     out std_logic_vector(7  downto 0);
            ss_sel_o: out std_logic_vector(3  downto 0);
            led_o:    out std_logic_vector(15 downto 0)
        );
    end component;

    signal clk_i:    std_logic;
    signal reset_i:  std_logic;
    signal sw_i:     std_logic_vector(15 downto 0);
    signal pb_i:     std_logic_vector(3  downto 0);

    signal ss_o:     std_logic_vector(7  downto 0);
    signal ss_sel_o: std_logic_vector(3  downto 0);
    signal led_o:    std_logic_vector(15 downto 0);

    begin
        i_calc_top: calc_top
            port map(
                clk_i    => clk_i,
                reset_i  => reset_i,
                sw_i     => sw_i,
                pb_i     => pb_i,

                ss_o     => ss_o,
                ss_sel_o => ss_sel_o,
                led_o    => led_o
            );
        
        p_clk: process
            begin
                clk_i <= '0';
                wait for 5 ns;
                clk_i <= '1';
                wait for 5 ns;
        end process;

        p_sim: process
            begin
                reset_i <= '1';
                wait for 30 ns;
                reset_i <= '0';
                sw_i <= x"0000";
                pb_i <= x"0";
                wait for 40 ns;
                pb_i <= x"1";
                sw_i <= x"089A";
                wait for 6 ms;
                pb_i <= x"2";
                sw_i <= x"0B65";
                wait for 6 ms;
                pb_i <= x"4";
                sw_i <= x"1000";
                wait for 6 ms;
                pb_i <= x"8";
                wait for 6 ms;
                pb_i <= x"0";
                wait for 10 ms;
                assert false report "SIMMULATION_END" severity failure;
        end process;
end architecture;