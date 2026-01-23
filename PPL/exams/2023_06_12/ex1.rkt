#lang racket

; Exercise 1, Scheme (10 pts)
; Consider the following For construct, as defined in class:
; (define-syntax For
;   (syntax-rules (from to break: do)
;     ((_ var from min to max break: break-sym
;         do body ...)
;      (let* ((min1 min)
;             (max1 max)
;             (inc (if (< min1 max1) + -)))
;        (call/cc (lambda (break-sym)
;                   (let loop ((var min1))
;                     body ...
;                     (unless (= var max1)
;                       (loop (inc var 1))))))))))
; Define a fix to the above definition, to avoid to introduce in the macro definition the special break symbol break-
; sym, by providing a construct called break. E.g.
; (For i from 1 to 10
;      do
;      (displayln i)
;      (when (= i 5)
;        (break #t)))
; will return #t after displaying the numbers from 1 to 5.

;; Global stacks for break/continue
(define *break-stack* '())

(define (_break) ((car *break-stack*)))

(define-syntax _For
  (syntax-rules (from to do)
    ((_ var from min to max do body ...)
     (let* ((min1 min) (max1 max)
                       (inc (if (< min1 max1) + -)))
       (let ((return-value
              (call/cc
               (lambda (break-k)
                 (set! *break-stack* (cons break-k *break-stack*))
                 (let loop ((var min1))
                   body ...
                   (unless (= var max1)
                     (loop (inc var 1))))))))

         ;; 4. Cleanup Stack (Happens on both normal exit AND break)
         (set! *break-stack* (cdr *break-stack*))

         ;; 5. Return the captured result
         return-value)))))
;; Variant: break-only → remove continue-stack lines
;; Variant: return value → wrap call/cc result in let, return after pop