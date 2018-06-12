----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/12/2018 07:01:12 AM
-- Design Name: 
-- Module Name: digital_lock - arch
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

entity digital_lock is
    Port ( 
            my_btnC, clk, my_btnU, my_btnR, my_btnL, my_btnD: in std_logic;
            my_sw: in std_logic_vector(3 downto 0);
            hex0, hex1, hex2, hex3: out std_logic_vector (3 downto 0);
            my_led: out std_logic_vector(15 downto 0)
            );
end digital_lock;

architecture Behavioral of digital_lock is
type state IS (programming_mode, p_wait1, p_wait2, p_wait3, normal_mode , n_wait1, n_wait2, n_wait3, compare, unlock, failing, locked);
signal next_s: state;
constant clk_period : TIME := 20 ns;
signal fail: unsigned(1 downto 0);
signal num1, num2, num3, key1, key2, key3: std_logic_vector(3 downto 0);
signal number, final_key: std_logic_vector(11 downto 0);

begin
     
    FSM: process
    begin
    if(my_btnC ='1') then
        next_s <= programming_mode;
    elsif rising_edge(clk) then
        case next_s is
            when programming_mode =>
                fail <= "00";
                my_led <= (others => '0');
                hex3 <= x"0";
                hex2 <= x"0";
                hex1 <= x"0";
                hex0 <= x"0";
                
                if(my_btnL ='1') then
                    next_s <= p_wait1;
                    wait for clk_period;
                else
                    next_s <= programming_mode;
                    wait for clk_period/2;
                end if;
                
             when p_wait1 =>
                key1 <= my_sw;
                hex0 <= key1;
                if(my_btnL='1') then
                    next_s <= p_wait2;
                    wait for clk_period;
                else
                    next_s <= p_wait1;
                    wait for clk_period/2;
                end if;
                
            when p_wait2 =>
                key2 <= my_sw;
                hex0 <= key2;
                if(my_btnL ='1') then
                    next_s <= p_wait3;
                    wait for clk_period;
                else
                    next_s <= p_wait2;
                    wait for clk_period/2;
                end if;
                
            when p_wait3 =>
                key3 <= my_sw;
                hex0 <= key3;
                if(my_btnR= '1') then
                    next_s <= normal_mode;
                    wait for clk_period;
                else 
                    next_s <= p_wait3;
                    wait for clk_period/2;
                end if;
                
            when normal_mode =>
                final_key(11 downto 8) <= key1;
                final_key(7 downto 4) <= key2;
                final_key(3 downto 0) <= key3;
                if(my_btnU ='1') then
                    next_s <= n_wait1;
                    wait for clk_period;
                else
                    next_s <= normal_mode;
                    wait for clk_period/2;
                end if;
                
            when n_wait1 =>
                num1 <= my_sw;
                hex0 <= num1;
                if(my_btnD ='1') then
                    next_s <= programming_mode;
                    wait for clk_period/2;
                elsif (my_btnL ='1') then
                    next_s <= n_wait2;
                    wait for clk_period;
                else
                    next_s <= n_wait1;
                    wait for clk_period/2;
                end if;
                
            when n_wait2 =>
                num2 <= my_sw;
                hex0 <= num2;
                if(my_btnD ='1') then
                    next_s <= programming_mode;
                    wait for clk_period/2;
                elsif(my_btnL ='1') then
                    next_s <= n_wait3;
                    wait for clk_period;
                else
                    next_s <= n_wait2;
                    wait for clk_period/2;
                end if;
                
            when n_wait3 =>
                num3 <= my_sw;
                hex0 <= num3;
                if(my_btnD ='1') then
                    next_s <= programming_mode;
                    wait for clk_period/2;
                elsif(my_btnR = '1') then
                    next_s <= compare;
                    wait for clk_period;
                else 
                    next_s <= n_wait3;
                    wait for clk_period/2;
                end if;
                
            when compare =>
                number(11 downto 8) <= num1;
                number(7 downto 4) <= num2;
                number(3 downto 0) <= num3;
                if(number = final_key) then
                    next_s <= unlock;
                    wait for clk_period;
                else
                    next_s <= failing;
                    wait for clk_period;
                end if;
 
            when unlock =>
                my_led <= (others => '1');
                if(my_btnD = '1') then
                    next_s <= programming_mode;
                    wait for clk_period;
                else
                    next_s <= unlock;
                    wait for clk_period;
                end if;
                
            when failing =>
                fail <= fail + 1;
                if(fail >= 2) then
                    next_s <= locked;
                    wait for clk_period;
                elsif(fail < 2) then
                    next_s <= n_wait1;
                    wait for clk_period;
                end if;
                
            when locked =>
                my_led <= (others => '0');
                hex0 <= "1111";
                hex1 <= "1111";
                hex2 <= "1111";
                hex3 <= "1111";
                next_s <= locked;
                wait for clk_period/2;
        end case;
        end if;
    end process;
end Behavioral;

