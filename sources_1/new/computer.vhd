library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity computer is
    port
    (
        clk, rst: in std_logic;
        servo_out: out std_logic;
        left_motor_out: out std_logic_vector(3 downto 0);
        right_motor_out: out std_logic_vector(3 downto 0)  
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
    
    signal bob: std_logic_vector(7 downto 0);
    signal buf_is_empty: std_logic;
    signal buf_is_full: std_logic;
    signal shift_buf: std_logic;
    signal ins_from_cpu: std_logic_vector(7 downto 0);
    
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
            actuator_ins => ins_from_cpu
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
    
    c_controller_buffer: entity work.controller_buffer(ctr_buf_arch)
        port map
        (
            shift => shift_buf,     
            ins_from_cpu => ins_from_cpu,
            bob => bob,
            empty => buf_is_empty,
            full => buf_is_full
        );
        
    c_organizer: entity work.organizer(org_arch)
        port map
        (
            clk => clk,
            bob => bob,
            buf_is_empty => buf_is_empty,
            shift_buf => shift_buf,
            servo_out => servo_out,
            left_motor_out => left_motor_out,
            right_motor_out => right_motor_out
        );
end cmp_arch;
