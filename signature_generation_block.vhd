----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Tishya Sharma Sarkar
-- 
-- Create Date: 18.10.2021 22:07:58
-- Design Name: 
-- Module Name: signature_generation_block - Behavioral
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

entity signature_generation_block is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           output : out STD_LOGIC;
           S : in STD_LOGIC_VECTOR (1 downto 0));
end signature_generation_block;

architecture Behavioral of signature_generation_block is
type signature_bits is array (3 downto 0) of std_logic;
signal so : signature_bits;
signal pointer : integer range 0 to 3;
begin

process(clock) 
begin
if (rising_edge(clock)) then
if (reset = '0') then
output <= '0';
else
if (enable = '1') then
--signature generation
if(S(0) = '1' and S(1) = '1') then
so <= "1010";
elsif(S(0) = '0' and S(1) = '1') then
so <= "1100";
elsif(S(0) = '1' and S(1) = '0') then
so <= "1000";
elsif(S(0) = '0' and S(1) = '0') then
so <= "0000";
end if;
output <= so (pointer);
pointer <= pointer + 1;
if(pointer = 3) then
pointer <= 0;
end if;
end if;
end if;
end if;
end process;

end Behavioral;
