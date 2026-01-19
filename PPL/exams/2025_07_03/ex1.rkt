#lang racket

; Exercise 1, Scheme
; Define a function which takes a list (containing lists of any depth),
; and checks if every list and sub-list contains its
; own length. E.g. (contains-length? '(3 (2 3) (2 (1 2)))) should return #t,
; while (contains-length? '(3 1 (2 3) (1 (2)))) is #f.

; (define (contains-length? l)
;   (and (list? l) 
;        (member (length l) l)
;        (all? contains-length? (filter list? l))))

; (define (all? pred lst)
;   (null? (filter (lambda (x)
;                    (not (pred x))) lst)))

(define (contains-length? l)
  (cond
    ;; 1. Base Case: Not a list -> Valid
    ((not (list? l)) #t)
    
    ;; 2. Check Property: Must contain its own length
    ((not (member (length l) l)) #f)
    
    ;; 3. Check Children: Manually loop through the list
    (else
      (let loop ((rest l))
        (cond
          ((null? rest) #t)                       ; End of list? All good.
          ((not (contains-length? (car rest))) #f) ; Child failed? Fail whole thing.
          (else (loop (cdr rest))))))))           ; Child passed? Check next.

(contains-length? '(3 (2 3) (2 (1 2))))
(contains-length? '(3 1 (2 3) (1 (2))))