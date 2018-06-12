----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:11:26 04/04/2017 
-- Design Name: 
-- Module Name:    mealy - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
use UNISIM.VComponents.all;

entity mealy is
port (
		Vs, Ts, Tl: IN std_logic;
		mr, my, mg : OUT std_logic;
		sr, sy, sg : OUT std_logic;
		clk, reset: IN std_logic;
		);
end mealy;

architecture Behavioral of mealy is
	type state_type is (s0,s1,s2,s3);  --type of state machine.
	signal current_s,next_s: state_type;  --current and next state declaration.

begin

process (clk,reset)
begin
 if (reset='1') then
  current_s <= s0;  --default state on reset.
elsif (rising_edge(clk)) then
  current_s <= next_s;   --state change.
end if;
end process;

--state machine process.
process (current_s,input)
begin
  case current_s is
     when s0 =>        --when current state is "s0"
	  	mg <= '1';
		sr <= '1';
     if(Vs ='0') then
		wait 25 ns;
      next_s <= s0;
    else
      mg <= '0';
		sr <= '1';
		wait 4 ns;
      next_s <= s1;
     end if;   

     when s1 =>        --when current state is "s1"
    if(Ts ='0') then
      my <= '1';
		sr <= '1';
		wait 4 ns;
      next_s <= s1;
    else
      my <= '0';
		sr <= '1';
      next_s <= s2;
    end if;

    when s2 =>
		mr <= '1';
		sg <= '1';	 --when current state is "s2"
    if(Vs ='0') then
		wait 25 ns;
      next_s <= s2;
    else
      mr <= '1';
		sg <= '0';
		wait 4 ns;
      next_s <= s4;
     end if;   

  when s3 =>         --when current state is "s3"
    if(Ts ='0') then
      mr <= '1';
		sy <= '1';
		wait 4 ns;
      next_s <= s1;
    else
      mr <= '1';
		sy <= '0';
      next_s <= s0;
    end if;
  end case;
end process;
end behavioral;