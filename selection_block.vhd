----------------------------------------------------------------------------------
-- Company: Project FSLCDV  
-- Engineer: Tishya Sharma Sarkar
-- 
-- Create Date: 17.10.2021 11:54:35
-- Design Name: 
-- Module Name: selection_block - Behavioral
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

entity selection_block is
    Port ( Switch_input : in STD_LOGIC_VECTOR(1 downto 0);
           Voice_card : in STD_LOGIC;
           Data_card_zed : in STD_LOGIC;
           output_signal : out STD_LOGIC;
           Clock : in STD_LOGIC;
           Resetn : in STD_LOGIC;
           LED1 : out STD_LOGIC;
           LED_switch : in STD_LOGIC
           );
end selection_block;

architecture Behavioral of selection_block is

signal signature_enable : std_logic;
signal input_mux_enable : std_logic;
signal select_line : std_logic;
signal mux_output : std_logic;
signal signature : std_logic;
signal selection_line : std_logic;
signal output_mux_enable : std_logic;
type signature_bits is array (3 downto 0) of std_logic;
signal so : signature_bits;
signal pointer : integer range 0 to 3;
signal s1 : std_logic;
signal s0 : std_logic;
signal led : std_logic;

begin

--LED initialization
led <= LED_switch;
 LED1 <= led;
 
--select line generation
process(Clock)
begin
if (rising_edge(Clock)) then
if (resetn = '0') then
select_line <= '0';
else
if(Switch_input = "01") then --voice
select_line <= '1';
elsif(Switch_input = "10") then --data
select_line <= '0';
else
select_line <= '0';
end if;
end if;
end if;
end process;

--2:1 MUX_B select line and signature block enable generation 
selection_line <= not led;
signature_enable <= not led;

--2:1 MUX_B enable generation
output_mux_enable <= Switch_input(0) xor Switch_input(1);

--2:1 MUX_A enable generation
input_mux_enable <= led;

--signature block implementation
process(Clock)
begin
if (rising_edge(Clock)) then
if (Resetn= '0') then
so <= "0000";
signature <= '0';
pointer <= 0;
else
if (signature_enable = '1') then
--signature generation
if(select_line = '1') then
so <= "1110"; --voice signature
elsif(select_line = '0') then
so <= "1000"; --data signature
end if;
if(so = "1110" or so = "1000") then
signature <= so (3-pointer);
pointer <= pointer + 1;
end if;
if(pointer = 3) then
pointer <= 0;
end if;
end if;
end if;
end if;
end process;

--2:1 MUX_A implementation
s1 <= select_line and Voice_card;
s0 <= (not select_line) and Data_card_zed;

mux_output <= input_mux_enable and (s1 or s0);


--2:1 MUX_B implementation
output_signal <= output_mux_enable and ((selection_line and signature) or ((not selection_line) and mux_output));

end Behavioral;
