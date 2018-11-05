----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/27/2018 04:21:11 PM
-- Design Name: 
-- Module Name: stepper_motor_controller_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity stepper_motor_controller_tb is
--  Port ( );
end stepper_motor_controller_tb;

architecture Behavioral of stepper_motor_controller_tb is
    component stepper_motor_controller
        Port
        (
            clk: in std_logic;
            dir: in std_logic;
            JA: out std_logic_vector(3 downto 0)
        );
    end component stepper_motor_controller;
    
    signal clk, dir: std_logic := '0';
    signal JA: std_logic_vector(3 downto 0);        
begin
    UUT: stepper_motor_controller
        port map
        (
            clk => clk,
            dir => dir,
            JA => JA
        );
        
generate_clk: process
begin
    clk <= not clk;
    wait for 5ns;
end process;

end Behavioral;
