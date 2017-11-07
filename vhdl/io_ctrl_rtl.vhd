library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of io_ctrl is
    signal s_ss_sel_o: std_logic_vector(3 downto 0);

    begin
        b_ss: block
            begin
            p_ss_sel: process(reset_i, clk_i)
                variable v_ss_f: std_logic_vector(2 downto 0) := "000";
                begin
                    if reset_i = '1' then
                        v_ss_f := "000";
                        s_ss_sel_o <= "1000";
                    elsif clk_i = '1' and clk_i'event then
                        v_ss_f := std_logic_vector(unsigned(v_ss_f) + 1);
                        if v_ss_f = "000" then
                            if s_ss_sel_o = "0001" then
                                s_ss_sel_o <= "1000";
                            else
                                s_ss_sel_o <= '0'&s_ss_sel_o(3 downto 1);
                            end if;
                        end if;
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
end rtl;