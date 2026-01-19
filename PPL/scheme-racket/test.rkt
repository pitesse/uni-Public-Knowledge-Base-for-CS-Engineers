#lang racket


(displayln "variable scoping with let and letrec:")
(letrec ((a 1))
  (let ((f (lambda () (display a) (newline)))) ; this display still refers to the first a
    (let ((a 2))
      (f))
    (f)))

(define (factorial n)
  (if (= n 0)
      1
      (* n (factorial (- n 1)))))

(define (fact x)
  (define (fact-tail x accum) ; local proc
    (if (= x 0)
        accum
        (fact-tail (- x 1) (* x accum))))
  (fact-tail x 1))

(newline)
(displayln "Factorials:" )
(displayln (factorial 5))
(displayln  (fact 5))

(newline)
(displayln "named let loop:")
(let label ((x 0))
  (when (< x 10)
    (display x)
    (newline)
    (label (+ x 1)))) ; x++

; (define (test-setting-local d)
;   (set! d "Local")           ; modifies local reference
;   (display d))               ; => Local

; (define ob "Global")
; (test-setting-local ob)      ; => Local
; (display ob)                 ; => Global (unchanged)

; (define (set-my-mutable d)
;   (vector-set! d 1 "done")   ; modifies the object itself
;   (display d))

; (define ob1 (vector 1 2 3))  ; => #(1 2 3)
; (set-my-mutable ob1)         ; => #(1 done 3)
; (display ob1)                ; => #(1 done 3) (changed!)

(newline)
(displayln "Macros with let and display:")

(define-syntax my-let-display
  (syntax-rules ()
    ((_ ((var expr) ...) body ...)
     ((lambda (var ...)
        (begin
          (for-each
           (lambda (result)
             (display result)
             (newline))
           (list body ...))))
      expr ...))))

(my-let-display ((x 1) (y 2) (z 3))
                (+ x y z) (- x y z)); => 6

(newline)
(displayln "continuations:")

(define saved-cont #f)  ; Storage for continuation

(define (test-cont)
  (let ((x 0))
    (call/cc
     (lambda (k)           ; k contains the continuation
       (set! saved-cont k)
       (set! x (+ x 1)))) ; Save the continuation globally and add one
    ; THIS IS THE CONTINUATION POIN, when called it resumes from here, after call/cc
    (set! x (+ x 1))
    (display x)
    (newline)))

(test-cont)           ; => 2
(saved-cont)          ; => 3
(saved-cont)          ; => 4
(define other-cont saved-cont)
(test-cont)           ; => 2 (resets saved-cont to one)
(other-cont)          ; => 5 (other-cont still active!)
(saved-cont)          ; => 3

(newline)
(displayln "For and break with macros and continuations:")

(define *exit-store* '())  ; Stack of exit continuations

(define (break)
  ((car *exit-store*)))  ; Call most recent exit continuation

(define-syntax For
  (syntax-rules (from to do)
    ((_ var from min to max do body ...)
     (let* ((min1 min)
            (max1 max)
            (inc (if (< min1 max1) + -)))
       (call/cc
        (lambda (k)
          (set! *exit-store* (cons k *exit-store*)) ; Push exit continuation onto stack
          (let loop ((var min1))
            body ...
            (unless (= var max1)
              (loop (inc var 1))))))
       (set! *exit-store* (cdr *exit-store*)) ; Pop exit continuation from stack
       )
     )
    )
  )

(For i from 1 to 10
     do
     (displayln i)
     (when (= i 5)
       (break)))
