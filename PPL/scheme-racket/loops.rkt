#lang racket

; ----------------------------------------------------------------

; RECURSIVE LOOPS (Non-tail recursive)
; This version builds up a chain of deferred operations
; Each recursive call must wait for the result of the next call
; before it can complete its multiplication
(define (factorial n)
  (if (zero? n)
      1
      (* n (factorial (sub1 n)))))  ; Multiplication happens AFTER recursive call returns

; Call stack grows: (* 5 (* 4 (* 3 (* 2 (* 1 1)))))
; Memory usage: O(n) - each call frame stays on the stack
(displayln "recursive") ; => 120
(factorial 5) ; => 120
(displayln "----")

; ----------------------------------------------------------------

; TAIL RECURSIVE LOOPS
; This version uses an accumulator to carry the result forward
; Each recursive call is the LAST operation (tail position)
; No deferred operations - stack frames can be reused
(define (factorial-tail n)
  (define (fact-iter n acc)
    (if (zero? n)
        acc                          ; Return accumulator directly
        (fact-iter (sub1 n) (* n acc))))  ; Recursive call is the LAST operation
  (fact-iter n 1))  ; Start with accumulator = 1

; Inner helper function for tail recursion, can also be defined separately as below:
; defined to show the trace more clearly
(define (fact-iter n acc)
  (if (zero? n)
      acc                          ; Return accumulator directly
      (fact-iter (sub1 n) (* n acc))))  ; Recursive call is the LAST operation

; No growing call stack - each call can replace the previous one
; Memory usage: O(1) - constant space
; Execution: iter(5,1) -> iter(4,5) -> iter(3,20) -> iter(2,60) -> iter(1,120) -> 120
(displayln "tail recursive")
(factorial-tail 5) ; => 120
(displayln "----")

; ----------------------------------------------------------------

; Tracing function calls to visualize recursion

(require racket/trace)

(trace factorial)
(trace factorial-tail)
(trace fact-iter)

(displayln "tracing recursive factorial")
(factorial 5)       ; Trace output shows growing call stack
(displayln "----")
(displayln "tracing tail recursive factorial")
(factorial-tail 5)  ; Trace output shows constant stack depth
(displayln "----")
(displayln "direct call to inner tail-recursive function")
(fact-iter 5 1)    ; Direct call to inner function to see tail recursion
(displayln "----")

; ----------------------------------------------------------------

; Tail Recursion with named let
; Named let creates a local recursive function with its own parameters
; This version is also tail-recursive
(define (factorial-2 n)
  (let factorial-loop ([curr n] [acc 1])
    (trace factorial-loop)
    (if (zero? curr)
        acc
        (factorial-loop (sub1 curr) (* curr acc)))))

(displayln "let tail recursive factorial")
(factorial-2 5) ; => 120
(displayln "----")

;------------------------------------------------------------------

