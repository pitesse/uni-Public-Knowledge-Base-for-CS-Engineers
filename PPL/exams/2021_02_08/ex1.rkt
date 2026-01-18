#lang racket

; Ex 1
; SCHEME:
; Write a function 'depth-encode' that takes in input a list possibly containing
; other lists at multiple nesting levels, and returns it as a flat list where
; each element is paired with its nesting level in the original list.

; E.g. (depth-encode '(1 (2 3) 4 (((5) 6 (7)) 8) 9 (((10)))))
; returns
; ((0 . 1) (1 . 2) (1 . 3) (0 . 4) (3 . 5) (2 . 6) (3 . 7) (1 . 8) (0 . 9) (3 . 10))

; (define (depth-encode lst)
;   (define (helper x current-depth)
;     (cond
;       ((null? x) '())

;       ((list? (car x))
;        (append
;         (helper (car x) (+ current-depth 1))
;         (helper (cdr x) current-depth)))

;       (else
;        (cons
;         (cons current-depth (car x))
;         (helper (cdr x) current-depth)))))
;   (helper lst 0))

(define (depth-encode lst)
  (let recur ((x lst) 
              (depth 0)) 
    (cond
      ((null? x) '())

      ((list? (car x))
       (append
        (recur (car x) (+ depth 1))
        (recur (cdr x) depth)))

      (else
       (cons
        (cons depth (car x))
        (recur (cdr x) depth))))))

; (define (depth-encode ls)
;   (define (helper l)
;     (cond ((null? l) '())
;           ((list? (car l))
;            (append (map (λ (pair) (cons (+ (pair nx) 1) (cdr pair)))
;                         (helper (car l));this is the pair to apply the lambda on -- increment the first value
;                         ) 
;                    (helper (cdr l))))
;            (else (cons (cons 0 (car l)) (helper (cdr l))))))
;   (helper ls))

(depth-encode '(1 (2 3) 4 (((5) 6 (7)) 8) 9 (((10)))))
