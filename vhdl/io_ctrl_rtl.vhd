library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of io_ctrl is
    signal s_ss_sel_o: std_logic_vector(3 downto 0);
    signal s_int_clk: std_logic;

    begin
        b_int_clk: block
            constant c_ss_f: integer := 10;
            begin
                p_int_clk: process(reset_i, clk_i)
                    variable v_ss_f: integer := 0;
                    begin
                        if reset_i = '1' then
                            v_ss_f := 0;
                        elsif clk_i = '1' and clk_i'event then
                            v_ss_f := v_ss_f + 1;
                            if v_ss_f < c_ss_f / 2 then
                                s_int_clk <= '0';
                            else
                                s_int_clk <= '1';
                            end if;
                            if v_ss_f >= c_ss_f then
                                v_ss_f := 0;
                            end if;
                        end if;
                end process p_int_clk;
        end block b_int_clk;

        b_ss: block
            begin
            p_ss_sel: process(reset_i, s_int_clk)
                begin
                    if reset_i = '1' then
                        s_ss_sel_o <= "1000";
                    elsif s_int_clk = '1' and s_int_clk'event then
                        s_ss_sel_o <= s_ss_sel_o(0)&s_ss_sel_o(3 downto 1);
                    end if;
            end process p_ss_sel;

            ss_sel_o <= s_ss_sel_o;
            with s_ss_sel_o select ss_o <= 
                dig0_i when "0001",
                dig1_i when "0010",
                dig2_i when "0100",
                dig3_i when "1000",
                (others => '0') when others;
        end block b_ss;

        b_led: block
            begin
                with reset_i select led_o <= 
                    led_i when '0',
                    x"0000" when others;
        end block b_led;

        b_i_sync: block
            signal s_swsync_db: std_logic_vector(15 downto 0);
            signal s_pbsync_db: std_logic_vector(3 downto 0);
            begin
                p_swsync: process(reset_i, s_int_clk)
                    begin
                        if reset_i = '1' then
                            s_swsync_db <= (others => '0');
                            swsync_o <= (others => '0');
                        elsif s_int_clk = '1' and s_int_clk'event then
                            s_swsync_db <= sw_i;
                            swsync_o <= sw_i and s_swsync_db;
                        end if;
                end process p_swsync;

                p_pbsync: process(reset_i, s_int_clk)
                begin
                    if reset_i = '1' then
                        s_pbsync_db <= (others => '0');
                        pbsync_o <= (others => '0');
                    elsif s_int_clk = '1' and s_int_clk'event then
                        s_pbsync_db <= pb_i;
                        pbsync_o <= pb_i and s_pbsync_db;
                    end if;
            end process p_pbsync;
        end block b_i_sync;
end rtl;