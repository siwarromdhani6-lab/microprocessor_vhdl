# professor_safe_micro_vhdl

A simple 8-bit-opcode microprocessor implemented in structural VHDL, built as a course-style datapath + FSM design.

## Architecture

- **Data bus:** 16 bits
- **Address bus:** 12 bits
- **Instruction format:** 16 bits — `opcode(15..12)` + `address(11..0)`
- **Instruction set (8 instructions):** `LDA`, `STO`, `ADD`, `SUB`, `JMP`, `JGE`, `JNE`, `STP`

## Files

| File | Block |
|------|-------|
| `microprocessor_top.vhd` | Top-level structural entity wiring all components together |
| `state_machine.vhd` | Control unit — synchronous-reset FSM sequencing each instruction (fetch/decode/execute states per opcode) |
| `program_counter.vhd` | Program counter register |
| `instruction_register.vhd` | Instruction register — latches and splits opcode/address |
| `accumulator.vhd` | Accumulator register (holds ALU results, exposes zero/sign flags) |
| `alu.vhd` | Arithmetic logic unit |
| `memory.vhd` | Program/data memory, pre-initialized with a test program |
| `muxa.vhd`, `muxb.vhd` | Address-path multiplexers |
| `output_enable.vhd` | Output enable / tri-state control logic |
| `tb.vhd` | Testbench instantiating the full microprocessor and generating a clock for simulation |

## Design notes (from original author)

- Simple course-style coding: `entity`/`architecture`, components, `port map`, synchronous-reset FSM
- Memory is pre-initialized with the program specified in the assignment

## Simulating

Use any VHDL simulator (ModelSim, GHDL, Vivado xsim, etc.):

```
ghdl -a *.vhd
ghdl -e tb_microprocessor_full
ghdl -r tb_microprocessor_full --wave=wave.ghw
```

Then inspect `wave.ghw` in GTKWave (or your simulator's waveform viewer) to verify the instruction sequence executes as expected.
