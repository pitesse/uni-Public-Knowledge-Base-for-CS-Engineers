#lang racket
; We want to implement a for-each/cc procedure which takes a condition, a list and a body and performs a for-each.
; The main difference is that, when the condition holds for the current value, the continuation of the body is stored in
; a global queue of continuations. We also need an auxiliary procedure, called use-cc, which extracts and call the
; oldest stored continuation in the global queue, discarding it.

; E.g. if we run:
; (for-each/cc odd?
;              '(1 2 3 4)
;              (lambda (x) (displayln x)))
; two continuations corresponding to the values 1 and 3 will be stored in the global queue.

; Then, if we run: (use-cc), we will get on screen: 2 3 4

(define *q* '())

(define (enqueue! k)
  (set! *q* (append *q* (list k))))

(define (dequeue!)
  (and (pair? *q*)
       (let ((k (car *q*)))
         (set! *q* (cdr *q*))
         k)))

(define (use-cc)
  (let ((k (dequeue!)))
    (when k (k))))

(define (for-each/cc pred lst body)
  ;; Check if list is not empty (Racket specific: cons? is like pair?)
  (when (cons? lst)
    (let ((x (car lst)))
      (body x)
      (when (pred x)
        (call/cc (lambda (k) (enqueue! k)))
        )
      (for-each/cc pred (cdr lst) body))))

