#lang racket

; Exercise 1, Scheme (11 pts)
; 1. Design a construct to define multiple functions with the same number of arguments at the same time. The
; proposed syntax is the following:
; (multifun <list of function names> <list of parameters> <list of bodies>).
; E.g.
; (multifun (f g) (x)
;           ((+ x x x)
;            (* x x)))
; defines the two functions f with body (+ x x x) and g with body (* x x), respectively.
; 2. Would be possible to define something similar, but using a procedure and lambda functions instead of a
; macro? If yes, do it; if no, explain why.

(define-syntax multifun
  (syntax-rules ()
    ((_ (f) (x ...) (b))
     (define (f x ...) b))
    ((_ (f . fs) (x ...) (b . bs))
     (begin
       (define (f x ...) b)
       (multifun fs (x ...) bs)))))


; No, because arguments to a procedure are evaluated before the procedure is executed (call-by-value). 
; The function names would be unbound. Furthermore, procedures cannot introduce new bindings into the caller's 
; lexical scope; only macros can rewrite syntax to introduce define.