#lang racket

; Exercise 1, Scheme (11 pts)
; Consider the following data structure, written in Haskell:

; data Expr a = Var a | Val Int | Op (Expr a) (Expr a)

; instance Functor Expr
;   fmap _ (Val x) = Val x
;   fmap g (Var x) = Var (g x)
;   fmap g (Op a b) = Op (fmap g a) (fmap g b)

; instance Applicative Expr
;   pure = Var
;   _ <*> Val x = Val x
;   Val x <*> _ = Val x
;   Var f <*> Var x = Var (f x)
;   Var f <*> Op x y = Op (fmap f x) (fmap f y)
;   Op f g <*> x = Op (f <*> x) (g <*> x)

; instance Monad Expr
;   Val x >>= _ = Val x
;   Var x >>= f = f x
;   Op a b >>= f = Op (a >>= f) (b >>= f)
; Define an analogous in Scheme, with all the previous operations, where the data structures are encoded as lists –
; e.g. Op (Val 0) (Var 1) is represented in Scheme as ‘(Op (Val 0) (Var 1)).

;; Constructors
(define (var x) (list 'Var x))
(define (val x) (list 'Val x))
(define (op x y) (list 'Op x y))

;; Predicates
(define (var? x) (eq? 'Var (car x)))
(define (val? x) (eq? 'Val (car x)))
(define (op? x) (eq? 'Op (car x)))

;; Functor: fmap
(define (fmap f e)
  (cond
    ((val? e) e)
    ((var? e) (var (f (cadr e))))
    ((op? e) (op (fmap f (cadr e)) (fmap f (caddr e))))))

;; Applicative: pure
(define pure var)

;; Applicative: <*>
(define (<*> x y)
  (cond
    ((val? y) y)
    ((val? x) x)
    ((var? x)
     (let ((f (cadr x)))
       (if (var? y)
           (var (f (cadr y)))
           (op (fmap f (cadr y)) (fmap f (caddr y))))))
    ((op? x)
     (op (<*> (cadr x) y) (<*> (caddr x) y)))))

;; Monad: >>=
(define (>>= x f)
  (cond
    ((val? x) x)
    ((var? x) (f (cadr x)))
    ((op? x) (op (>>= (cadr x) f) (>>= (caddr x) f)))))