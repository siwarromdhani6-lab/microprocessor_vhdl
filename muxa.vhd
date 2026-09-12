library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity muxa is
    port(
        adress_in_pc : in  std_logic_vector(11 downto 0);
        adress_in_ir : in  std_logic_vector(11 downto 0);
        selA         : in  std_logic;
        adress_out_a : out std_logic_vector(11 downto 0)
    );
end muxa;

architecture behave_muxa of muxa is
begin
    adress_out_a <= adress_in_ir when selA = '1' else adress_in_pc;
end behave_muxa;
