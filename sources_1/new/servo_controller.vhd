library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity servo_controller is
    Port
    (
        clk: in std_logic;
        dir: in std_logic;
        working: out std_logic := '0';
        pwm: out std_logic := '0'
    );
end servo_controller;

architecture servo_arch of servo_controller is    
    
    type direction is (up, down);
    signal servo_dir: direction;
    
    signal count: Integer := 0;
    signal set_pos: Boolean := false;
    
    constant period: Integer := 2000000;
    constant up_duty_cycle: Integer := 142500;
    constant down_duty_cycle: Integer := 240000;
    
    signal last_dir: std_logic;
begin
    
    counter: process (clk, count, set_pos, dir, last_dir)    
    begin                     
        
        if (dir /= last_dir) then
            last_dir <= dir;               
            set_pos <= True;
            working <= '1';
        end if;
    
        if (rising_edge(clk)) then                  
            if (dir = '0') then
                servo_dir <= up;
            else
                servo_dir <= down;
            end if;
            
            if (set_pos) then
                if (count < period) then
                    count <= count + 1;
                else 
                    set_pos <= False;
                    working <= '0';                    
                    count <= 0;                                                                        
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
