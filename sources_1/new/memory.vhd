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
    constant LDRM: std_logic_vector := "10100000"; -- A0H
    constant LDMR: std_logic_vector := "00001010"; -- 0AH
    constant INCR: std_logic_vector := "00000000"; -- 00H    
    constant TOGR: std_logic_vector := "10000000"; -- 80H
    constant HALT: std_logic_vector := "11111111"; -- FFH
    constant STF : std_logic_vector := "00000001"; -- 01H 
    constant STB : std_logic_vector := "00000010"; -- 02H
    constant PUP : std_logic_vector := "00000011"; -- 03H
    constant PDN : std_logic_vector := "00000100"; -- 04H
    constant STR : std_logic_vector := "00000101"; -- 05H 
    constant STL : std_logic_vector := "00000110"; -- 06H
    
    -- Memory structure
    type reg_arr is array(2**ABW downto 0) of std_logic_vector(BW - 1 downto 0);        
    signal mem: reg_arr :=
        (   
            0 => PUP,
            1 => STF,
            2 => "00001010",
            3 => PDN,
            4 => STR,
            5 => "00001010", 
            6 => STB,
            7 => "00001010",  
            8 => STL,
            9 => "00001010",
            10 => PUP,       
            others => HALT 
        );   
        
begin            
    process (rst, we, ab, ob, mem)
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
