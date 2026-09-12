 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity memory is
    port(
        addr_in_muxa   : in    std_logic_vector(11 downto 0);
        rnw            : in    std_logic;
       data_out_memory: inout std_logic_vector(15 downto 0)

    );
end memory;
architecture Behavioral of memory is
    type ram_array is array (0 to 4095) of std_logic_vector(15 downto 0);
    signal RAM : ram_array := (
        16#000# => x"0100", 
        16#001# => x"2101",  
        16#002# => x"6005", 
        16#003# => x"3100", 
        16#004# => x"3100",  
        16#005# => x"2100",  
        16#006# => x"7000",  
        16#100# => x"0007",
        16#101# => x"0005",
        others  => (others => '0')
    );
begin
    process(addr_in_muxa, rnw)
    begin
        if rnw = '0' then
            RAM(to_integer(unsigned(addr_in_muxa))) <= data_out_memory;
        end if;
    end process;
    data_out_memory <= RAM(to_integer(unsigned(addr_in_muxa))) when rnw = '1'

                       else (others => 'Z');
end Behavioral;
