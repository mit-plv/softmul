# Softmul: Verifying Software Emulation of an Unsupported Hardware Instruction

Proving that a system with software trap handlers for unimplemented instructions behaves as if they were implemented in hardware.


### Building

We use Coq 8.18.0.
If you obtained the code through git, make sure you also recursively cloned the submodules.
In the toplevel directory, run `make`, or to get some parallelism, `make -j4`.
Warning: With too much parallelism (eg `-j8` or unrestricted `-j`), you can run out memory. On a lightly-loaded system with 16GB of RAM, `make -j4` should be safe.

To run the example in the `run` directory, you also need
* Spike(https://github.com/riscv-software-src/riscv-isa-sim). We use version 1.1.1-dev as of commit ec3c9357ec58bdd2522eef3d7768b9276ab96b0c, but other versions probably work too. See also the README in the `run` directory.
* To compile the unverified user program and compose the ELF, you need the GNU RISC-V toolchain. On Ubuntu, it can be installed with `sudo apt install gcc-riscv64-unknown-elf`.

The toplevel `make` invokes all required compilation as well as the spike simulation in the `run` subdirectory, which first runs our system with a simple `factorial(5)` program with the `M` extension enabled, and then with the `M` extension disabled, so that our exception handler gets used.
Both runs print the result (which should be `0x00000078`), followed by the CSR `minstret`, the number of retired instructions, which should be `0x00000057` in the first run where multiplication is implemented in (spike-simulated) "hardware", and considerably higher, `0x00000313`, in the second run where multiplication is implemented by our trap handler.


### Code Reading Guide

The riscv-coq specification is at `bedrock2/deps/riscv-coq/`.
It was generated by `hs-to-coq` from the [riscv-semantics in Haskell](https://github.com/mit-plv/riscv-semantics).
The `hs-to-coq`-generated Coq code is easier to read when pretty-printed by Coq.
To do so, at the end of eg `src/softmul/SoftmulTop.v`, insert and run

```
Import riscv.Utility.MonadNotations.
Print riscv.Spec.ExecuteI.execute.
Print riscv.Spec.ExecuteM.execute.
```

to see how execution of instructions from the I and M extension are specified.

For more details about the formal RISC-V specification, we refer to the [reading guide of riscv-semantics](https://github.com/mit-plv/riscv-semantics/blob/master/READING.md) and the [ICFP'23 paper](https://doi.org/10.1145/3607833).

The abstract primitives (such as `getRegister`, `setRegister`, `loadByte` etc) are *declared* in `bedrock2/deps/riscv-coq/src/riscv/Spec/Machine.v`, and *implemented* in `bedrock2/deps/riscv-coq/src/riscv/Platform/MinimalCSRs.v`: This is the definition we use in the toplevel theorem, with two different decoders (`idecode` and `mdecode`).

The bedrock2 compiler is proven correct against an axiomatization of the abstract primitives (such as `getRegister`, `setRegister`, `loadByte` etc), see `bedrock2/deps/riscv-coq/src/riscv/Spec/Primitives.v`, and uses `MetricRiscvMachine` (from `bedrock2/deps/riscv-coq/src/riscv/Platform/MetricRiscvMachine.v`) as the state representation, whereas the toplevel theorem uses `State` (from `bedrock2/deps/riscv-coq/src/riscv/Platform/MinimalCSRs.v`) as its state representation.
Moreover, the compiled exception handler code runs on a machine (`MinimalCSRs`) that invokes the exception handler when encountering a `mul` instruction, but if we are already in the handler, we must not use the `mul` instruction any more, to avoid entering the handler recursively infinitely many times.
For these two reasons, as a proof strategy (which does not show up in the toplevel *statement*), we use an additional instantiation of the RISC-V semantics which supports executing `M` and `I` instructions, but maintains the invariant `no_M`, saying that no instructions in the executable memory are `M` instructions.
This additional instantiation is defined in `src/softmul/MinimalNoMul.v` and `src/softmul/MetricMinimalNoMul.v`.

On top of the riscv-coq specification, our project adds the following components:

* Trap handler in assembly: `src/softmul/Softmul.v`
* Instruction decoder in Bedrock2: `src/softmul/SoftmulBedrock2.v`
* Multiplication in Bedrock2 (copied from Bedrock2 examples): `src/softmul/rpmul.v`
* Compiler compat & invocation `src/softmul/SoftmulCompile.v`
* Toplevel theorem: `src/softmul/SoftmulTop.v`


### Checking the line number counts

The lines of code numbers in the paper can be reproduced as follows.
First, note that `loc/all-files.txt` assigns a category to each file.
To check that we did not miss any file, run

```
loc/completenesscheck.sh
```

whose output should be empty (it lists all .v files that recursive `find` finds in `src` but are not listed in `loc/all-files.txt`).
Then, run

```
python3 loc/allcount.py < loc/all-files.txt
```

which parses the annotations like eg `(*tag:proof*)` or `(*tag:obvious*)`, and whenever it encounters such a tag, it changes the line counter to be incremented.
It outputs LaTeX code for the table that appears in the paper.
