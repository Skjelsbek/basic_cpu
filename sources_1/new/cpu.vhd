-- Basic CPU 
library	ieee;
use	ieee.std_logic_1164.all;

entity cpu is
    generic
    (
        ABW: Integer := 5;
        BW: Integer := 8
    );
	port
	(
		clk, rst: in std_logic;
		db: in std_logic_vector(BW - 1 downto 0);  -- data bus
		we: out std_logic; -- write enable
		ab: out std_logic_vector(ABW - 1 downto 0); -- address bus
		ob: out std_logic_vector(BW - 1 downto 0);  -- output bus
		dir: inout std_logic;
		servo_dir: out std_logic
	);
end cpu;

architecture cpu_arch of cpu is      

    signal pc_reg: std_logic_vector(ABW-1 downto 0);
    signal ir_reg: std_logic_vector(BW-1 downto 0);
    signal reg_en, reg_inc, reg_tog: std_logic;
    signal ir_en: std_logic;
    signal mem_en: std_logic;

begin

    c_idec: entity work.IDEC(idec_arch)
        generic map
        (
            ABW => ABW,
            DBW => BW
        )
        port map
        (
            clk => clk,
            rst => rst,
            we => we,
            ir_reg => ir_reg,                 
            ir_en => ir_en,
            pc_reg => pc_reg,
            reg_en => reg_en,
            reg_inc => reg_inc,
            reg_tog => reg_tog,
            dir => dir,
            servo_dir => servo_dir
        );
        
    c_ir: entity work.instruction_register(ir_arch)
        generic map
        (
            DBW => BW
        )
        port map
        (
            clk => clk,
            rst => rst,
            en => ir_en,
            db => db,
            ins => ir_reg
        );
        
    c_pc: entity work.program_counter(pc_arch)
        generic map
        (
            ABW => ABW
        )
        port map
        (
            clk => clk,
            rst => rst,
            in_val => pc_reg,
            pc => ab
        );
    
    c_reg: entity work.reg(reg_arch)
        generic map
        (
            BW => BW
        )
        port map
        (
            clk => clk,
            rst => rst,
            en => reg_en,
            inc => reg_inc,
            tog => reg_tog,
            db => db,
            ob => ob
        );            
end cpu_arch;


