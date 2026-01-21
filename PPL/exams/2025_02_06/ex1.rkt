#lang racket

; Exercise 1, Scheme (11 pts)
; Consider the named let construct of Scheme. Implement it as a nlet macro without using the built-in version of the
; construct.

(define-syntax nlet
  (syntax-rules ()
    ((_ loopFunc ((var value)...) body ... )
     (begin
       (define (loopFunc var ...)
         body ...)
       (loopFunc value ...)
       )
     )
    )
  )

; (define-syntax nlet
;   (syntax-rules ()
;     ((_ name ((x v) ...) body ...)
;      (letrec ((name (lambda (x ...) body ...))) ; 1. Create recursive function
;        (name v ...)))))                         ; 2. Call it