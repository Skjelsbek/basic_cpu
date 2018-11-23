library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller_buffer is
    port
    (
        shift: in std_logic;        
        ins_from_cpu: in std_logic_vector(7 downto 0);
        bob: out std_logic_vector(7 downto 0); -- Buffer output bus
        empty: out std_logic;
        full: out std_logic
    );        
end entity;

architecture ctr_buf_arch of controller_buffer is

    type buf is array(0 to 63) of std_logic_vector(7 downto 0); -- Servo instruction buffer
    signal ins_buf: buf := (others => (others => '0'));
    signal ins_in_buf: Integer := 0; -- Number of instructions in buffer
    signal last_ins_from_cpu: std_logic_vector(7 downto 0);
    signal last_shift: std_logic := '0';
    
begin
    insert_instruction: process (last_shift, ins_from_cpu, last_ins_from_cpu, ins_in_buf, ins_buf, shift)
    begin
        if (ins_from_cpu /= last_ins_from_cpu) then
            ins_buf(ins_in_buf) <= ins_from_cpu;
            ins_in_buf <= ins_in_buf + 1;
            last_ins_from_cpu <= ins_from_cpu;
        end if;
        
        if (shift /= last_shift) then            
            ins_buf <= ins_buf(1 to 63) & "00000000";
            ins_in_buf <= ins_in_buf - 1;
            last_shift <= shift;
        end if;
    end process;
    
--    remove_instruction: process (shift, ins_buf)
--    begin
--        if (shift /= last_shift) then            
--            ins_buf <= ins_buf(1 to 7) & "00000000";
--            ins_in_buf <= ins_in_buf - 1;
--            last_shift <= shift;
--        end if;  
--    end process;
    
    full <= '1' when ins_in_buf = 8 else '0';
    empty <= '1' when ins_in_buf = 0 else '0';
    bob <= ins_buf(0);     
end ctr_buf_arch;