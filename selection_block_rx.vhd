----------------------------------------------------------------------------------
-- Company: Project FSLCDV
-- Engineer: Tishya Sharma Sarkar
-- 
-- Create Date: 22.10.2021 21:29:41
-- Design Name: 
-- Module Name: selection_block_rx - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity selection_block_rx is
    Port ( Clock : in STD_LOGIC;
           Resetn : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           LED_V : out STD_LOGIC;
           LED_D : out STD_LOGIC;
           Voice_card : out STD_LOGIC;
           Data_card_zed : out STD_LOGIC);
end selection_block_rx;

architecture Behavioral of selection_block_rx is

signal selection_line : std_logic := '0';
signal signature : std_logic;
signal demux_input : std_logic;
signal demux_enable: std_logic;
signal sign : std_logic_vector(3 downto 0);
signal pointer : integer range 0 to 3;
signal data_led : std_logic;
signal voice_led : std_logic;
signal select_line : std_logic;

begin

--Signature detector block implementation
process(Clock)
begin
if(rising_edge(Clock)) then
if(Resetn = '0') then
sign <= (others => '0');
pointer <= 0;
data_led <= '0';
voice_led <= '0';
else
if(signature = '0') then
sign(3 - pointer) <= signature;
elsif(signature = '1') then
sign(3 - pointer) <= signature;
pointer <= pointer + 1;
end if;
if(pointer = 1) then
pointer <= pointer + 1;
elsif(pointer = 3) then
pointer <= 3;
end if;
if(sign = "1110") then
voice_led <= '1';
data_led <= '0';
elsif(sign = "1000") then
data_led <= '1';
voice_led <= '0';
else
voice_led <= '0';
data_led <= '0';
end if;
--1:2 DEMUX_A select line generation
selection_line <= data_led xor voice_led;
--1:2 DEMUX_B enable generation
demux_enable <= selection_line;
--1:2 DEMUX_B select line generation
select_line <= voice_led and (not(data_led));
end if;
end if;
end process;

--1:2 DEMUX_A implementation
signature <= (not selection_line) and input_signal;
demux_input <= selection_line and input_signal;

--1:2 DEMUX_B implementation
Voice_card <= demux_enable and select_line and demux_input;
Data_card_zed <= demux_enable and (not select_line) and demux_input;

--LED indicator
LED_D <= data_led;
LED_V <= voice_led;

end Behavioral;
