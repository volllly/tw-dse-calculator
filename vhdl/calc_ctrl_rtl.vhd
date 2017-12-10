library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of calc_ctrl is
    type t_state is (op1, op2, otype, calculate, calculating, display); 
        -- states:
        --      op1:            inputing operand 1
        --      op2:            inputing operand 2
        --      otype:          inputing operation
        --      calculate:      calculation starting
        --      calculating:    calculation running
        --      display:        displaying result

    signal s_state: t_state;                                -- state vector
    signal s_op1:   std_logic_vector(11 downto 0);
    signal s_op2:   std_logic_vector(11 downto 0);
    signal s_otype: std_logic_vector(3  downto 0);
    
    procedure f_decode_ss(                                  -- decoding procedure for 7 segment display
        signal number: in  std_logic_vector(3 downto 0);    -- the number to display on
        signal digit:  out std_logic_vector(7 downto 0)     -- this 7 segment display
    ) is
    begin
        case number is                          -- outputs the given number on the given digit
            when "0000"=>  digit <="00000011";  -- '0'
            when "0001"=>  digit <="10011111";  -- '1'
            when "0010"=>  digit <="00100101";  -- '2'
            when "0011"=>  digit <="00001101";  -- '3'
            when "0100"=>  digit <="10011001";  -- '4' 
            when "0101"=>  digit <="01001001";  -- '5'
            when "0110"=>  digit <="01000001";  -- '6'
            when "0111"=>  digit <="00011111";  -- '7'
            when "1000"=>  digit <="00000001";  -- '8'
            when "1001"=>  digit <="00001001";  -- '9'
            when "1010"=>  digit <="00010001";  -- 'A'
            when "1011"=>  digit <="11000001";  -- 'b'
            when "1100"=>  digit <="11100101";  -- 'C'
            when "1101"=>  digit <="10000101";  -- 'd'
            when "1110"=>  digit <="01100001";  -- 'E'
            when "1111"=>  digit <="01110001";  -- 'F'
            when others => digit <="11111111";  -- ' '
        end case;
    end procedure;

    begin
        p_statelogic: process(clk_i, reset_i)                       -- process for managing the state vector
            begin
                if reset_i = '1' then
                    s_state <= calculate;
                elsif clk_i = '1' and clk_i'event then
                    case(s_state) is
                        when calculate => s_state <= calculating;   -- start calculation
                        when calculating =>       
                            if finished_i = '1' then
                                s_state <= display;                 -- when finished display result
                            end if;
                        when display =>
                            case(pbsync_i) is                       -- input values
                                when "0001" => s_state <= op1;
                                when "0010" => s_state <= op2;
                                when "0100" => s_state <= otype;
                                when others =>
                            end case;
                        when op1 | op2 | otype =>
                            case(pbsync_i) is                       -- input values and start calculation  
                                when "0001" => s_state <= op1;
                                when "0010" => s_state <= op2;
                                when "0100" => s_state <= otype;
                                when "1000" => s_state <= calculate;
                                when others =>
                            end case;
                        when others =>
                            s_state <= calculate;
                    end case;
                end if;
        end process;

        p_outputlogic: process(clk_i, reset_i)              -- process for managing the outputs
            begin
                if reset_i = '1' then
                    op1_o       <= (others => '0');
                    s_op1       <= (others => '0');
                    op2_o       <= (others => '0');
                    s_op2       <= (others => '0');
                    otype_o     <= (others => '0');
                    s_otype     <= x"1";

                    start_o     <= '0';
                    
                    dig0_o      <= (others => '1');
                    dig1_o      <= (others => '1');
                    dig2_o      <= (others => '1');
                    dig3_o      <= (others => '1');
                    led_o       <= (others => '0');
                elsif clk_i = '1' and clk_i'event then
                    led_o <= x"0000";
                    case(s_state) is
                        when calculate =>                       -- on claulation start
                            start_o <= '1';                     -- set start signal for alu and
                            op1_o <= s_op1;                     -- output operands and operation type to alu
                            op2_o <= s_op2;
                            otype_o <= s_otype;
                        when calculating => start_o <= '0';     -- while calculating disable start signal for alu
                        when display =>                         -- when displaying
                            led_o <= x"8000";                   -- enable led

                            if error_i = '1' then               -- display error
                                dig3_o <= (others => '1');
                                dig2_o <= "01100001";
                                dig1_o <= "11110101";
                                dig0_o <= "11110101";
                            elsif overflow_i = '1' then         -- display overflow
                                dig3_o <= "11000101";
                                dig2_o <= "11000101";
                                dig1_o <= "11000101";
                                dig0_o <= "11000101";
                            else                                -- display result
                                if sign_i = '1' then            -- display sign
                                    dig3_o <= "11111101";
                                else                            -- or msb
                                    f_decode_ss(result_i(15 downto 12), dig3_o);
                                end if;
                                f_decode_ss(result_i(11 downto 8), dig2_o);
                                f_decode_ss(result_i(7  downto 4), dig1_o);
                                f_decode_ss(result_i(3  downto 0), dig0_o);
                            end if;
                        when op1 =>
                            dig3_o <= "10011110";                       -- display op1 indicator and current operand
                            f_decode_ss(swsync_i(11 downto 8), dig2_o);
                            f_decode_ss(swsync_i(7  downto 4), dig1_o);
                            f_decode_ss(swsync_i(3  downto 0), dig0_o);
                            s_op1 <= swsync_i(11 downto 0);             -- and save current operand
                        when op2 =>                                     -- same as above
                            dig3_o <= "00100100";
                            f_decode_ss(swsync_i(11 downto 8), dig2_o);
                            f_decode_ss(swsync_i(7  downto 4), dig1_o);
                            f_decode_ss(swsync_i(3  downto 0), dig0_o);
                            s_op2 <= swsync_i(11 downto 0);
                        when otype =>
                            dig3_o <= "11000100";                       -- display optype indicator and current operation type
                            case(swsync_i(15 downto 12)) is
                                when x"0" => -- Add
                                    dig2_o <= "00010001";
                                    dig1_o <= "10000101";
                                    dig0_o <= "10000101";
                                when x"1" => -- Sub
                                    dig2_o <= "01001001";
                                    dig1_o <= "11000111";
                                    dig0_o <= "11000001";
                                when x"2" => -- X  
                                    dig2_o <= "10010001";
                                    dig1_o <= "11111111";
                                    dig0_o <= "11111111";
                                when x"3" => -- di 
                                    dig2_o <= "10000101";
                                    dig1_o <= "10011111";
                                    dig0_o <= "11111111";
                                when x"4" => -- rE 
                                    dig2_o <= "11110101";
                                    dig1_o <= "01100001";
                                    dig0_o <= "11111111";
                                when x"5" => -- Sqr
                                    dig2_o <= "01001001";
                                    dig1_o <= "00011001";
                                    dig0_o <= "11110101";
                                when x"6" => -- Sro
                                    dig2_o <= "01001001";
                                    dig1_o <= "11110101";
                                    dig0_o <= "11000101";
                                when x"7" => -- Lb 
                                    dig2_o <= "11100011";
                                    dig1_o <= "11000001";
                                    dig0_o <= "11111111";
                                when x"8" => -- no 
                                    dig2_o <= "11010101";
                                    dig1_o <= "11000101";
                                    dig0_o <= "11111111";
                                when x"9" => -- And
                                    dig2_o <= "00010001";
                                    dig1_o <= "11010101";
                                    dig0_o <= "10000101";
                                when x"A" => -- or
                                    dig2_o <= "11000101";
                                    dig1_o <= "11110101";
                                    dig0_o <= "11111111";
                                when x"B" => -- Eor
                                    dig2_o <= "01100001";
                                    dig1_o <= "11000101";
                                    dig0_o <= "11110101";
                                when x"C" => -- roL
                                    dig2_o <= "11110101";
                                    dig1_o <= "11000101";
                                    dig0_o <= "11100011";
                                when x"D" => -- ror
                                    dig2_o <= "11110101";
                                    dig1_o <= "11000101";
                                    dig0_o <= "11110101";
                                when others =>
                                    dig2_o <= (others => '1');
                                    dig1_o <= (others => '1');
                                    dig0_o <= (others => '1');
                            end case;
                            s_otype <= swsync_i(15 downto 12);          -- save current operation type
                        when others =>
                    end case;
                end if;
        end process;
end architecture;