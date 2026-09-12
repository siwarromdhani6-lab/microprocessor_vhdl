library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity accumulator is
    port(
        clk            : in  std_logic;
        reset          : in  std_logic;
        acc_ld         : in  std_logic;
        operand_in_alu : in  std_logic_vector(15 downto 0);
        acc_z          : out std_logic;
        acc_15         : out std_logic;
        result_out_acc : out std_logic_vector(15 downto 0)
    );
end accumulator;

architecture behave_accumulator of accumulator is
    signal acc_reg : std_logic_vector(15 downto 0);
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            if reset = '1' then
                acc_reg <= (others => '0');
            elsif acc_ld = '1' then
                acc_reg <= operand_in_alu;
            end if;
        end if;
    end process;

    result_out_acc <= acc_reg;
    acc_15 <= acc_reg(15);

    if_zero : process(acc_reg)
    begin
        if acc_reg = x"0000" then
            acc_z <= '1';
        else
            acc_z <= '0';
        end if;
    end process;
end behave_accumulator;
