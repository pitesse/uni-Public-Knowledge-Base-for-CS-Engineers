#lang racket

; ----------------------------------------------------------------

; define list with quote
(define numbers '(1 2 3 4 5 6 7 8))

; HOF - higher order function

; map applies a function to each element of a list and returns a new list
; here we use an anonymous function (lambda) to square each number
(map (lambda (x) (* x x)) numbers) ; => '(1 4 9 16 25 36 49 64)

; filter applies a predicate function to each element and returns a list of elements that satisfy the predicate
; here we filter for even numbers
(filter (lambda (x) (even? x)) numbers) ; => '(2 4 6 8)

; foldl (fold left) reduces the list to a single value by applying a binary function from the left
; here we sum the numbers
(foldl (lambda (x acc) (+ x acc)) 0 numbers) ; => 36

; foldr (fold right) reduces the list to a single value by applying a binary function from the right
; here we create a string by concatenating the numbers from right to left
(foldr (lambda (x acc) (string-append (number->string x) acc)) "" numbers) ; => "12345678"

; ----------------------------------------------------------------

; list reversing


(define (list-reverse lst)
  (define (list-reverse-helper x acc)
    (when (null? x)
      acc
      (let ([head (car lst)]  ; sintactic sugar for (define head (car lst))
            [rest (cdr lst)]) ; sintactic sugar for (define rest (cdr lst))

        (displayln (string-append "x = " (number->string x) ", acc = " (number->string acc)))

        (list-reverse-helper rest (cons head acc))))) ; prepend head to accumulator

  (list-reverse-helper lst '())) ; start with empty accumulator


(list-reverse numbers) ; => '(8 7 6 5 4 3 2 1)

; ----------------------------------------------------------------

; flatten list

(define l1 '((1 2) (3 (4 5)) 6 (7 (8 9))))

(define (list-flatten lst)
  (cond
    [(null? lst) '()]           ; base case: empty list
    [(list? (car lst))          ; if the first element is a list, flatten it and concatenate with the rest
     (append (list-flatten (car lst)) (list-flatten (cdr lst)))]
    [else                       ; if the first element is not a list, keep it and flatten the rest
     (cons (car lst) (list-flatten (cdr lst)))]))

(list-flatten l1) ; => '(1 2 3 4 5 6 7 8 9)

; ----------------------------------------------------------------