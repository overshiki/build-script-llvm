#lang racket
(require "local-lib.rkt")
; reference:
; - https://github.com/AccelerateHS/accelerate-llvm
; - https://github.com/llvm/llvm-project/issues/53281


(define (cmake-utils-link) "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.0-rc1/cmake-15.0.0rc1.src.tar.xz")
(define (cmake-utils-file) 
  (let 
    ((file "cmake-15.0.0rc1.src.tar.xz"))
    (join-pwd file)  
  )
)
(define (cmake-utils-dir) 
  (let 
    ((dir "cmake-15.0.0rc1.src"))
    (join-pwd dir)
  )
)

(define (llvm-link) "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/llvm-15.0.7.src.tar.xz")
(define (llvm-file) 
  (join-pwd (fetch-file (llvm-link)))
)
(define (llvm-dir) 
  (join-pwd (fetch-dir (llvm-link)))
)

(define (get-llvm)
  (download-unpack (llvm-link) (llvm-file) (llvm-dir))
  (download-unpack (cmake-utils-link) (cmake-utils-file) (cmake-utils-dir))
)

(define (cmake-utils-list)
  (directory-list (string-append (cmake-utils-dir) "/Modules"))
)
(define (safe-copy-file file-name source target)
  (let 
    (
      (source-file (string-append source "/" file-name))
      (target-file (string-append target "/" file-name))
    )
    (if (file-exists? target-file)
      '()
      (copy-file source-file target-file)
    )
  )
)

(define (copy-cmake-utls)
  (map 
    (lambda (file-path)
      (let ((file-name (path->string file-path)))
        (safe-copy-file file-name 
          (string-append (cmake-utils-dir) "/Modules") 
          (string-append (llvm-dir) "/cmake/modules"))
      )
    )
    (cmake-utils-list)
  )
)

(define (build)
  (let 
    (
      (mkdir-cmd
        (string-append
          "mkdir -p "
          (string-append (llvm-dir) "/build")
          " && "
          "mkdir -p "
          (string-append (llvm-dir) "/install")
        )
      )
      (cd-cmd
        (string-append
          "cd " 
          (string-append (llvm-dir) "/build")
        )
      )
      (make-cmd 
      (string-append
        "cmake "
        (llvm-dir)
        " -DCMAKE_INSTALL_PREFIX="
        (string-append (llvm-dir) "/install")
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
(copy-cmake-utls)
(build)