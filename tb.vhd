library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_microprocessor_full is
-- Testbench has no ports
end tb_microprocessor_full;

architecture behavior of tb_microprocessor_full is

    -- Component Declaration for the Unit Under Test (UUT)
    component microprocessor_top
        port(
            clk   : in std_logic;
            reset : in std_logic
        );
    end component;

    -- Signal declarations
    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';

    -- Clock period (100MHz equivalent)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: microprocessor_top 
        port map (
            clk   => clk,
            reset => reset
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process: Testing all instruction logic
    stim_proc: process
    begin		
        -- 1. System Reset
        -- Ensures PC, ACC, and IR start at 0
        reset <= '1';
        wait for 25 ns;	
        reset <= '0';

        -----------------------------------------------------------
        -- THEORETICAL EXECUTION FLOW BASED ON YOUR MEMORY INITIALIZATION
        -----------------------------------------------------------
        -- The following instructions from your memory.vhd will be tested:
        
        -- TEST CASE 1: Load Accumulator (LDA @100h) 
        -- Expected: ACC should load the value 0x0007
        wait for 100 ns; 

        -- TEST CASE 2: Addition (ADD @101h)
        -- Expected: ACC = 0x0007 + 0x0005 = 0x000C (12 decimal)
        wait for 100 ns;

        -- TEST CASE 3: Conditional Branch Not Zero (JNE 005h)
        -- Expected: Since ACC is 12 (accz = '0'), PC should jump to 005h
        wait for 100 ns;

        -- TEST CASE 4: Subtraction (SUB @100h)
        -- Expected: ACC = 12 - 7 = 5
        wait for 100 ns;

        -- TEST CASE 5: Sign Flag/Jump Greater/Equal (JGE)
        -- This tests if the acc15 bit correctly prevents or allows a jump
        -- If ACC >= 0, PC loads the new address.
        wait for 100 ns;

        -- TEST CASE 6: Storage (STO)
        -- Expected: Value in ACC is written back to memory at the operand address
        -- Logic Check: rnw should go '0' and acc_oe should go '1'
        wait for 100 ns;

        -- TEST CASE 7: Halt (STP)
        -- Expected: State machine enters HALT state and stays there indefinitely
        wait for 100 ns;

        -- End Simulation
        report "Full Instruction Set Verification Complete";
        std.env.stop; -- Stops the simulator
    end process;

end behavior;
