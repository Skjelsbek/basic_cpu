library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stepper_motor_controller is
    Port
    (
        clk: in std_logic;
        dir: in std_logic; -- Direction
        number_of_steps: in std_logic_vector(7 downto 0);
        en: in std_logic;
        working: out std_logic := '0';
        motor: out std_logic_vector(3 downto 0) -- Outputs to coils on left stepper motor        
    );
end stepper_motor_controller;

architecture smc_arch of stepper_motor_controller is

    constant max_count: integer := 160000*2;    
    constant control_level: integer := 79999*2+1;
    signal count: integer := 0;
    
    signal divided_clk: std_logic := '0';
    
    signal step: integer := 0;
    signal step_next: integer;
    
    signal change_pos: boolean := false;
    signal step_count: unsigned(7 downto 0);
    
    signal en_last: std_logic := '0';
    
begin

    counting_left: process (en_last, clk, en, number_of_steps, step_count, count)
    begin        
        if (en /= en_last) then
            working <= '1';
            change_pos <= true;
            step_count <= unsigned(number_of_steps);            
            en_last <= en;
        end if;
        
        if (rising_edge(clk)) then
            if (change_pos) then
                if (step_count > 0) then
                    if (count < max_count) then
                        count <= count + 1;
                    else
                        count <= 0;
                        step_count <= step_count - 1;
                    end if;                    
                else
                    change_pos <= false;
                    working <= '0';
                end if;                
            end if;            
        end if;
    end process;

    generate_clk: process (change_pos, count)
    begin
        if (change_pos) then
            if (control_level > count) then
                divided_clk <= '0';
            else
                divided_clk <= '1';
            end if;
        end if;
    end process;

    update_state: process (divided_clk)
    begin
        if (rising_edge(divided_clk)) then
            step <= step_next;
        end if;
    end process;

    next_state_logic: process (step, dir)
    begin    
        case (step) is
            when 0 =>
                motor(0) <= '1';
                motor(1) <= '0';
                motor(2) <= '0';
                motor(3) <= '1';
            when 1 =>
                motor(0) <= '1';
                motor(1) <= '1';
                motor(2) <= '0';
                motor(3) <= '0';
            when 2 =>
                motor(0) <= '0';
                motor(1) <= '1';
                motor(2) <= '1';
                motor(3) <= '0';
            when 3 =>
                motor(0) <= '0';
                motor(1) <= '0';
                motor(2) <= '1';
                motor(3) <= '1';
            when others =>
                motor(0) <= '0';
                motor(1) <= '0';
                motor(2) <= '0';
                motor(3) <= '0';                                                                                                  
        end case;
            
        if (dir = '0') then
            if (step = 3) then
                step_next <= 0;
            else      
                step_next <= step + 1;                              
            end if;
        else
            if (step = 0) then
                step_next <= 3;                               
            else
                step_next <= step - 1;                            
            end if;
            
        end if;                 
    end process;
end smc_arch;
