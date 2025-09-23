#lang racket


; call by value
; Racket uses lexical scoping
; variables are bound to values, not to other variables
; set! changes the binding of a variable in the current scope
; set! does not affect bindings in other scopes
(define (set-local x)
  (set! x 3)
  (displayln x)) ; => 3
(define x 1)
(set! x 2)
(displayln x) ; => 2
(set-local x)
(displayln x) ; => 2

; ------------------------------------------------------------------

; Hello World
(displayln "Hello, World!")

; ------------------------------------------------------------------

; Define a function that prints "Hello again!"; and call it
(define (say-hello)
  (displayln "Hello again!"))

(say-hello) ; => Hello again!

say-hello ; => #<procedure:say-hello>
; ------------------------------------------------------------------

; Define a function that takes a name as argument and prints "Hello, <name>!"
(define (greet name)
  (displayln (string-append "Hello, " name "!")))


(greet "Alice") ; => Hello, Alice!

; ------------------------------------------------------------------

; Define a function that takes a name as argument and prints "Hello, Ada Lovelace!" if the name is "Ada", and "go away!" otherwise
(define (greet-ada name)
  (if (equal? name "Ada")
      (displayln "Hello, Ada Lovelace!")    ; then branch
      (displayln "go away!")                ; else branch
      ))

(greet-ada "Ada") ; => Hello, Ada Lovelace!
(greet-ada "Bob") ; => go away!

; ------------------------------------------------------------------

(eq? "A" "A") ; => #t
(eq? "A" "B") ; => #f
(eq? "A" (make-string 1 #\A)) ; => #f
(equal? "A" "A") ; => #t

; ------------------------------------------------------------------

;(greet 5)

(define (safe-greet name)
  (if (string? name)
      (greet name)
      (displayln "Invalid input")))

(safe-greet "Charlie") ; => Hello, Charlie!
(safe-greet 42)        ; => Invalid input

; ------------------------------------------------------------------

