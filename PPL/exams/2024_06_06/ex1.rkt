#lang racket

; Exercise 1, Scheme (10 pts)
; Define a new construct, called let-cond, which works like a conditional let. The basic syntax is like:
; (let-cond ((condition bindings then-part) …) else-part), where the semantics is the following:
; 1) The then-part corresponding to the first condition that is true is executed. No other code is executed in the
; construct.
; 2) If all conditions are false, the else-part is executed.
; For example:
; (let-cond
;  [((> 5 13)
;    [(a 10) (b 20)]
;    (+ a b)) ; then-body 1
;   ((= 5 5)
;    [(c 3) (d 4)]
;    (+ c d))] ; then-body 2
;  "all conditions false")) ; else-body
; should return 7.

(define-syntax let-cond
  (syntax-rules ()
    ((_ ((condition bindings then-body) ...)
        else-body)
     (cond
       (condition (let bindings then-body))
       ...
       (else else-body)))))