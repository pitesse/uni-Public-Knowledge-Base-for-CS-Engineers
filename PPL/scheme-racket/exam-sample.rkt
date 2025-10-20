#lang racket

;; Consider the named let construct of Scheme
;;
;; Implement it as a nlet macro without using the built-in version
;; of the construct.

;; (let loop        -> NO
;; (let ([ x 5 ]))  -> OK


;; nlet: a simple reimplementation of Scheme's named-let.
;; Usage: (nlet name ([var init] ...) body ...)
;; Expands to:
;;  1. create a temporary binding 'name' (initially #f) so the lambda can refer to it
;;  2. bind the variables to their initial values
;;  3. set! 'name' to a lambda that takes the same vars as parameters and runs body...
;;     (this lambda is what allows recursive calls like (name ...) inside body)
;;  4. immediately invoke (name var ...) with the initial values to start the loop/recursion
;;
;; In short: it builds a self-referential lambda using set! so the body can call
;; `name` recursively, and then invokes it with the initial bindings — exactly like
;; a named let.
(define-syntax nlet
  (syntax-rules ()
    [(_ name ([var value] ...) body ...)
     (let ([name #f]
           [var value] ... )
       (set! name
             (lambda (var ...)
               body ...))
       (name var ...))]))

; test

(nlet loop ([x 5])
  (when (> x 0)
    (displayln x)
    (loop (- x 1))))