#lang racket

; Exercise 1, Scheme (10 pts)
; Define a new construct called block-then which creates two scopes for variables, declared after the
; scopes, with two different binding. E.g. the evaluation of the following code:
; (block
;  ((displayln (+ x y))
;   (displayln (* x y))
;   (displayln (* z z)))
;  then
;  ((displayln (+ x y))
;   (displayln (* z x)))
;  where (x <- 12 3)(y <- 8 7)(z <- 3 2))
; should show on the screen:
; 20
; 96
; 9
; 10
; 6

(define-syntax _block
  (syntax-rules (where then <-)
    ((_ (e1 ...) then (e2 ...) where (v <- a b) ...)
     (begin
       (let ((v a) ...)
         e1 ...)
       (let ((v b) ...)
         e2 ...)))))