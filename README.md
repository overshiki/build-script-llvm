### build script for llvm-15.0.7

#### dependency
- cmake 3.31.0
- gcc 9.4.0

#### to use the script
firstly install `racket`, in ubuntu, just type 
```bash
sudo apt-get install racket
```

then, run 
```bash
racket build.rkt
```

`llvm` will be built into `llvm-15.0.7.src/build`