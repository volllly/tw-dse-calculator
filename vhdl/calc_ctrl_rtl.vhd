library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of calc_ctrl is
    type t_state is (op1, op2, otype, calculate, calculating, display);

    signal s_state: t_state;
    signal s_op1:   std_logic_vector(11 downto 0);
    signal s_op2:   std_logic_vector(11 downto 0);
    signal otype_o: std_logic_vector(3  downto 0);
    
    begin
        procedure f_decode_ss(
            number: in  std_logic_vector(3 downto 0);
            digit:  out std_logic_vector(7 downto 0)
        ) is
        begin
            case number is
                when "0000"=> digit <="00000011";  -- '0'
                when "0001"=> digit <="10011111";  -- '1'
                when "0010"=> digit <="00100101";  -- '2'
                when "0011"=> digit <="00001101";  -- '3'
                when "0100"=> digit <="10011001";  -- '4' 
                when "0101"=> digit <="01001001";  -- '5'
                when "0110"=> digit <="01000001";  -- '6'
                when "0111"=> digit <="00011111";  -- '7'
                when "1000"=> digit <="00000001";  -- '8'
                when "1001"=> digit <="00001001";  -- '9'
                when "1010"=> digit <="00010001";  -- 'A'
                when "1011"=> digit <="11000001";  -- 'B'
                when "1100"=> digit <="11100101";  -- 'C'
                when "1101"=> digit <="10000101";  -- 'D'
                when "1110"=> digit <="01100001";  -- 'E'
                when "1111"=> digit <="01110001";  -- 'F'
            end case;
        end f_decode_ss;

        p_statelogic: process(clk_i, reset_i)
            begin
                if reset_i = '1' then
                    s_state := calculate;
                elsif clk_i = '1' and clk_i'event then
                    case(s_state) is
                        when calculate => s_state <= calculating;
                        when calculating =>
                            if finished_i = '1' then
                                s_state <= display;
                            end if;
                        when display | op1 | op2 | otype =>
                            case(pbsync_i) is                            
                                when "1000" => s_state <= op1;
                                when "0100" => s_state <= op2;
                                when "0010" => s_state <= otype;
                                when "0001" => s_state <= calculate;
                            end case;
                        when others =>
                            s_state <= calculate;
                    end case;
                end if;
        end process;

        identifier: process(clk_i, reset_i)
            begin
                if reset_i = '1' then
                    op1_o :=    (others => '0');
                    s_op1 :=    (others => '0');
                    op2_o :=    (others => '0');
                    s_op2 :=    (others => '0');
                    otype_o :=  (others => '0');
                    s_otype :=  (others => '0');

                    start_o :=  (others => '0');
                    
                    dig0_o :=   (others => '0');
                    dig1_o :=   (others => '0');
                    dig2_o :=   (others => '0');
                    dig3_o :=   (others => '0');
                    led_o <=    (others => '0');
                elsif clk_i = '1' and clk_i'event then
                    led_o <= x"0000";
                    case(s_state) is
                        when calculate =>
                        start_o <= '1';
                            op1_o <= s_op1;
                            op2_o <= s_op2;
                            otype_o <= s_otype;
                        when calculating => start_o <= '0';
                        when display =>
                            led_o <= x"8000";

                            if error_i = '1' then
                                dig3_o <= (others => '0');
                                dig2_o <= "01100001";
                                dig1_o <= "11110101";
                                dig0_o <= "11110101";
                            elsif overflow_i = '1' then
                                dig3_o <= "11000101";
                                dig2_o <= "11000101";
                                dig1_o <= "11000101";
                                dig0_o <= "11000101";
                            else
                                if sign_i <= '1' then
                                    f_decode_ss(result_i(15 downto 12), dig3_o);
                                else
                                    f_decode_ss(result_i(11 downto 8), dig2_o);
                                    f_decode_ss(result_i(7  downto 4), dig1_o);
                                    f_decode_ss(result_i(3  downto 0), dig0_o);
                                end if;
                            end if;
                        when op1 =>
                            dig3_o <= "10011110";
                            f_decode_ss(swsync_i(11 downto 8), dig2_o);
                            f_decode_ss(swsync_i(7  downto 4), dig1_o);
                            f_decode_ss(swsync_i(3  downto 0), dig0_o);
                            s_op1 = swsync_i(11 downto 0);
                        when op2 =>
                            dig3_o <= "00100100";
                            f_decode_ss(swsync_i(11 downto 8), dig2_o);
                            f_decode_ss(swsync_i(7  downto 4), dig1_o);
                            f_decode_ss(swsync_i(3  downto 0), dig0_o);
                            s_op2 = swsync_i(11 downto 0);
                        when otype =>
                            dig3_o <= "11000100";
                            case(swsync_i(15 downto 12)) is
                                when x"1" =>
                                    dig2_o <= "01001001";
                                    dig1_o <= "11000111";
                                    dig0_o <= "11000001";
                                when x"6" =>
                                    dig2_o <= "01001001";
                                    dig1_o <= "11110101";
                                    dig0_o <= "11000101";
                                when x"9" =>
                                    dig2_o <= "00010001";
                                    dig1_o <= "11010101";
                                    dig0_o <= "10000101";
                                when x"C" =>
                                    dig2_o <= "11110101";
                                    dig1_o <= "11000101";
                                    dig0_o <= "11100011";
                                when others =>
                                    dig2_o <= (others => '1');
                                    dig1_o <= (others => '1');
                                    dig0_o <= (others => '1');
                            end case;
                            s_otype = swsync_i(15 downto 12);
                    end case;
                end if;
        end process identifier
end rtl;