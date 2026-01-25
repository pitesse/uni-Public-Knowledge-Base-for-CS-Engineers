#lang racket

; Exercise 1, Scheme (13 pts)
; 1)  Define a procedure which takes a natural number n and a default value, and creates a n by n matrix
;     filled with the default value, implemented through vectors (i.e. a vector of vectors).
; 2)  Let S = {0, 1, ..., n-1} x {0, 1, ..., n-1} for a natural number n. Consider a n by n matrix M, stored in a
;     vector of vectors, containing pairs (x,y) ∈ S, as a function from S to S (e.g. f(2,3) = (1,0) is represented
;     by M[2][3] = (1,0)). Define a procedure to check if M defines a bijection (i.e. a function that is both
;     injective and surjective).

(define (create-matrix size default)
  (define vec (make-vector size #f))
  (let loop ((i 0))
    (if (= i size)
        vec
        (begin
          (vector-set! vec i (make-vector size default))
          (loop (+ 1 i))))))
          
(define (bijection? m)
  (define size (vector-length m))
  (define seen? (create-matrix size #f))
  (call/cc (lambda (exit)
             (let loop ((i 0))
               (when (< i size)
                 (let loop1 ((j 0))
                   (when (< j size)
                     (let ((datum (vector-ref (vector-ref m i) j)))
                       (if (vector-ref (vector-ref seen? (car datum)) (cdr datum))
                           (exit #f)
                           (vector-set! (vector-ref seen? (car datum)) (cdr datum) #t)))
                     (loop1 (+ 1 j))))
                 (loop (+ 1 i))))
             #t)))