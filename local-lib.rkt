#lang racket 
(provide (all-defined-out))

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

(define (init alist)
  (match alist
    ((cons x y) 
        (match y
          ((cons i j) (cons x (init y)))
          ('() '())
        )
    )
    ('() '())
  )
)

(define (last alist)
  (match alist
    ((cons x y)
      (match y
        ((cons i j) (last y))
        ('() x)
      )
    )
    ('() '())
  )
)

(define (back-sep sep slist)
  (let 
    (
      (contents (init (string-split slist sep)))
      (string-sep-append (lambda (x y) (string-append x sep y)))
    )
    (foldr string-sep-append (last contents) (init contents))
  )
)

(define (fetch-file alink)
  (last (string-split alink "/"))
)

(define (fetch-dir alink)
  (back-sep "."
    (back-sep "." 
      (fetch-file alink)    
    )
  )
)