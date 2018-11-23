library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg is
    generic
    (
        BW: Integer := 8
    );
    Port
    (
        clk,rst: in std_logic;
        en, inc, tog: in std_logic;
        db: in std_logic_vector(BW - 1 downto 0);
        ob: out std_logic_vector(BW - 1 downto 0)
    );
end reg;

architecture reg_arch of reg is

    signal value: std_logic_vector(BW - 1 downto 0);
    signal next_val: std_logic_vector(BW - 1 downto 0);
begin
    process (clk, rst)
    begin
        if (rst = '1') then	       
            value <= (others => '0'); -- initialize data register to 0
        elsif (rising_edge(clk)) then
            value <= next_val;
        end if;
    end process;
    
    process(value, en, inc, tog, db) -- state register code section
    begin	   
	   if (en = '1') then     
	       next_val <= db;
	   elsif (inc = '1') then
	       next_val <= std_logic_vector(unsigned(value) + 1);
	   elsif (tog = '1') then
	       next_val <= not value;
	   end if;
    end process;
    
    ob <= value;
end reg_arch;