library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_io_ctrl is

end tb_io_ctrl;

architecture sim of tb_io_ctrl is
    component io_ctrl
        port(
            clk_i:      in  std_logic;
            reset_i:    in  std_logic;
            dig0_i:     in  std_logic_vector(7  downto 0);
            dig1_i:     in  std_logic_vector(7  downto 0);
            dig2_i:     in  std_logic_vector(7  downto 0);
            dig3_i:     in  std_logic_vector(7  downto 0);
            led_i:      in  std_logic_vector(15 downto 0);
            sw_i:       in  std_logic_vector(15 downto 0);
            pb_i:       in  std_logic_vector(3  downto 0);
            
            ss_o:       out std_logic_vector(7  downto 0);
            ss_sel_o:   out std_logic_vector(3  downto 0);
            led_o:      out std_logic_vector(15 downto 0);
            swsync_o:   out std_logic_vector(15 downto 0);
            pbsync_o:   out std_logic_vector(3  downto 0)
        );
    end component;

    signal clk_i:       std_logic;
    signal reset_i:     std_logic;
    signal dig0_i:      std_logic_vector(7  downto 0);
    signal dig1_i:      std_logic_vector(7  downto 0);
    signal dig2_i:      std_logic_vector(7  downto 0);
    signal dig3_i:      std_logic_vector(7  downto 0);
    signal led_i:       std_logic_vector(15 downto 0);
    signal sw_i:        std_logic_vector(15 downto 0);
    signal pb_i:        std_logic_vector(3  downto 0);
    
    signal ss_o:        std_logic_vector(7  downto 0);
    signal ss_sel_o:    std_logic_vector(3  downto 0);
    signal led_o:       std_logic_vector(15 downto 0);
    signal swsync_o:    std_logic_vector(15 downto 0);
    signal pbsync_o:    std_logic_vector(3  downto 0);

    begin
        i_io_ctrl: io_ctrl
        port map(
            clk_i       => clk_i,
            reset_i     => reset_i,
            dig0_i      => dig0_i,
            dig1_i      => dig1_i,
            dig2_i      => dig2_i,
            dig3_i      => dig3_i,
            led_i       => led_i,
            sw_i        => sw_i,
            pb_i        => pb_i,

            ss_o        => ss_o,
            ss_sel_o    => ss_sel_o,
            led_o       => led_o,
            swsync_o    => swsync_o,
            pbsync_o    => pbsync_o
        );
        
        p_clk: process
            begin
                clk_i <= '0';
                wait for 10 ns;
                clk_i <= '1';
                wait for 10 ns;
        end process;

        p_sim: process
            begin
                reset_i <= '1';
                wait for 40 ns;
                reset_i <= '0';
                dig0_i <= x"00";
                dig1_i <= x"00";
                dig2_i <= x"00";
                dig3_i <= x"00";
                wait for 40 ns;
                dig3_i <= x"11";
                wait for 3 ns;
                dig3_i <= x"88";
                wait for 3 ns;
                dig3_i <= x"11";
                wait for 3 ns;
                dig3_i <= x"45";
                wait for 3 ns;
                dig3_i <= x"F3";
                wait for 3 ns;
                dig3_i <= x"55";
                wait for 3 ns;

                assert false report "SIMMULATION_END" severity failure;
    end process;
end sim;