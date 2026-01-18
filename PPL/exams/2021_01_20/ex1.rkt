#lang racket

; Define a pure function (i.e. without using procedures with side effects, such as set!)
; which takes a multi-level list, i.e. a list that may contain any level of lists, and converts
; it into a data structure where each list is converted into a vector.




; E.g.
; The result of (multi-list->vector '(1 2 (3 4) (5 (6)) "hi" ((3) 4))))
; should be: '#(1 2 #(3 4) #(5 #(6)) "hi" #(#(3) 4))

(define (multi-list->vector x)
  (cond
    ((not (list? x)) x)
    (else
     (apply vector
            (map multi-list->vector x))
     )
    )
  )

(multi-list->vector '(1 2 (3 4) (5 (6)) "hi" ((3) 4)))