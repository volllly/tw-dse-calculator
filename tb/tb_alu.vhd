library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_alu is

end tb_alu;

architecture sim of tb_alu is
    component alu
    port(
        clk_i:      in  std_logic;
        reset_i:    in  std_logic;
        op1_i:      in  std_logic_vector(11 downto 0);
        op2_i:      in  std_logic_vector(11 downto 0);
        otype_i:    in  std_logic_vector(3  downto 0);
        start_i:    in  std_logic;

        finished_o: out std_logic;
        result_o:   out std_logic_vector(15 downto 0);
        sign_o:     out std_logic;
        overflow_o: out std_logic;
        error_o:    out std_logic
    );
    end component;

    signal clk_i:       std_logic;
    signal reset_i:     std_logic;
    signal op1_i:       std_logic_vector(11  downto 0);
    signal op2_i:       std_logic_vector(11  downto 0);
    signal otype_i:     std_logic_vector(3  downto 0);
    signal start_i:     std_logic;
    
    signal finished_o:  std_logic;
    signal result_o:    std_logic_vector(15 downto 0);
    signal sign_o:      std_logic;
    signal overflow_o:  std_logic;
    signal error_o:     std_logic;

    begin
        i_alu: alu
        port map(
            clk_i       => clk_i,
            reset_i     => reset_i,
            op1_i       => op1_i,
            op2_i       => op2_i,
            otype_i     => otype_i,
            start_i     => start_i,

            finished_o  => finished_o,
            result_o    => result_o,
            sign_o      => sign_o,
            overflow_o  => overflow_o,
            error_o     => error_o
        );
        
        p_clk: process
            begin
                clk_i <= '0';
                wait for 5 ns;
                clk_i <= '1';
                wait for 5 ns;
        end process;

        p_ss: process
            begin
                reset_i <= '1';
                wait for 5 ns;
                reset_i <= '0';
                wait for 10 ns;
                otype_i <= x"C";
                op1_i <= x"804";
                start_i <= '1';
                wait for 10 ns;
                start_i <= '0';
                wait for 20 ns;
                otype_i <= x"9";
                op1_i <= x"5F0";
                op2_i <= x"944";
                start_i <= '1';
                wait for 10 ns;
                start_i <= '0';
                wait for 20 ns;
                otype_i <= x"1";
                op1_i <= x"5F0";
                op2_i <= x"333";
                start_i <= '1';
                wait for 10 ns;
                start_i <= '0';
                wait for 20 ns;
                otype_i <= x"1";
                op1_i <= x"472";
                op2_i <= x"D53";
                start_i <= '1';
                wait for 10 ns;
                start_i <= '0';
                wait for 20 ns;
                otype_i <= x"7";
                op1_i <= x"472";
                op2_i <= x"D53";
                start_i <= '1';
                wait for 10 ns;
                start_i <= '0';
                wait for 200 ns;
                assert false report "SIMMULATION_END" severity failure;
        end process;
end architecture;