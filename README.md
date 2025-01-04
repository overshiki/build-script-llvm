### build script for llvm-15.0.7

#### dependency
- cmake 3.31.0
- gcc 9.4.0

#### to use the script
firstly install `racket`, in ubuntu, just type 
```bash
sudo apt-get install racket
```

### llvm-15.0.0rc1
run 
```bash
racket build-llvm-15.rkt
```
`llvm` will be built into `llvm-15.0.7.src/build`

### llvm-19.1.6
run 
```bash
racket build-llvm-19.rkt
```
`llvm` wiil be built into `llvm-project-19.1.6.src/llvm/build`