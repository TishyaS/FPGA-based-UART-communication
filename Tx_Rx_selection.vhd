----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Tishya Sharma Sarkar
-- 
-- Create Date: 25.02.2022 18:20:58
-- Design Name: 
-- Module Name: Tx_Rx_selection - Behavioral
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
-- Copyright Tishya Sarma Sarkar, Bappaditya Sinha. All Rights Reserved.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Tx_Rx_selection is
    Port ( Gpio : out STD_LOGIC_VECTOR(1 DOWNTO 0);
           Clock : in STD_LOGIC;
           Resetn : in STD_LOGIC;
           LED1 : in STD_LOGIC;
           LED_D : in STD_LOGIC);
end Tx_Rx_selection;

architecture Behavioral of Tx_Rx_selection is

signal gpio_input : std_logic_vector(1 downto 0);

begin

Gpio <= gpio_input;

process(Clock)
begin
if(rising_edge(Clock)) then
if(Resetn = '0') then
gpio_input <= (others => '0');
else
gpio_input(1) <= LED_D;
gpio_input(0) <= LED1;
end if;
end if;
end process;

end Behavioral;
