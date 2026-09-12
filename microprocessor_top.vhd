library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity microprocessor_top is
    port(
        clk   : in std_logic;
        reset : in std_logic
    );
end microprocessor_top;

architecture structural of microprocessor_top is
    component state_machine
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
    end component;

    component program_counter
        port(
            clk           : in  std_logic;
            reset         : in  std_logic;
            pc_ld         : in  std_logic;
            adress_in_alu : in  std_logic_vector(15 downto 0);
            adress_out_pc : out std_logic_vector(11 downto 0)
        );
    end component;

    component instruction_register
        port(
            clk              : in  std_logic;
            reset            : in  std_logic;
            adress_in_memory : in  std_logic_vector(15 downto 0);
            ir_ld            : in  std_logic;
            adress_out_ir    : out std_logic_vector(11 downto 0);
            opcode           : out std_logic_vector(3 downto 0)
        );
    end component;

    component accumulator
        port(
            clk            : in  std_logic;
            reset          : in  std_logic;
            acc_ld         : in  std_logic;
            operand_in_alu : in  std_logic_vector(15 downto 0);
            acc_z          : out std_logic;
            acc_15         : out std_logic;
            result_out_acc : out std_logic_vector(15 downto 0)
        );
    end component;

    component muxa
        port(
            adress_in_pc : in  std_logic_vector(11 downto 0);
            adress_in_ir : in  std_logic_vector(11 downto 0);
            selA         : in  std_logic;
            adress_out_a : out std_logic_vector(11 downto 0)
        );
    end component;

    component muxb
        port(
            adress_in_muxa   : in  std_logic_vector(11 downto 0);
            adress_in_memory : in  std_logic_vector(15 downto 0);
            selB             : in  std_logic;
            adress_out_b     : out std_logic_vector(15 downto 0)
        );
    end component;

    component alu
        port(
            alufs          : in  std_logic_vector(3 downto 0);
            adress_in_muxb : in  std_logic_vector(15 downto 0);
            adress_in_acc  : in  std_logic_vector(15 downto 0);
            adress_out_alu : out std_logic_vector(15 downto 0)
        );
    end component;

    component output_enable
        port(
            i      : in  std_logic_vector(15 downto 0);
            acc_oe : in  std_logic;
            result : out std_logic_vector(15 downto 0)
        );
    end component;

    component memory
        port(
            addr_in_muxa    : in    std_logic_vector(11 downto 0);
            rnw             : in    std_logic;
            data_out_memory : inout std_logic_vector(15 downto 0)
        );
    end component;

    signal rnw, sela, selb, pc_ld, ir_ld, acc_ld, acc_oe : std_logic;
    signal alufs : std_logic_vector(3 downto 0);

    signal opcode : std_logic_vector(3 downto 0);
    signal accz, acc15 : std_logic;

    signal pc_out   : std_logic_vector(11 downto 0);
    signal ir_addr  : std_logic_vector(11 downto 0);
    signal muxa_out : std_logic_vector(11 downto 0);

    signal acc_out  : std_logic_vector(15 downto 0);
    signal muxb_out : std_logic_vector(15 downto 0);
    signal alu_out  : std_logic_vector(15 downto 0);

    signal data_bus : std_logic_vector(15 downto 0);
begin
    UCTRL : state_machine
        port map(
            opcode => opcode,
            accz   => accz,
            acc15  => acc15,
            clk    => clk,
            reset  => reset,
            rnw    => rnw,
            sela   => sela,
            selb   => selb,
            pc_ld  => pc_ld,
            ir_ld  => ir_ld,
            acc_ld => acc_ld,
            acc_oe => acc_oe,
            alufs  => alufs
        );

    UPC : program_counter
        port map(
            clk           => clk,
            reset         => reset,
            pc_ld         => pc_ld,
            adress_in_alu => alu_out,
            adress_out_pc => pc_out
        );

    UIR : instruction_register
        port map(
            clk              => clk,
            reset            => reset,
            adress_in_memory => data_bus,
            ir_ld            => ir_ld,
            adress_out_ir    => ir_addr,
            opcode           => opcode
        );

    UACC : accumulator
        port map(
            clk            => clk,
            reset          => reset,
            acc_ld         => acc_ld,
            operand_in_alu => alu_out,
            acc_z          => accz,
            acc_15         => acc15,
            result_out_acc => acc_out
        );

    UMUXA : muxa
        port map(
            adress_in_pc => pc_out,
            adress_in_ir => ir_addr,
            selA         => sela,
            adress_out_a => muxa_out
        );

    UMUXB : muxb
        port map(
            adress_in_muxa   => muxa_out,
            adress_in_memory => data_bus,
            selB             => selb,
            adress_out_b     => muxb_out
        );

    UALU : alu
        port map(
            alufs          => alufs,
            adress_in_muxb => muxb_out,
            adress_in_acc  => acc_out,
            adress_out_alu => alu_out
        );

    UOE : output_enable
        port map(
            i      => acc_out,
            acc_oe => acc_oe,
            result => data_bus
        );

    UMEM : memory
        port map(
            addr_in_muxa    => muxa_out,
            rnw             => rnw,
            data_out_memory => data_bus
        );
end structural;
