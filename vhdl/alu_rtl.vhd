library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of alu is
    type t_state is (idle, calculating);

    signal s_state:     t_state;
    signal s_finished:  std_logic;
    signal s_sign:      std_logic;
    signal s_overflow:  std_logic;
    signal s_error:      std_logic;
    signal s_result:    std_logic_vector(15 downto 0);
    begin
        p_statelogic: process(clk_i, reset_i)
        begin
            if reset_i = '1' then
                s_state <= idle;
            elsif clk_i = '1' and clk_i'event then
                case(s_state) is
                    when idle => 
                        if start_i = '1' then
                            s_state <= calculating;
                        end if;
                    when calculating =>
                        if s_finished = '1' then
                            s_state <= idle;
                        end if;
                    when others =>
                        s_state <= idle;
                end case;
            end if;
    end process;

    p_outputlogic: process(clk_i, reset_i)
        begin
            if reset_i = '1' then
                s_finished  <= '0';
                s_result    <= (others => '0');
                s_sign      <= '0';
                s_overflow  <= '0';
                s_error     <= '0';
            elsif clk_i = '1' and clk_i'event then
                case(s_state) is
                    when idle =>
                        s_finished <= '0';
                    when calculating =>
                        if s_finished = '1' then
                            s_finished <= '0';
                        else
                            s_overflow <= '0';
                            s_error <= '0';
                            s_sign <= '0';
                            case(otype_i) is
                                when x"1" => -- Sub
                                    if unsigned(op1_i) >= unsigned(op2_i) then
                                        s_sign <= '0';
                                        s_result <= x"0"&std_logic_vector(unsigned(op1_i) - unsigned(op2_i));
                                    else
                                        s_sign <= '1';
                                        s_result <= x"0"&std_logic_vector(unsigned(op2_i) - unsigned(op1_i));
                                    end if;
                                    s_finished <= '1';
                                when x"6" => -- Sro
                                    s_finished <= '1';
                                when x"9" => -- And
                                    s_result <= x"0"&(op1_i and op2_i);
                                    s_finished <= '1';
                                when x"C" => -- Rol
                                    s_result <= x"0"&op1_i(10 downto 0)&op1_i(11);
                                    s_finished <= '1';
                                when others =>
                                    s_error <= '1';
                                    s_finished <= '1';
                            end case;
                        end if;
                    when others =>
                end case;
            end if;
    end process;
    result_o   <= s_result;
    sign_o     <= s_sign;
    error_o    <= s_error;
    overflow_o <= s_overflow;
    finished_o <= s_finished;
end architecture;