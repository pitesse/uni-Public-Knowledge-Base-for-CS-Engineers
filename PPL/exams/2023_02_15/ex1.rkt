#lang racket

; Exercise 1, Scheme (10 pts)
; Write a function, called fold-left-right, that computes both fold-left and fold-right, returning them in a pair. Very
; important: the implementation must be one-pass, for efficiency reasons, i.e. it must consider each element of the
; input list only once; hence it is not correct to just call Scheme’s fold-left and -right.
; Example: (fold-left-right string-append "" '("a" "b" "c")) is the pair ("cba" . "abc").

(define (_fold-left-right f initial lst)
  ;; recur takes the list AND the current Left Accumulator
  (define  (recur remaining l-acc)
    (if (null? remaining)
        (cons l-acc initial)
        (let* ((x (car remaining))
               (next-l-acc (f x l-acc))
               (result-pair (recur (cdr remaining) next-l-acc))
               (final-left (car result-pair))
               (right-from-rest (cdr result-pair)))
          (cons final-left (f x right-from-rest)))
        ))
  (recur lst initial))