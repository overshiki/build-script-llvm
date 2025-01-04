#lang racket 

(provide join-pwd download-unpack)

(define (join-pwd file-or-dir)
  (string-append (path->string (current-directory)) file-or-dir)
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