#lang racket

; Exercise 1, Scheme (11 pts)
; Define a let** construct that behaves like the standard let*, but gives to variables provided without a binding the
; value of the last defined variable. It also contains a default value, stated by a special keyword def:, to be used if the
; first variable is given without binding.
; For example:
; (let** def: #f
;        (a (b 1) (c (+ b 1)) d (e (+ d 1)) f)
;        (list a b c d e f))
; should return '(#f 1 2 2 3 3), because a assumes the default value #f, while d = c and f = e.
(define-syntax let**
  (syntax-rules (def:)
    ((_ def: v (var) istr ...)
     ((lambda (var) istr ...) v))
    ((_ def: _v ((var val)) istr ...)
     ((lambda (var) istr ...) val))
    ((_ def: _v ((var val) . rest) istr ...)
     ((lambda (var) (let** def: val rest istr ...)) val))
    ((_ def: v (var . rest) istr ...)
     ((lambda (var) (let** def: v rest istr ...))v))
    ))

; (let** def: #f
;        (a (b 1) (c (+ b 1)) d (e (+ d 1)) f)
;        (list a b c d e f))