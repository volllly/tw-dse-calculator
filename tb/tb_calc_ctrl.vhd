library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_calc_ctrl is

end tb_calc_ctrl;

architecture sim of tb_calc_ctrl is
    component calc_ctrl
        port(
            clk_i:      in  std_logic;
            reset_i:    in  std_logic;
            swsync_i:   in  std_logic_vector(15 downto 0);
            pbsync_i:   in  std_logic_vector(3  downto 0);
            finished_i: in  std_logic;
            result_i:   in  std_logic_vector(15 downto 0);
            sign_i:     in  std_logic;
            overflow_i: in  std_logic;
            error_i:    in  std_logic;
    
            op1_o:      out std_logic_vector(11 downto 0);
            op2_o:      out std_logic_vector(11 downto 0);
            otype_o:    out std_logic_vector(3  downto 0);
            start_o:    out std_logic;
            dig0_o:     out std_logic_vector(7  downto 0);
            dig1_o:     out std_logic_vector(7  downto 0);
            dig2_o:     out std_logic_vector(7  downto 0);
            dig3_o:     out std_logic_vector(7  downto 0);
            led_o:      out std_logic_vector(15 downto 0)
        );
    end component;

    signal clk_i:       std_logic;
    signal reset_i:     std_logic;
    signal swsync_i:    std_logic_vector(15 downto 0);
    signal pbsync_i:    std_logic_vector(3  downto 0);
    signal finished_i:  std_logic;
    signal result_i:    std_logic_vector(15 downto 0);
    signal sign_i:      std_logic;
    signal overflow_i:  std_logic;
    signal error_i:     std_logic;

    signal op1_o:       std_logic_vector(11 downto 0);
    signal op2_o:       std_logic_vector(11 downto 0);
    signal otype_o:     std_logic_vector(3  downto 0);
    signal start_o:     std_logic;
    signal dig0_o:      std_logic_vector(7  downto 0);
    signal dig1_o:      std_logic_vector(7  downto 0);
    signal dig2_o:      std_logic_vector(7  downto 0);
    signal dig3_o:      std_logic_vector(7  downto 0);
    signal led_o:       std_logic_vector(15 downto 0);

    begin
        i_calc_ctrl: calc_ctrl
            port map(
                clk_i       => clk_i,
                reset_i     => reset_i,
                swsync_i    => swsync_i,
                pbsync_i    => pbsync_i,
                finished_i  => finished_i,
                result_i    => result_i,
                sign_i      => sign_i,
                overflow_i  => overflow_i,
                error_i     => error_i,
                
                op1_o       => op1_o,
                op2_o       => op2_o,
                otype_o     => otype_o,
                start_o     => start_o,
                dig0_o      => dig0_o,
                dig1_o      => dig1_o,
                dig2_o      => dig2_o,
                dig3_o      => dig3_o,
                led_o       => led_o
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
                error_i <= '0';
                overflow_i <= '0';
                sign_i <= '0';
                result_i <= x"0000";
                wait for 12.5 ns;
                reset_i <= '0';
                wait for 20 ns;
                finished_i <= '1';
                wait for 10 ns;
                finished_i <= '0';
                wait for 30 ns;
                pbsync_i <= "1000";
                wait for 30 ns;
                swsync_i <= x"05D7";
                wait for 10 ns;
                pbsync_i <= "1010";
                wait for 20 ns;
                pbsync_i <= "0100";
                wait for 30 ns;
                swsync_i <= x"362F";
                wait for 10 ns;
                swsync_i <= x"53B4";
                wait for 30 ns;
                pbsync_i <= "0010";
                wait for 10 ns;
                pbsync_i <= "0000";
                wait for 20 ns;
                swsync_i <= x"156E";
                wait for 30 ns;
                pbsync_i <= "0001";
                wait for 50 ns;
                pbsync_i <= "0100";
                swsync_i <= x"93F5";
                wait for 40 ns;
                pbsync_i <= "0000";
                finished_i <= '1';
                wait for 10 ns;
                finished_i <= '0';
                wait for 1200 ns;
                pbsync_i <= "0001";
                wait for 30 ns;
                sign_i <= '1';
                finished_i <= '1';
                wait for 10 ns;
                finished_i <= '0';
                wait for 20 ns;
                pbsync_i <= "0001";
                wait for 30 ns;
                overflow_i <= '1';
                finished_i <= '1';
                wait for 10 ns;
                finished_i <= '0';
                wait for 20 ns;
                pbsync_i <= "0001";
                wait for 30 ns;
                pbsync_i <= "0000";
                error_i <= '1';
                finished_i <= '1';
                wait for 10 ns;
                finished_i <= '0';

                wait for 200 ns;
                assert false report "SIMMULATION_END" severity failure;
        end process;
end architecture;