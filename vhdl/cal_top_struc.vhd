library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture struc of calc_top is
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
        swsync_o    out std_logic_vector(15 downto 0);
        pbsync_o:   out std_logic_vector(3  downto 0);
    );
    end component;

    component calc_ctrl
        port(
            clk_i:      in  std_logic;
            reset_i:    in  std_logic;
            swsync_i    in  std_logic_vector(15 downto 0);
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
            led_o:      out std_logic_vector(15 downto 0);
        );
    end component;

    component alu
        port(
            clk_i:      in  std_logic;
            reset_i:    in  std_logic;
            op1_i:      in  std_logic_vector(11 downto 0);
            op1_i:      in  std_logic_vector(11 downto 0);
            otype_i:    in  std_logic_vector(3  downto 0);
            start_i:    in  std_logic;
    
            finished_o: out std_logic;
            result_o:   out std_logic_vector(15 downto 0);
            sign_0:     out std_logic;
            overflow_o: out std_logic;
            error_o:    out std_logic;
        );
    end component;
    begin
        i_io_ctrl: io_ctrl
            port map(
                clk_i => clk_i,
                reset_i => reset_i,
            );

        i_calc_ctrl: calc_ctrl
            port map(
                clk_i => clk_i,
                reset_i => reset_i,
            );

        i_alu: alu
            port map(
                clk_i => clk_i,
                reset_i => reset_i,
            );
end struc;