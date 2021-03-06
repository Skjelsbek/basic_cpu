library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity IDEC is
    generic
    (
        ABW: integer := 5;
        DBW: integer := 8
    );
    port
    (
        clk, rst: in std_logic;
        we: out std_logic := '0';
        ir_reg: in std_logic_vector(DBW - 1 downto 0) := (others => '1');
        ir_en: inout std_logic := '1';              
        pc_reg: inout std_logic_vector(ABW - 1 downto 0) := (others => '0');
        reg_en, reg_inc, reg_tog: inout std_logic := '0';
        actuator_ins: out std_logic_vector(DBW - 1 downto 0)
    );
end IDEC;

architecture idec_arch of IDEC is
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
	constant STR : unsigned := "00000101"; -- 05H 
    constant STL : unsigned := "00000110"; -- 06H
	
    type state_type is (all_0, all_1, stx_2);
    
    signal state_reg: state_type := all_0;
    signal state_next: state_type;
	signal pc_next: std_logic_vector(ABW-1 downto 0);
    signal ins_from_cpu, ins_from_cpu_next: std_logic_vector(DBW - 1 downto 0);
	signal ir_en_next, reg_en_next, reg_inc_next, reg_tog_next, we_next: std_logic;	
	signal start: std_logic:= '0';
begin

process(clk,rst)						-- state register code section
begin
	if (rst='1') then
		state_reg <= all_0;
		pc_reg <= (others => '0');	-- reset address is all-0
		ir_en <= '1';
		reg_en  <= '0';
		reg_inc <= '0';
		reg_tog <= '0';
		we <= '0';
	elsif (rising_edge(clk)) then
		state_reg <= state_next;
		pc_reg <= pc_next;
		ir_en <= ir_en_next;		
		reg_en <= reg_en_next;
		reg_inc <= reg_inc_next;
		reg_tog <= reg_tog_next;
		we <= we_next;
		ins_from_cpu <= ins_from_cpu_next;
		start <= '1';
	end if;
end process;

process(ins_from_cpu, state_reg, pc_reg, reg_en, reg_inc, reg_tog, ir_en, ir_reg, start)	-- next state + (Moore) outputs code section
begin
    pc_next <= pc_reg;
    state_next <= state_reg;
    ir_en_next <= '0';
	reg_en_next <= '0';
	reg_inc_next <= '0';
	reg_tog_next <= '0';
	we_next <= '0';
	ins_from_cpu_next <= ins_from_cpu;
	 if(start = '1') then
	case state_reg is
	   when all_0 =>		 
	        state_next <= all_1;
            --ir_en_next <= '1';
			pc_next <= std_logic_vector(unsigned(pc_reg)+1);
		when all_1 =>		  
          if (unsigned(ir_reg) = LDRM) then	  		    
            reg_en_next <= '1';       
            pc_next <= std_logic_vector(unsigned(pc_reg)+1);
            state_next <= all_0;
          elsif (unsigned(ir_reg) = LDMR) then
            we_next <= '1';
            state_next <= all_0;
          elsif (unsigned(ir_reg) = INCR) then
            reg_inc_next <= '1';
            state_next <= all_0;
          elsif (unsigned(ir_reg) = TOGR) then
            reg_tog_next <= '1';
            state_next <= all_0;          
          elsif (unsigned(ir_reg) = STF or unsigned(ir_reg) = STB or unsigned(ir_reg) = STR or unsigned(ir_reg) = STL) then
            ir_en_next <= '1';
            ins_from_cpu_next <= ir_reg;            
            state_next <= stx_2;
          elsif (unsigned(ir_reg) = PUP) then
            ins_from_cpu_next <= ir_reg;
            state_next <= all_0; 
          elsif (unsigned(ir_reg) = PDN) then
            ins_from_cpu_next <= ir_reg;
            state_next <= all_0; 
          elsif (unsigned(ir_reg) = HALT) then
            state_next <= all_1;
          else 
	       state_next <= all_0;
		  end if;
		  ir_en_next <= '1';
	   when stx_2 =>
	       ins_from_cpu_next <= ir_reg;
	       pc_next <= std_logic_vector(unsigned(pc_reg)+1);
	       state_next <= all_0;
	       ir_en_next <= '1';
	end case; 
	end if;
end process;

actuator_ins <= ins_from_cpu;
end idec_arch;