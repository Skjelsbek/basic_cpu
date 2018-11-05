library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity servo_controller is
    Port
    (
        clk, rst: in std_logic;
        dir: in std_logic;
        pwm: out std_logic := '0'
    );
end servo_controller;

architecture servo_arch of servo_controller is    
    
    type direction is (up, down);
    signal servo_dir: direction := up;
    
    signal count: Integer := 0;
    signal set_pos: Boolean := True;
    
    constant period: Integer := 2000000;
    constant up_duty_cycle: Integer := 150000;
    constant down_duty_cycle: Integer := 200000;
    
    signal buf: std_logic_vector(0 to 7) := (others => '0'); -- Servo instruction buffer
    signal ins_in_buf: Integer := 1; -- Number of instructions in buffer
    signal last_dir: std_logic := '0';
begin
    
    counter: process (clk, count, set_pos, dir, buf, ins_in_buf, last_dir)    
    begin                     
        if (rising_edge(clk)) then    
            if (dir /= last_dir) then
                buf(ins_in_buf) <= dir;
                ins_in_buf <= ins_in_buf + 1;
                last_dir <= dir;               
                set_pos <= True;
            end if;
                        
            if (buf(0) = '0') then
                servo_dir <= up;
            else
                servo_dir <= down;
            end if;
            
            if (set_pos) then
                if (count < period) then
                    count <= count + 1;
                else                                        
                    if (ins_in_buf > 1) then                    
                        set_pos <= True;
                    else
                        set_pos <= False;
                    end if;
                    
                    count <= 0;
                    buf <= buf(1 to 7) & '0';
                    ins_in_buf <= ins_in_buf - 1;                                                                          
                end if;
            end if;                                                   
        end if;
    end process;
    
    pulse: process (set_pos, servo_dir, count)
    begin
        if (set_pos) then
            if (servo_dir = up) then
                if (count < up_duty_cycle) then
                    pwm <= '1';
                else
                    pwm <= '0';
                end if;
            elsif (servo_dir = down) then
                if (count < down_duty_cycle) then
                    pwm <= '1';
                else
                    pwm <= '0';                    
                end if;
            end if;
        end if;        
    end process;                   
end servo_arch;
