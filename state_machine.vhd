library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity state_machine is
    port(
        opcode : in  std_logic_vector(3 downto 0);
        accz   : in  std_logic;
        acc15  : in  std_logic;
        clk    : in  std_logic;
        reset  : in  std_logic;
        rnw    : out std_logic;
        sela   : out std_logic;
        selb   : out std_logic;
        pc_ld  : out std_logic;
        ir_ld  : out std_logic;
        acc_ld : out std_logic;
        acc_oe : out std_logic;
        alufs  : out std_logic_vector(3 downto 0)
    );   
end state_machine;

architecture Behavioral of state_machine is
    type state_type is (
        FETCH0, FETCH1, FETCH2, FETCH3, DECODE,
        LDA0, LDA1, LDA2,
        STO0, STO1,
        ADD0, ADD1, ADD2,
        SUB0, SUB1, SUB2,
        JMP0, JMP1,
        JGE0, JGE1,
        JNE0, JNE1,
        HALT
    );

    signal state, next_state : state_type;
begin
    
    process(state, opcode, accz, acc15)
    begin
        
        rnw    <= '1';
        sela   <= '0';
        selb   <= '0';
        pc_ld  <= '0';
        ir_ld  <= '0';
        acc_ld <= '0';
        acc_oe <= '0';
        alufs  <= "0000";
        next_state <= state;

        case state is
            when FETCH0 =>
                rnw <= '1';
                sela <= '0'; 
                next_state <= FETCH1;

            when FETCH1 =>
                ir_ld <= '1'; 
                next_state <= FETCH2;

            when FETCH2 =>
                selb <= '0';  
                alufs <= "0011"; 
                pc_ld <= '1';    
                next_state <= FETCH3;

            when FETCH3 =>
                pc_ld <= '1';
                next_state <= DECODE;

            when DECODE =>
                case opcode is
                    when "0000" => next_state <= LDA0;
                    when "0001" => next_state <= STO0;
                    when "0010" => next_state <= ADD0;
                    when "0011" => next_state <= SUB0;
                    when "0100" => next_state <= JMP0;
                    when "0101" => next_state <= JGE0;
                    when "0110" => next_state <= JNE0;
                    when "0111" => next_state <= HALT;
                    when others => next_state <= FETCH0;
                end case;

           
            when LDA0 =>
                sela <= '1'; 
                rnw <= '1';
                next_state <= LDA1;

            when LDA1 =>
                sela <= '1'; 
                selb <= '1'; 
                alufs <= "0000"; 
                acc_ld <= '1';
                next_state <= LDA2;

            when LDA2 =>
                sela <= '1'; 
                acc_ld <= '1';
                next_state <= FETCH0;

            
            when STO0 =>
                sela <= '1'; 
                rnw <= '0';   
                acc_oe <= '1'; 
                next_state <= STO1;

            when STO1 =>
                sela <= '1'; 
                rnw <= '0';
                acc_oe <= '1';
                next_state <= FETCH0;

           
            when ADD0 =>
                sela <= '1'; 
                rnw <= '1';
                next_state <= ADD1;

            when ADD1 =>
                sela <= '1'; 
                selb <= '1'; 
                alufs <= "0010";
                acc_ld <= '1';
                next_state <= ADD2;

            when ADD2 =>
                sela <= '1';
                acc_ld <= '1';
                next_state <= FETCH0;

            
            when SUB0 =>
                sela <= '1'; 
                rnw <= '1';
                next_state <= SUB1;

            when SUB1 =>
                sela <= '1';
                selb <= '1'; 
                alufs <= "0001";
                acc_ld <= '1';
                next_state <= SUB2;

            when SUB2 =>
                sela <= '1';
                acc_ld <= '1';
                next_state <= FETCH0;

           
            when JMP0 =>
                sela <= '1'; 
                selb <= '0'; 
                alufs <= "0000"; 
                pc_ld <= '1';
                next_state <= JMP1;

            when JMP1 =>
                sela <= '1'; 
                pc_ld <= '1';
                next_state <= FETCH0;

            
            when JGE0 =>
                if acc15 = '0' then
                    sela <= '1';
                    selb <= '0';
                    alufs <= "0000";
                    pc_ld <= '1';
                    next_state <= JGE1;
                else
                    next_state <= FETCH0;
                end if;

            when JGE1 =>
                sela <= '1';
                pc_ld <= '1';
                next_state <= FETCH0;

           
            when JNE0 =>
                if accz = '0' then
                    sela <= '1';
                    selb <= '0';
                    alufs <= "0000";
                    pc_ld <= '1';
                    next_state <= JNE1;
                else
                    next_state <= FETCH0;
                end if;

            when JNE1 =>
                sela <= '1';
                pc_ld <= '1';
                next_state <= FETCH0;

            when HALT =>
                next_state <= HALT;

            when others =>
                next_state <= FETCH0;
        end case;
    end process;

  
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= FETCH0;
            else
                state <= next_state;
            end if;
        end if;
    end process;
end Behavioral;
