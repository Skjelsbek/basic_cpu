library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity organizer is
    port
    (
        clk: in std_logic;
        bob: in std_logic_vector(7 downto 0);
        buf_is_empty: in std_logic;
        shift_buf: out std_logic := '0';
        servo_out: out std_logic;
        left_motor_out: out std_logic_vector(3 downto 0);
        right_motor_out: out std_logic_vector(3 downto 0)  
    );
end organizer;

architecture org_arch of organizer is
    
    signal servo_dir, servo_dir_next: std_logic;
    signal left_stepper_dir, left_stepper_dir_next: std_logic;
    signal right_stepper_dir, right_stepper_dir_next: std_logic;
    
    signal servo_working: std_logic;
    signal left_motor_working: std_logic;
    signal right_motor_working: std_logic;
    
    type state is (buf_0, buf_1);
    signal state_reg: state := buf_0;
    signal state_next: state;
    
    signal ins, ins_next: std_logic_vector(7 downto 0);
    signal number_of_steps, number_of_steps_next: std_logic_vector(7 downto 0);
    signal stepper_enable, stepper_enable_next: std_logic := '0';
    signal shift_buf_val, shift_buf_next: std_logic := '0';
    
    -- Intructions   
    constant STF : std_logic_vector := "00000001"; -- 01H 
    constant STB : std_logic_vector := "00000010"; -- 02H
    constant PUP : std_logic_vector := "00000011"; -- 03H
    constant PDN : std_logic_vector := "00000100"; -- 04H
    constant STR : std_logic_vector := "00000101"; -- 05H 
    constant STL : std_logic_vector := "00000110"; -- 06H
    
begin
    
    left_motor_controller: entity work.stepper_motor_controller
        port map
        (
            clk => clk,
            dir => left_stepper_dir,
            number_of_steps => number_of_steps,
            en => stepper_enable,
            working => left_motor_working,
            motor => left_motor_out        
        );
    
    right_motor_controller: entity work.stepper_motor_controller
        port map
        (
            clk => clk,
            dir => right_stepper_dir,
            number_of_steps => number_of_steps,
            en => stepper_enable,
            working => right_motor_working,
            motor => right_motor_out        
        );
        
    servo_controller: entity work.servo_controller
        port map
        (
            clk => clk,
            dir => servo_dir,
            working => servo_working,
            pwm => servo_out    
        );
    
    next_state: process (clk)
    begin
        if (rising_edge(clk)) then
            stepper_enable <= stepper_enable_next;
            servo_dir <= servo_dir_next;         
            ins <= ins_next;                        
            number_of_steps <= number_of_steps_next;
            left_stepper_dir <= left_stepper_dir_next;
            right_stepper_dir <= right_stepper_dir_next;
            shift_buf_val <= shift_buf_next;
            state_reg <= state_next;
        end if;
    end process;
    
    fetch_from_buffer: process (buf_is_empty, left_motor_working, right_motor_working, servo_working, bob, ins, stepper_enable, state_reg)--, shift_buf_val)
    begin
        if(buf_is_empty = '0' and left_motor_working = '0' and right_motor_working = '0' and servo_working = '0') then
            case state_reg is
                when buf_0 =>
                    if (bob = STF or bob = STB or bob = STR or bob = STL) then                        
                        state_next <= buf_1;
                        ins_next <= bob;                       
                    elsif(bob = PUP) then
                        servo_dir_next <= '0';
                        state_next <= buf_0;
                    elsif(bob = PDN) then
                        servo_dir_next <= '1';
                        state_next <= buf_0;                     
                    end if;
                    shift_buf_next <= not shift_buf_val;      
                when others =>
                    number_of_steps_next <= bob;                                        
                    
                    if(ins = STF) then
                        left_stepper_dir_next <= '0';
                        right_stepper_dir_next <= '0';
                    elsif(ins = STB) then
                        left_stepper_dir_next <= '1';
                        right_stepper_dir_next <= '1';
                    elsif(ins = STR) then
                        left_stepper_dir_next <= '0';
                        right_stepper_dir_next <= '1';
                    elsif(ins = STL) then
                        left_stepper_dir_next <= '1';
                        right_stepper_dir_next <= '0';
                    end if;
                    
                    stepper_enable_next <= not stepper_enable;                           
                    shift_buf_next <= not shift_buf_val;
                    state_next <= buf_0;
            end case;            
        end if;
    end process;
    
    shift_buf <= shift_buf_val;
end org_arch;