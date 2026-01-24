#lang racket

; Exercise 1, Scheme (10 pts)
; Consider the technique “closures as objects” as seen in class, where a closure assumes the role of a class.
; In this technique, the called procedure (which works like a class in OOP) returns a closure which is
; essentially the dispatcher of the object.
; Define the define-dispatcher macro for generating the dispatcher in an automatic way, as illustrated by
; the following example:

; (define (make-man)
;   (let ((p (make-entity))
;         (name "man"))
;     (define prefix+name
;       (lambda (prefix)
;         (string-append prefix name)))
;     (define change-name
;       (lambda (new-name)
;         (set! name new-name)))
;     (define-dispatcher methods: (prefix+name change-name) parent: p)))

; where p is the parent of the current instance of class man, and make-entity is its constructor.
; If there is no inheritance (or it is a base class), define-dispatcher can be used without the parent: p part.
; Then, an instance of class man can be created and its methods can be called as follows:
; > (define carlo (make-man))
; > (carlo 'change-name "Carlo")
; > (carlo 'prefix+name "Mr. ")
; "Mr. Carlo"

(define (unknown-method message . args)
  (error "Unknown method:" message))

(define-syntax define-dispatcher
  (syntax-rules (methods: parent:)
    
    ;; Case 1: Inheritance (Parent provided)
    ((_ methods: (mt ...) parent: p)
     (lambda (message . args)
       (case message
         ;; If message matches a method name...
         ((mt) (apply mt args)) 
         ...
         ;; FIX 2: Cleaner 'apply'. 
         ;; (apply f x y '(z)) is equivalent to (f x y z).
         ;; We pass 'message' explicitly as the first arg to the parent.
         (else (apply p message args)))))

    ;; Case 2: Base Class (No parent provided)
    ;; We recursively call the macro, injecting the fallback as the parent.
    ((_ methods: mts)
     (define-dispatcher methods: mts parent: unknown-method))))