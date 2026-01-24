#lang racket
; Exercise 1, Scheme (10 pts)
; We want to implement a version of call/cc, called store-cc, where the continuation is called only once and
; it is implicit, i.e. we do not need to pass a variable to the construct to store it. Instead, to run the
; continuation, we can use the associated construct run-cc (which may take parameters). The composition
; of store-cc must be managed using in the standard last-in-first-out approach.
; E.g. if we run:
; (define (test)
;   (define x 0)
;   (store-cc
;    (displayln "here")
;    (set! x (+ 1 x)))
;   (displayln x)
;   (set! x (+ 1 x))
;   x)
; (test)

; we will get:
; here
; 1
; 2
; and if we call (run-cc)
; we get:
; 2
; 3
; and the continuation is discarded.

(define *stored-cc* '())

(define-syntax _store-cc
  (syntax-rules ()
    ((_ expr ...)
     (call/cc
      (lambda (store)
        (set! *stored-cc* (cons store *stored-cc*))
        expr ...)))
    ))

(define (run-cc . v)
  (let ((k (car *stored-cc*)))
    (set! *stored-cc* (cdr *stored-cc*))
    (apply k v)))