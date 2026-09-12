library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity muxb is
    port(
        adress_in_muxa   : in  std_logic_vector(11 downto 0);
        adress_in_memory : in  std_logic_vector(15 downto 0);
        selB             : in  std_logic;
        adress_out_b     : out std_logic_vector(15 downto 0)
    );
end muxb;

architecture behave_muxb of muxb is
    signal temp : std_logic_vector(15 downto 0);
begin
    temp(15 downto 12) <= "0000";
    temp(11 downto 0)  <= adress_in_muxa;

    adress_out_b <= adress_in_memory when selB = '1' else temp;
end behave_muxb;
