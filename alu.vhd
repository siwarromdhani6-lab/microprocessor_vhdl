library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    port(
        alufs          : in  std_logic_vector(3 downto 0);
        adress_in_muxb : in  std_logic_vector(15 downto 0);
        adress_in_acc  : in  std_logic_vector(15 downto 0);
        adress_out_alu : out std_logic_vector(15 downto 0)
    );
end alu;

architecture behave_alu of alu is
begin
    process(alufs, adress_in_muxb, adress_in_acc)
    begin
        case alufs is
            when "0000" =>
                adress_out_alu <= adress_in_muxb;                                  -- S = B
            when "0001" =>
                adress_out_alu <= std_logic_vector(signed(adress_in_acc) - signed(adress_in_muxb)); -- S = A - B
            when "0010" =>
                adress_out_alu <= std_logic_vector(signed(adress_in_acc) + signed(adress_in_muxb)); -- S = A + B
            when "0011" =>
                adress_out_alu <= std_logic_vector(unsigned(adress_in_muxb) + 1);  -- S = B + 1
            when others =>
                adress_out_alu <= (others => '0');
        end case;
    end process;
end behave_alu;
