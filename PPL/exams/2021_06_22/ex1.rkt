#lang racket

; Exercise 1, Scheme (10 pts)
; Define a function mix which takes a variable number of arguments x0 x1 x2 ... xn, the first one a function,
; and returns the list (x1 (x2 ... (x0(x1) x0(x2) ... x0(xn)) xn) xn-1) ... x1).
; E.g.
; (mix (lambda (x) (* x x)) 1 2 3 4 5)
; returns: '(1 (2 (3 (4 (5 (1 4 9 16 25) 5) 4) 3) 2) 1)

(define (mix f . rest)
  (let loop ((f f)
             (rest rest)
             (inner '()))
    (cond
      ((null? rest) (map f inner))
      ((null? f) '())
      ((procedure? f) (list (car rest) (loop f (cdr rest) (append inner (list (car rest)))) (car rest)))
      (else '())
      )
    )
  )

(mix (lambda (x) (* x x)) 1 2 3 4 5)


(define (mix2 g . L)
  (foldr (lambda (x y) (list x y x))
         (map g L) 
         L)        
  )

(mix2 (lambda (x) (* x x)) 1 2 3 4 5)
