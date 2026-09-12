library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_register is
    port(
        clk              : in  std_logic;
        reset            : in  std_logic;
        adress_in_memory : in  std_logic_vector(15 downto 0);
        ir_ld            : in  std_logic;
        adress_out_ir    : out std_logic_vector(11 downto 0);
        opcode           : out std_logic_vector(3 downto 0)
    );
end instruction_register;

architecture behave_instruction_register of instruction_register is
    signal ir_reg : std_logic_vector(15 downto 0);
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            if reset = '1' then
                ir_reg <= (others => '0');
            elsif ir_ld = '1' then
                ir_reg <= adress_in_memory;
            end if;
        end if;
    end process;

    adress_out_ir <= ir_reg(11 downto 0);
    opcode <= ir_reg(15 downto 12);
end behave_instruction_register;
