#lang racket

; Exercise 1, Scheme (11 pts)
; Define a new construct, called let-cond+, which works like a conditional let. The basic syntax is the following:
; (let-cond+ ((condition bindings then-part) …) else-part).
; Semantics:
; 1) The then-parts corresponding to all the conditions that are true are executed in sequence.
; 2) If all conditions are false, then the else-part is executed.
; 3) The returned value is the one of the last condition which is true, or the evaluation of the else-part.
; For example, the next code shows “hello” on the screen, and returns 7:

; (let-cond+
;  (((< 5 13) ; condition
;    ((a 10)) ; bindings
;    (begin (displayln "hello") a)) ; then-part
;   ((= 5 5) ; condition
;    ((b 3) ; bindings
;     (c 4))
;    (+ c b))) ; then-part
;  "all conditions false") ; else-part

(define-syntax _let-cond+
  (syntax-rules ()
    ((_ ((cond binding body) ...) else-part)
     (let ((any-true? #f)
           (result #f))
       (begin
         (if cond
             (begin
               (set! any-true? #t)
               (set! result (let binding body))
               )
             #f)
         ...)
       (if any-true?
           result
           else-part)))))