library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library altera;
use altera.alt_dspbuilder_package.all;

library lpm;
use lpm.lpm_components.all;
entity alt_dspbuilder_cast_GN6V2QIVA5 is
	generic		( 			round : natural := 0;
			saturate : natural := 0);

	port(
		input : in std_logic_vector(36 downto 0);
		output : out std_logic_vector(54 downto 0));		
end entity;



architecture rtl of alt_dspbuilder_cast_GN6V2QIVA5 is 
Begin

-- Output - I/O assignment from Simulink Block  "Output"
Outputi : alt_dspbuilder_SBF generic map(
				width_inl=> 32 ,
				width_inr=> 5,
				width_outl=> 34,
				width_outr=> 21,
				lpm_signed=>  BusIsSigned ,
				round=> round,
				satur=> saturate)
		port map (
								xin(36 downto 0)  => input,
																yout => output				
				);
				
end architecture;