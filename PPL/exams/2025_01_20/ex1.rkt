#lang racket

; Exercise 1, Scheme (11 pts)
; Consider a binary tree encoded as a list, where its first element is the current node, its second element contains the
; left sub-tree and the third element the right sub-tree. E.g. (1 (2 (4) (5)) (3 (6) (7))) encodes the tree:
;    1
;   / \
;   2 3
; / \ / \
; 4 5 6 7
; Define a tail recursive procedure which takes a tree and returns the list obtained by traversing the tree breadth first.
; In the example, the resulting list must be (1 2 3 4 5 6 7)

(define (tree2lst tree)
  (define (helper queue result)
    (if (null? queue)
        (reverse result)
        (helper (append (cdr queue) (cdr (car queue)))
                (cons  (caar queue) result))
        )
    )
  (if (null? tree)
      '()
      (helper (list tree) '())))



(tree2lst '(1 (2 (4) (5)) (3 (6) (7))))