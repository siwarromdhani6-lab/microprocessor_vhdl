library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity output_enable is
    port(
        i      : in  std_logic_vector(15 downto 0);
        acc_oe : in  std_logic;
        result : out std_logic_vector(15 downto 0)
    );
end output_enable;

architecture behave_output_enable of output_enable is
begin
    result <= i when acc_oe = '1' else (others => 'Z');
end behave_output_enable;
