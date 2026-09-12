library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity program_counter is
    port(
        clk           : in  std_logic;
        reset         : in  std_logic;
        pc_ld         : in  std_logic;
        adress_in_alu : in  std_logic_vector(15 downto 0);
        adress_out_pc : out std_logic_vector(11 downto 0)
    );
end program_counter;

architecture behave_program_counter of program_counter is
    signal pc_reg : std_logic_vector(11 downto 0);
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            if reset = '1' then
                pc_reg <= (others => '0');
            elsif pc_ld = '1' then
                pc_reg <= adress_in_alu(11 downto 0);
            end if;
        end if;
    end process;

    adress_out_pc <= pc_reg;
end behave_program_counter;
