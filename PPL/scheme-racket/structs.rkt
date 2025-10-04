#lang racket

;; Structs automatically create a set of procedures
; e.g. person? set-person-age?
;; SEE https://docs.racket-lang.org/reference/define-struct.html
(struct person
  (name
   [age #:mutable])) ; age can be changed after creation since it's mutable, because structs are immutable by default

(define p1 (person "Ada" 24))
(define p2 "Bob") ; not a person struct -- gives an error if we try to use person procedures on it

(person? p1)
(person? p2)

(set-person-age! p1 28) ; change age of p1 to 28 -- works because age is mutable and is created automatically by racket
(person-age p1)

;; Trees! - we can use structs to create tree nodes
; A binary tree node has a value, a left child and a right child
; A leaf node has only a value
(struct node
  ([value #:mutable]))

; A binary tree node has a value, a left child and a right child -- we use node as the base struct (extends node)
(struct binary-node node 
  (left
   right))

(define (leaf? n)
  (and (node? n) (not (binary-node? n))))

; let's make a simple tree
(define a-tree (binary-node 2 (binary-node 3 (node 4) (node 2)) (node 1)))

; print the tree values in pre-order traversal
(define (print-tree n)
  (displayln (node-value n))
  (unless (leaf? n)
    (print-tree (binary-node-left n))
    (print-tree (binary-node-right n))))
(print-tree a-tree)

;; ====== DISPLAY TREE NICELY ======
; feel free to ignore this code
; use library pict to display the tree graphically
(require pict)
(require pict/tree-layout)
(define (tree-show n)
  (define (tree-show-helper n)
    (cond [(leaf? n) (tree-layout #:pict (text (~a (node-value n))))]
          [(binary-node? n) (tree-layout #:pict (text (~a (node-value n)))
                                         (tree-show-helper (binary-node-left n))
                                         (tree-show-helper (binary-node-right n)))]))
  (naive-layered (tree-show-helper n)))
;; =================================

; displays the tree graphically
(tree-show a-tree)

; make a apply higher-order function for trees!
; applies the function f(x) to the value 'x' of
; each tree node.

#`(define (tree-apply f n)
  (set-node-value! n (f (node-value n)))
  (unless (leaf? n)
           (begin
             (tree-apply f (binary-node-left n))
             (tree-apply f (binary-node-right n)))))

#`(print-tree a-tree)

; apply for the tree
(define (tree-apply f n)
  (set-node-value! n (f (node-value n)))
  (when (binary-node? n)
    (begin
      (tree-apply f (binary-node-left n))
      (tree-apply f (binary-node-right n))))
  n)

; use of the tree-apply function with add1
(tree-show
 (tree-apply add1 a-tree))

(print-tree a-tree)

; Optional: Make a (tree-map f n) procedure that
; does not operate 'in place' like (tree-apply f n) does.