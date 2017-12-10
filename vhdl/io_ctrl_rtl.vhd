library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of io_ctrl is
    signal s_ss_sel_o: std_logic_vector(3 downto 0);
    signal s_int_clk_enable: std_logic;                 -- 1KHz clock enable signal for debounce and 7 segment selection

    begin
        b_int_clk: block                                -- generation of s_int_clk_enable
            constant c_ss_f: integer := 100000;         -- system clock divisor
            begin
                p_int_clk: process(reset_i, clk_i)
                    variable v_ss_f: integer := 0;
                    begin
                        if reset_i = '1' then
                            v_ss_f := 0;
                        elsif clk_i = '1' and clk_i'event then
                            v_ss_f := v_ss_f + 1;               -- counts systemclocks
                            if v_ss_f = c_ss_f then             -- and enables s_int_clk_enable every 100000th tick
                                s_int_clk_enable <= '1';
                                v_ss_f := 0;
                            else
                                s_int_clk_enable <= '0';        -- for one tick
                            end if;
                        end if;
                end process;
        end block;

        b_ss: block                                 -- 7 segment display digit selection
            begin
            p_ss_sel: process(reset_i, clk_i)
                begin
                    if reset_i = '1' then
                        s_ss_sel_o <= "0111";                                           -- start with one led selected and
                    elsif s_int_clk_enable = '1' and clk_i = '1' and clk_i'event then   -- every 100000th clock tick (1KHz)
                        s_ss_sel_o <= s_ss_sel_o(0)&s_ss_sel_o(3 downto 1);             -- rotate the 7 segment select register
                    end if;
            end process;
            
            with s_ss_sel_o select ss_o <= -- output selected digit to 7 segment display
                dig0_i when "1110",
                dig1_i when "1101",
                dig2_i when "1011",
                dig3_i when "0111",
                (others => '1') when others;
            
            ss_sel_o <= s_ss_sel_o;
        end block;

        b_led: block                        -- connect led in to led out
            begin
                with reset_i select led_o <= 
                    led_i when '0',
                    x"0000" when others;
        end block;

        b_i_sync: block                                         -- debouncing and sync logic for pb and sw
            signal s_swsync_db: std_logic_vector(15 downto 0);  -- last state of switchbuttons
            signal s_pbsync_db: std_logic_vector(3 downto 0);   -- last state of pushbuttons
            begin
                p_swsync: process(reset_i, clk_i)               -- debounce switchbuttons
                    begin
                        if reset_i = '1' then
                            s_swsync_db <= (others => '0');
                            swsync_o <= (others => '0');
                        elsif s_int_clk_enable = '1'  and clk_i = '1' and clk_i'event then  -- with 1KHz
                            s_swsync_db <= sw_i;                                            -- save the current state  
                            swsync_o <= sw_i and s_swsync_db;                               -- and if the last state of one button equals the current state of the same button output that state
                        end if;
                end process;

                p_pbsync: process(reset_i, clk_i)               -- debounce switchbuttons (same principle as above)
                begin
                    if reset_i = '1' then
                        s_pbsync_db <= (others => '0');
                        pbsync_o <= (others => '0');
                    elsif s_int_clk_enable = '1'  and clk_i = '1' and clk_i'event then
                        s_pbsync_db <= pb_i;
                        pbsync_o <= pb_i and s_pbsync_db;
                    end if;
            end process;
        end block;
end architecture;