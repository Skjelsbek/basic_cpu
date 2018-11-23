library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity computer_tb is
end computer_tb;

architecture Behavioral of computer_tb is
        
    -- signals
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal left_motor_out: std_logic_vector(3 downto 0);
    signal right_motor_out: std_logic_vector(3 downto 0);
    signal servo_out: std_logic;
    
    -- Clock period definitions
    constant clk_period : time := 10 ns;
    
begin
    UUT: entity work.computer(cmp_arch)
        port map
        (
            clk => clk,
            rst => rst,
            left_motor_out => left_motor_out,
            right_motor_out => right_motor_out, 
            servo_out => servo_out
        );    
    
    -- Clock process definitions
   clk_process: process
   begin
		clk <= not clk;
		wait for clk_period/2;
   end process;
   
    -- Stimulus process
--    stim_proc: process
--    begin        
--        rst <= '1';
--        wait for clk_period;
--        rst <= '0';
--        wait;
--    end process;
end Behavioral;
