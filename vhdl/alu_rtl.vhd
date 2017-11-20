library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of alu is
    signal s_calculating: std_logic;
    signal s_finished: std_logic;
    signal s_otype: std_logic_vector(3 downto 0);
    begin
        b_calculating: block
            begin
                p_calculating: process(reset_i, clk_i)
                    begin
                        if reset_i = '1' then
                            s_finished <= 'Z';
                            s_calculating <= 'Z';
                        elsif clk_i = '1' and clk_i'event then
                            if start_i = '1' then
                                s_calculating <= '1';
                                s_otype <= otype_i;
                            end if;
                            if s_finished = '1' then
                                s_calculating <= '0';
                                s_finished <= '0';
                            end if;
                        end if;                        
                end process p_calculating;

                finished_o <= s_finished;
        end block b_calculating;

        b_mux: block
            begin
        end block b_mux;

end rtl;