#lang racket

; Exercise 1, Scheme (11 pts)
; Consider the delay/force construct used to implement call-by-need. Define an extension of the construct by adding
; the concept of a master promise: other promises could be created and linked to a master promise.
; When the master promise is evaluated, all its linked promises are evaluated too.
; In particular, we need the following constructs:
; 1. (delay-master <expression>) to create a master promise, and
; 2. (linked-delay <master> <expression>) to create a linked promise.
; Here’s the implementation of the delay/force construct seen in class:

; 1. Base Promise definition
(struct promise
  ([proc #:mutable]    ; The procedure (thunk) or the final value
   [value? #:mutable]) ; Boolean: has it been evaluated yet?
  #:transparent)

; 2. Master Promise definition (Inheritance)
; We inherit from 'promise' and add one mutable field: 'link'
(struct promise-master promise
  ([link #:mutable])
  #:transparent)

; 3. delay-master
; Creates a promise-master with an empty list of links '()
(define-syntax delay-master
  (syntax-rules ()
    ((_ expr)
     (promise-master (lambda () expr) #f '()))))

; 4. linked-delay
; Creates a standard promise, then UPDATES the master's link list
(define-syntax linked-delay
  (syntax-rules ()
    ((_ master expr)
     (let ((p (promise (lambda () expr) #f))) ; Create the child
       (when (promise-master? master)
         ; THIS is why we needed #:mutable
         ; We read the old list, cons p to it, and overwrite the field
         (set-promise-master-link! master (cons p (promise-master-link master))))
       p))))

; 5. Force (Updated logic)
(define (force prom)
  (cond
    ((not (promise? prom)) prom)      ; If it's just a value, return it
    ((promise-value? prom)            ; If already done, return saved value
     (promise-proc prom))
    (else
     ; 1. Calculate the value
     (let ((result ((promise-proc prom))))
       ; 2. Update the promise to store the result
       (set-promise-proc! prom result)
       (set-promise-value?! prom #t)

       ; 3. SPECIAL PART: If it is a Master, force all its children
       (when (promise-master? prom)
         (for-each force (promise-master-link prom)))

       result))))

; (define (force prom-received)
;   (cond
;     ((not (promise? prom-received)) prom-received)
;     ((promise-value? prom-received) (promise-proc prom-received))
;     (else
;      (set-promise-proc! prom-received
;                         ((promise-proc prom-received)))
;      (set-promise-value?! prom-received #t)
;      (promise-proc prom-received))))