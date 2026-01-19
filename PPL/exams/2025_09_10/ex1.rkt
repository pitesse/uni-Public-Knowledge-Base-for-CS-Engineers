#lang racket

; Define a pure function (without using side effects such as set!) which takes a multi-level list, i.e. a list that may
; contain any level of sublists, and converts it into a data structure where:
; • Every single level list is converted into a string, formed by concatenating the string representations of its
;   elements.
; • If an element is itself a list, it is recursively converted.
; • Non-string elements are converted to strings using number->string or symbol->string as
;   appropriate.
; For example: (list->string-tree '(1 (2 3) (a (b c))))
; ("1" "23" ("a" "bc"))

(define (list->string-tree lst)
  (cond
    ((null? lst) "")                     ; empty list
    ((not (list? lst)) (handle-atom lst)) ; atom
    ((and (list? lst) (null? (filter list? lst)))  ; flat list
     (apply string-append (map handle-atom lst)))
    ((list? lst)
     (map (lambda (elem)
            (if (list? elem)
                (list->string-tree elem)    ; recurse on sublists
                (handle-atom elem)))   ; handle atoms
          lst))
    (else (handle-atom lst))))

(define (handle-atom atom)
  (cond
    ((number? atom) (number->string atom))
    ((symbol? atom) (symbol->string atom))
    ((string? atom) atom)
    (else (error "unsupported type"))))

(list->string-tree '(1 (2 3) (a (b c))))