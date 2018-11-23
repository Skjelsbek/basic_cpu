## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
    set_property IOSTANDARD LVCMOS33 [get_ports clk]

##Buttons
set_property PACKAGE_PIN U18 [get_ports rst]						
	set_property IOSTANDARD LVCMOS33 [get_ports rst]

##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {left_motor_out[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {left_motor_out[0]}]
	
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {left_motor_out[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {left_motor_out[1]}]
	
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {left_motor_out[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {left_motor_out[2]}]
	
##Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {left_motor_out[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {left_motor_out[3]}]
	
##Pmod Header JB
    ##Sch name = JB1
    set_property PACKAGE_PIN A14 [get_ports {right_motor_out[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {right_motor_out[0]}]
        
    ##Sch name = JB2
    set_property PACKAGE_PIN A16 [get_ports {right_motor_out[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {right_motor_out[1]}]
        
    ##Sch name = JB3
    set_property PACKAGE_PIN B15 [get_ports {right_motor_out[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {right_motor_out[2]}]
        
    ##Sch name = JB4
    set_property PACKAGE_PIN B16 [get_ports {right_motor_out[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {right_motor_out[3]}]
    
    
    ##Sch name = JB7
    set_property PACKAGE_PIN A15 [get_ports {servo_out}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {servo_out}]
