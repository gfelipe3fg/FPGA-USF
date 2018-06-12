----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/07/2018 01:59:07 PM
-- Design Name: 
-- Module Name: lock_top - Behavioral
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

entity lock_top is
  Port (btnC, clk, btnU, btnR, btnL, btnD: in std_logic;
        sw: in std_logic_vector(3 downto 0);
        led: out std_logic_vector(15 downto 0);
        an  : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0)
  
  );
end lock_top;

architecture arch of lock_top is
    signal btnU_db, btnR_db, btnD_db, btnC_db, btnL_db : std_logic;
    signal bin_out1, sseg0, sseg1, sseg2, sseg3, outp : std_logic_vector(7 downto 0);
    signal hex0, hex1, hex2, hex3: std_logic_vector (3 downto 0);
begin

     debounce_U : entity work.debouncer
        port map(clk => clk, reset => '0', raw_in => btnU, db_out => btnU_db);
     debounce_R : entity work.debouncer
        port map(clk => clk, reset => '0', raw_in => btnR, db_out => btnR_db);
     debounce_D : entity work.debouncer
        port map(clk => clk, reset => '0', raw_in => btnD, db_out => btnD_db);
     debounce_C : entity work.debouncer
        port map(clk => clk, reset => '0', raw_in => btnC, db_out => btnC_db);
     debounce_L : entity work.debouncer
        port map(clk => clk, reset => '0', raw_in => btnL, db_out => btnL_db);

     bcd_input : entity work.bcd_2_bin
        port map(input_B => sw(3 downto 0), input_A => x"0", bin_out => bin_out1);
        
     lock_unit : entity work.digital_lock
        port map(my_btnC => btnC_db, 
                 clk => clk, 
                 my_btnU => btnU_db, 
                 my_btnR => btnR_db, 
                 my_btnL => btnL_db, 
                 my_btnD => btnD_db,
                 my_sw => bin_out1(3 downto 0),
                 hex0 => hex0,
                 hex1 => hex1,
                 hex2 => hex2, 
                 hex3 => hex3,
                 my_led => led);
                 
     sseg_unit1 : entity work.hex_to_sseg
        port map(hex => hex0, dp => '1', sseg => sseg0);
                             
     sseg_unit2 : entity work.hex_to_sseg
        port map(hex => hex1, dp => '1', sseg => sseg1);
                             
     sseg_unit3 : entity work.hex_to_sseg
        port map(hex => hex2, dp => '0', sseg => sseg2);
                     
     sseg_unit4 : entity work.hex_to_sseg
        port map(hex => hex3, dp => '1', sseg => sseg3);
     
     disp : entity work.disp_mux
        port map(clk => clk, an => an, in0 => sseg0, in1 => sseg1, in2 => sseg2, in3 => sseg3, reset => btnC, sseg => outp);
                             
     seg <= outp(6 downto 0); 

end arch;