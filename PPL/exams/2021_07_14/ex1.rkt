#lang racket

; Exercise 1, Scheme (11 pts)
; Define a defun construct like in Common Lisp, where (defun f (x1 x2 ...) body) is used for defining a
; function f with parameters x1 x2 ....
; Every function defined in this way should also be able to return a value x by calling (ret x).

(define ret-store '())

(define (ret v)
  ((car ret-store) v))

(define-syntax defun
  (syntax-rules ()
    ((_ fname (var ...) body ...)
     (define (fname var ...)
       (let ((out (call/cc (lambda (c)
                             (set! ret-store (cons c ret-store))
                             body ...))))
         (set! ret-store (cdr ret-store))
         out)))))