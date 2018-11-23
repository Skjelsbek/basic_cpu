library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_counter is
    generic
    (
        ABW: Integer := 5
    );
    Port
    (
        clk, rst: in std_logic;
        in_val: in std_logic_vector(ABW - 1 downto 0);
        pc: out std_logic_vector(ABW - 1 downto 0)
    );
end program_counter;

architecture pc_arch of program_counter is



begin
    process(rst, in_val)    -- state register code section
    begin
	   if (rst='1') then
	       pc <= (others => '0');	-- reset address is all-0	
	   else
	       pc <= in_val;
	   end if;
    end process;
end pc_arch;