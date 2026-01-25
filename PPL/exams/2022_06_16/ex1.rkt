#lang racket

; Exercise 1, Scheme (10 pts)
; Define a list-to-compose pure function, which takes a list containing functions of one argument and
; returns their composition.
; E.g. (list-to-compose (list f g h)) is the function f(g(h(x))).

(define (_list-to-compose lst)
  (lambda (x)
    (foldr (lambda (f acc) (f acc)) x lst)))