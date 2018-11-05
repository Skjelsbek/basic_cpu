-- 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY cpu_tb IS
END cpu_tb;
 
ARCHITECTURE behavior OF cpu_tb IS 
 
    -- Component Declarations for the Units Under Test (UUT)
    COMPONENT cpu
    generic
    (
        ABW: Integer := 5;
        BW: Integer := 8
    );
    PORT(
         clk, rst: in std_logic;
         db: in std_logic_vector(BW - 1 downto 0);  -- data bus
         we: in std_logic; -- write enable
         ab: out std_logic_vector(ABW - 1 downto 0); -- address bus
         ob: out std_logic_vector(BW - 1 downto 0)  -- output bus
        );
    END COMPONENT;
    
    constant BW: Integer := 8;
    constant ABW: Integer := 5;
   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal db : std_logic_vector(BW - 1 downto 0);
   signal we: std_logic := '0';

 	--Outputs
   signal ab : std_logic_vector(ABW - 1 downto 0);
   signal ob : std_logic_vector(BW - 1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu PORT MAP (
          clk => clk,
          rst => rst,
          db => db,
          we => we,
          ab => ab,
          ob => ob
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= not clk;
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
        rst <= '1';
        db <= "11111111"; -- HALT
        wait for clk_period;
		rst <= '0';	
		db <= "10100000"; -- LD R,M
		wait for clk_period;
		db <= "10100001";
		wait for clk_period;			
        db <= "11111111"; -- HALT
        wait;
   end process;

END;
