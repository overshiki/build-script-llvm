#lang racket
(require "local-lib.rkt")
; reference:
; - https://github.com/llvm/llvm-project/releases


(define (llvm-link) "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.6/llvm-project-19.1.6.src.tar.xz")
(define (llvm-file) 
  (join-pwd (fetch-file (llvm-link)))
)
(define (llvm-dir) 
  (join-pwd (fetch-dir (llvm-link)))
)


(define (get-llvm)
  (download-unpack (llvm-link) (llvm-file) (llvm-dir))
)

(define (build)
  (let 
    (
      (mkdir-cmd
        (string-append
          "mkdir -p "
          (string-append (llvm-dir) "/llvm" "/build")
          " && "
          "mkdir -p "
          (string-append (llvm-dir) "/llvm" "/install")
        )
      )
      (cd-cmd
        (string-append
          "cd " 
          (string-append (llvm-dir) "/llvm" "/build")
        )
      )
      (make-cmd 
      (string-append
        "cmake "
        (string-append (llvm-dir) "/llvm")
        " -DCMAKE_INSTALL_PREFIX="
        (string-append (llvm-dir) "/llvm" "/install")
        " -DCMAKE_BUILD_TYPE=Release"
        " -DLLVM_ENABLE_ASSERTIONS=ON"
        " -DLLVM_BUILD_LLVM_DYLIB=ON"
        " -DLLVM_LINK_LLVM_DYLIB=ON"
        " -DLLVM_INCLUDE_BENCHMARKS=OFF"
      ))
    )
    (system 
      (string-append
        mkdir-cmd
        " && "
        cd-cmd
        " && "
        make-cmd
        " && "
        "cmake --build ."
      )
    )
  )
)


(get-llvm)
(build)