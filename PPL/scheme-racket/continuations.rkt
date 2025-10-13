#lang racket

;; CALL/CC
; kinda like time-travel
; we're simply going back (or forward*) to a saved call stack.

(define (now)
  (call/cc
   (λ (k) ; 'k' is the continuation
     (k "Hey!"))))
(displayln "== NOW ==")
(now) ; => Hey!
;; Is calling 'k' just like using 'return'? Absolutely not! In fact, we're never
;; returning from the call (k "Hey!").

;; A simple example:
(+ 1 (call/cc (λ (k) (k 2))))
;    ^ call/cc saves this "return point"! It's a place we can go back to later.
;      Where does it save it? Into 'k'!
;      When we call (k ...) we're going back at
;      that point in time and put the arg of 'k'
;      in its place.
;      so... (+ 1 2)

(define (list-fruits)
  (call/cc
   (λ (k)
     (displayln "apple")
     (k "banana")
     "carrot"))) ; we don't reach this point because we called 'k' before it.

(displayln "== FRUITS ==")
(list-fruits) ; => apple, banana

;; Does calling a continuation affect other values?
(displayln "== FOO ==")

(define foo-k #f) ; continuation

(define (foo)
  (let ([i 0])
    (displayln i)
    (call/cc (λ (k)
               (set! i 3)
               (displayln i) ; => 3
               (set! foo-k k)
               (set! i 5)
               (displayln i) ; => 5
               (foo-k)))
    (displayln i))) ; => 5

(foo) ;; => 0, 3, 5, 5

;; Can you guess what these return?
(displayln "== GUESS ==")
;; 1
(call/cc (λ (k0)
           (+ 1 (call/cc (λ (k1)
                           (+ 1 (k0 3))))))) 
;; explanation:
;; 1. k0 captures the continuation: "take result and return from outer call/cc"
;; 2. k1 captures the continuation: "take result, add 1, then add 1 to that, then return from outer call/cc"
;; 3. When we call (k0 3), we JUMP directly to k0's continuation
;; 4. This means we SKIP the (+ 1 ...) that wraps the inner call/cc
;; 5. We return 3 directly from the OUTER call/cc
;; 6. Result: 3 (NOT 4, because we never execute the outer + 1)

;; why not 4?
;; The outer (+ 1 ...) is part of k1's continuation, NOT k0's continuation
;; When we call k0, we abandon k1's continuation entirely
;; Think of it as: k0 = "return X from outer call/cc"
;;                 k1 = "return (+ 1 (+ 1 X)) from outer call/cc"
;; Since we call k0, we use k0's simpler continuation

;; 2
(call/cc (λ (k0)
           (+ 1 (call/cc (λ (k1)
                           (+ 1 (k0 (k1 3))))))))

;; 3
(call/cc (λ (k0)
           (+ 1
              (call/cc (λ (k1)
                         (+ 1 (k1 3))))
              (k0 1))))

;; SOLUTIONS
;; 1 => 3
;; 2 => 4
;; 3 => 1

(displayln "== IT GETS WORSE ==")

;; It get worse...
(define x 0)

(let ([cc (call/cc (λ (k) (k k)))])
  (set! x (add1 x)) ; x += 1
  (displayln x)
  (if (< x 3)
      (cc cc) ; we're going back to the moment 'cc' is binded to the continuation 'k'.
      ; as long as we continue to call cc onto itself we have our portal back to
      ; top of the loop (just after the let)
      ; if we pass something else to 'cc', it must be a function because we're
      ; calling it. Try (cc 1) and it will fail.
      x))


;; RETURN - we can use call/cc to mimic the 'preemptive return' (just like in C)
; when we call it, we jump out of the function.


;; BREAK macro - we can use call/cc to break out of a loop
(define-syntax while-break
  (syntax-rules (break-id:)
    [(_ cond break-id: break body ...) ; 'break' will be replaced by the keyword we choose at runtime
     (call/cc (λ (break)
                (let loop ()
                  (when cond
                    (begin body ...)
                    (loop)))))]))


(displayln "== BREAK ==")
(define y 5)
(while-break (> y 0) break-id: break ; <-- we need this last bit because of hygienic macros
             ; we can't call 'break' from outside the syntax-rule
             (when (= y 2) (break))
             (set! y (sub1 y)) ; y -= 1
             (displayln y))
; it will print 4 3 2 and then it will stop





; RECURSION - we can use call/cc to do recursion without naming the function
; (like letrec, but without naming the function)
; This is a bit contrived, but it works.
; We can do it with let, let*, letrec, and even sequentially with let
; (letrec is the most natural way to do it, though)
(displayln "== RECURSION LET PAR ==")

(set! x 0)

(let ((y 0) (cc (call/cc (λ (k) (k k))))) ; cc is the recursive function
  (set! x (+ 1 x))
  (set! y (+ 1 y))
  (printf "X=~a\n" x)
  (printf "Y=~a\n" y)
  (newline)
  (if (< x 3)
      (cc cc) ; call cc with itself to recurse
      x))

(displayln "== RECURSION LET* SEQ ==")

(set! x 0)

(let* ((y 0) (cc (call/cc (λ (k) (k k)))))
  (set! x (+ 1 x))
  (set! y (+ 1 y))
  (printf "X=~a\n" x)
  (printf "Y=~a\n" y)
  (newline)
  (if (< x 3)
      (cc cc)
      x))



;; -- HARD EXAMPLE --
;; GENERATORS - the 'yield' in Python/JavaScript
;; It's better to do it with simple closures, though!
(displayln "== GENERATOR ==")
(define (gen-one lst)
  ;; Both internal functions are closures over lst
  (define (state k-return) ; <- call k-return to return a value from the generator
    (for-each
     (λ (elem)
       (set! k-return (call/cc (λ (k1) ; <- call k1 to continue in the for-each
                                 ;; Grab the current continuation
                                 (set! state k1)
                                 (k-return elem)))))
     lst)
    (k-return 'end))

  ;; This is the actual generator, producing one item from lst at a time.
  (define (generator)
    (call/cc state))

  ;; Return the generator
  generator)

(define gen-num
  (gen-one '(0 1 2))) ; lst <- '(0 1 2)

(gen-num) ; 0
(gen-num) ; 1
(gen-num) ; 2
(gen-num) ; 'end

; In the woods, there are two roads, 'left and 'right
; Only one road leads you home
(displayln "== ADVENTURE ==")

(define (adventure choice)
  (case choice
    [(left) (displayln "You get lost in the woods!") 'lost]
    [(right) (displayln "You find your way home!") 'home]))

(define checkpoint #f)
(define snacks 4)

(when (equal?
       'lost
       (adventure (call/cc
                   (λ (k)
                     (set! checkpoint k)
                     (set! snacks (- snacks 1))
                     (printf "You have ~a snacks left!\n" snacks)
                     'left))))
  (checkpoint 'right))
(printf "You have ~a snacks left!\n" snacks)