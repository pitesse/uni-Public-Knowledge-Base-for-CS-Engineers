#lang racket

; Exercise 1, Scheme (11 pts)
; Consider the for with break as seen in class and reported here for your convenience:

; (define *exit-store* '())
; (define (break v) ((car *exit-store*) v))
; (define-syntax For
;   (syntax-rules (from to do)
;     ((_ var from min to max do body ...)
;      (let* ((min1 min)
;             (max1 max)
;             (inc (if (< min1 max1) + -)))
;        (let ((v (call/cc
;                  (lambda (k)
;                    (set! *exit-store* (cons k *exit-store*))
;                    (let loop ((var min1))
;                      body ...
;                      (unless (= var max1)
;                        (loop (inc var 1))))))))
;          (set! *exit-store* (cdr *exit-store*))
;          v)))))

; Define an extension of this construct, to be able to use in it also a continue command, with the same semantics as
; in C and Java, clearly explaining your idea.

(define *exit-store* '())
(define *continue-store* '())



(define (break v) ((car *exit-store*) v))
(define (continue c) ((car *continue-store*) c))

(define-syntax For
  (syntax-rules (from to do)
    ((_ var from min to max do body ...)
     (let* ((min1 min)ƒ
                      (max1 max)
                      (inc (if (< min1 max1) + -)))
       (let ((return (call/cc
                      (lambda (k)
                        (set! *exit-store* (cons k *exit-store*))
                        (let loop ((var min1))
                          (call/cc
                           (lambda (c)
                             (set! *continue-store* (cons c *continue-store*))
                             body ...))
                          (set! *continue-store* (cdr *continue-store*))
                          (unless (= var max1)
                            (loop (inc var 1)))

                          )))))
         (set! *exit-store* (cdr *exit-store*))
         return)
       )
     )
    )
  )