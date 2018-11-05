library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_register is
    generic
    (
        DBW: Integer := 8
    );    
    Port
    (
        clk, rst: in std_logic;
        en: in std_logic;
        db: in std_logic_vector(DBW - 1 downto 0);        
        ins: out std_logic_vector(DBW - 1 downto 0)
    );
end instruction_register;

architecture ir_arch of instruction_register is

begin
    process(rst, en, db)
    begin
        if (rst = '1') then
		  ins <= (others => '1'); 	-- default opcode is HALT (all '1')
        elsif (en = '1') then
		  ins <= db;
	   end if;
    end process;
end ir_arch;