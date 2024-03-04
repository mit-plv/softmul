## Running a sample program on a spike-simulated RISC-V machine without M extension

### Install spike:

```
cd some_scratch_directory
git clone git@github.com:riscv-software-src/riscv-isa-sim.git
# commmit hash: ec3c935
cd riscv-isa-sim
mkdir -p ~/installs/spike
mkdir build
cd build
../configure --prefix=~/installs/spike/
make
make install
export PATH=~/installs/spike/bin/:$PATH
```

### Running:

Note: The warning "tohost and fromhost symbols not in ELF; can't communicate with target" emitted by spike can safely be ignored, because we don't use the tohost/fromhost feature.
