#lang racket

; reference:
; - https://github.com/llvm/llvm-project/releases


(define (join-pwd file-or-dir)
  (string-append (path->string (current-directory)) file-or-dir)
)

(define (llvm-link) "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.6/llvm-project-19.1.6.src.tar.xz")
(define (llvm-file) 
  (let ((file "llvm-project-19.1.6.src.tar.xz"))
    (join-pwd file)
  )
)
(define (llvm-dir) 
  (let ((dir "llvm-project-19.1.6.src"))
    (join-pwd dir)
  )
)

(define (download-unpack zip-link zip-file dir)
  (if (file-exists? zip-file)
    '()
    (system (string-append "wget " zip-link))
  )
  (if (directory-exists? dir)
    '()
    (system (string-append "tar xf " zip-file))
  )
)

(define (get-llvm)
  (download-unpack (llvm-link) (llvm-file) (llvm-dir))
  ; (download-unpack (cmake-utils-link) (cmake-utils-file) (cmake-utils-dir))
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