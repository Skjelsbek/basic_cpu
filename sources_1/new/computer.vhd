library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity computer is
    port
    (
        clk, rst: in std_logic;
        JA: out std_logic_vector(3 downto 0);
        dir_out: out std_logic;
        servo_out: out std_logic
    );
end computer;

architecture cmp_arch of computer is
    constant BW: Integer := 8;
    constant ABW: Integer := 5;
    
    -- signals
    signal db: std_logic_vector(BW - 1 downto 0);
    signal ob: std_logic_vector(BW - 1 downto 0);
    signal ab: std_logic_vector(ABW - 1 downto 0);
    signal we, dir, servo_dir: std_logic;
    
begin
    c_cpu: entity work.cpu(cpu_arch)
        generic map
        (
            ABW => ABW,
            BW => BW
        )
        port map
        (
            clk => clk,
            rst => rst,
            db => db,
            we => we,
            ab => ab,
            ob => ob,
            dir => dir,
            servo_dir => servo_dir
        );
    
    c_mem: entity work.memory(mem_arch)
        generic map
        (
            BW => BW,
            ABW => ABW
        )
        port map
        (
            rst => rst,
            we => we,
            ab => ab,
            ob => ob,
            db => db
        );

    c_stepper_motor_controller: entity work.stepper_motor_controller(smc_arch)
        port map
        (
            clk => clk,
            dir => dir,
            JA => JA,
            dir_out => dir_out
        );
    c_servo_controller: entity work.servo_controller(servo_arch)
        port map
        (
            clk => clk,
            rst => rst,
            dir => servo_dir,
            pwm => servo_out
        );
end cmp_arch;
