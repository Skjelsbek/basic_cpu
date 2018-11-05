library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
    generic
    (
        BW : Integer := 8;
        ABW: Integer := 5
    );
    Port
    (
        rst: in std_logic;
        we : in std_logic;
        ab : in std_logic_vector(ABW - 1 downto 0);
        ob : in std_logic_vector(BW - 1 downto 0);
        db : out std_logic_vector(BW - 1 downto 0) := (others => '1')
    );
end memory;

architecture mem_arch of memory is
    
    -- Intructions
    constant LDRM: unsigned := "10100000"; -- A0H
    constant LDMR: unsigned := "00001010"; -- 0AH
    constant INCR: unsigned := "00000000"; -- 00H    
    constant TOGR: unsigned := "10000000"; -- 80H
    constant HALT: unsigned := "11111111"; -- FFH
    constant STF : unsigned := "00000001"; -- 01H 
    constant STB : unsigned := "00000010"; -- 02H
    constant PUP : unsigned := "00000011"; -- 03H
    constant PDN : unsigned := "00000100"; -- 04H
    
    -- Memory structure
    type reg_arr is array(2**ABW downto 0) of std_logic_vector(BW - 1 downto 0);        
    signal mem: reg_arr :=
        (   
            0 => std_logic_vector(HALT),
            1 => std_logic_vector(LDRM),
            2 => "10000001",            
            3 => std_logic_vector(INCR),
            4 => std_logic_vector(TOGR),
            5 => std_logic_vector(LDMR),
            7 => std_logic_vector(STF), 
            8 => std_logic_vector(STB),
            9 => std_logic_vector(PDN),
            10 => std_logic_vector(PUP),
            11 => std_logic_vector(PDN),          
            others => std_logic_vector(HALT) 
        );   
        
begin            
    process (rst, we, ab, ob)
    begin
        if (rst = '1') then            
            mem <= 
            (   
                --0 => std_logic_vector(HALT),
                --1 => std_logic_vector(LDRM),
                --2 => "11111100", -- Data which will turn into STB instruction after INCR and TOGR
                --2 => "11111101", -- Data which will turn into STF instruction after INCR and TOGR
                --3 => std_logic_vector(INCR),
                --4 => std_logic_vector(TOGR),
                --5 => std_logic_vector(LDMR),
                others => std_logic_vector(HALT) 
            );
            db <= mem(0);     
        elsif (we = '1') then
            mem(to_integer(unsigned(ab) + 1)) <= ob;  
        elsif (to_integer(unsigned(ab)) < 32) then            
            db <= mem(to_integer(unsigned(ab))); 
        end if;
    end process;
        
end mem_arch;
