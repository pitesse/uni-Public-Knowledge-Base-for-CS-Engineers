#lang racket

; Exercise 1, Scheme (11 pts)
; We want to implement a version of call/cc, called store-named-cc, where the continuation is given a name (a
; symbol) and is implicit, i.e. we do not need to pass a variable to the construct to store the continuation,
; e.g. (store-named-cc ‘stuff (+ x 1)), where stuff is the name that we want to use for the continuation.
; To run the continuation, we can use the associated construct run-named-cc name, which may take other
; parameters, if the continuation requires them.
; (define *cc-map* (make-hash))

; (define-syntax _store-named-cc
;   (syntax-rules ()
;     ((_ name body ...)
;      (call/cc (lambda (k)
;                 (hash-set! *cc-map* name k)
;                 body ...)))))

; (define (_run-named-cc name . args)
;   (apply (hash-ref *cc-map* name) args))

;; 1. Global storage: An Association List (initially empty)
(define *cc-registry* '())

;; 2. The Macro: Stores the continuation by adding a pair to the list
(define-syntax _store-named-cc
  (syntax-rules ()
    ((_ name body ...)
     (call/cc 
       (lambda (k)
         ;; Add pair (name . k) to the front of the registry
         (set! *cc-registry* (cons (cons name k) *cc-registry*))
         body ...)))))

;; 3. The Runner: Looks up the name in the list
(define (_run-named-cc name . args)
  ;; assoc returns the pair (name . k) or #f if not found
  (let ((pair (assoc name *cc-registry*)))
    (if pair
        (apply (cdr pair) args) ;; Execute the continuation (cdr)
        (error "Continuation not found" name))))