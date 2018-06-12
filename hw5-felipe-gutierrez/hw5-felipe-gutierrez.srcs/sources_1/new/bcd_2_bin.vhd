----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/25/2018 10:03:12 AM
-- Design Name: 
-- Module Name: bcd_2_bin - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bcd_2_bin is
    Port ( input_A : in STD_LOGIC_VECTOR(3 downto 0);
           input_B : in STD_LOGIC_VECTOR(3 downto 0);
           bin_out : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0')
    );
end bcd_2_bin;

architecture Behavioral of bcd_2_bin is
begin
bin_out <= (input_B * "01")  --multiply by 1
                + (input_A * "1010"); --multiply by 10

end Behavioral;
