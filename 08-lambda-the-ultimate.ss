;
; Chapter 8 of The Little Schemer:
; Lambda the Ultimate
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

; The atom? primitive
;
(define atom?
 (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

; The rember-f function takes the test function, element, and a list
; and removes the element that test true
;
(define rember-f
  (lambda (test? a l)
    (cond
      ((null? l) '())
      ((test? (car l) a) (cdr l))
      (else
        (cons (car l) (rember-f test? a (cdr l)))))))

; Examples of rember-f
;
(rember-f eq? 2 '(1 2 3 4 5))
; ==> '(1 3 4 5)

; The eq?-c function takes an atom and returns a function that
; takes an atom and tests if they are the same
;
(define eq?-c
  (lambda (a)
    (lambda (x)
      (eq? a x))))

; Example of eq?-c
;
((eq?-c 'tuna) 'tuna)       ; #t
((eq?-c 'tuna) 'salad)      ; #f

(define eq?-salad (eq?-c 'salad))

; Examples of eq?-salad
;
(eq?-salad 'salad)          ; #t
(eq?-salad 'tuna)           ; #f

; Another version of rember-f that takes test as an argument
; and returns a function that takes an element and a list
; and removes the element from the list
;
(define rember-f
  (lambda (test?)
    (lambda (a l)
      (cond
        ((null? l) '())
        ((test? (car l) a) (cdr l))
        (else
          (cons (car l) ((rember-f test?) a (cdr l))))))))

; Test of rember-f
;
((rember-f eq?) 2 '(1 2 3 4 5))
; ==> '(1 3 4 5)

; Curry (rember-f eq?)
;
(define rember-eq? (rember-f eq?))

; Test curried function
;
(rember-eq? 2 '(1 2 3 4 5))
; ==> '(1 3 4 5)
(rember-eq? 'tuna '(tuna salad is good))
; ==> '(salad is good)
(rember-eq? 'tuna '(shrimp salad and tuna salad))
; ==> '(shrimp salad and salad)
(rember-eq? 'eq? '(equal? eq? eqan? eqlist? eqpair?))
; ==> '(equal? eqan? eqlist? eqpair?)

; The insertL function from Chapter 3 (03-cons-the-magnificent.ss)
; This time curried
;
(define insertL-f
  (lambda (test?)
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((test? (car l) old)
         (cons new (cons old (cdr l))))
        (else
          (cons (car l) ((insertL-f test?) new old (cdr l))))))))

; Test insertL-f
;
((insertL-f eq?)
  'd
  'e
  '(a b c e f g d h))                  ; '(a b c d e f g d h)

; The insertR function, curried
;
(define insertR-f
  (lambda (test?)
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((test? (car l) old)
         (cons old (cons new (cdr l))))
        (else
          (cons (car l) ((insertR-f test?) new old (cdr l))))))))

; Test insertR-f
((insertR-f eq?)
  'e
  'd
  '(a b c d f g d h))                  ; '(a b c d e f g d h)

; The seqL function is what insertL does that insertR doesn't
;
(define seqL
  (lambda (new old l)
    (cons new (cons old l))))

; The seqR function is what insertR does that insertL doesn't
;
(define seqR
  (lambda (new old l)
    (cons old (cons new l))))

; insert-g acts as insertL or insertR depending on the helper
; function passed to it
;
(define insert-g
  (lambda (seq)
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((eq? (car l) old)
         (seq new old (cdr l)))
        (else
          (cons (car l) ((insert-g seq) new old (cdr l))))))))

; insertL is now just (insert-g seqL)
;
(define insertL (insert-g seqL))

; insertR is now just (insert-g seqR)
;
(define insertR (insert-g seqR))

; Test insertL
;
(insertL
  'd
  'e
  '(a b c e f g d h))                  ; '(a b c d e f g d h)

; Test insertR
(insertR
  'e
  'd
  '(a b c d f g d h))                  ; '(a b c d e f g d h)

; insertL can also be defined by passing it a lambda
;
(define insertL
  (insert-g
    (lambda (new old l)
      (cons new (cons old l)))))

; Test insertL
;
(insertL
  'd
  'e
  '(a b c e f g d h))                  ; '(a b c d e f g d h)

; The subst function from Chapter 3 (03-cons-the-magnificent.ss)
;
(define subst-f
  (lambda (new old l)
    (cond
      ((null? l) '())
      ((eq? (car l) old)
       (cons new (cdr l)))
      (else
        (cons (car l) (subst new old (cdr l)))))))

; The seqS function is what subst does that neither insertL nor insertR do
;
(define seqS
  (lambda (new old l)
    (cons new l)))

; subst is now just (insret-g seqS)
;
(define subst (insert-g seqS))

; Test subst
;
(subst
  'topping
  'fudge
  '(ice cream with fudge for dessert)) ; '(ice cream with topping for dessert)

; Guess what yyy is
;
(define yyy
  (lambda (a l)
    ((insert-g seqrem) #f a l)))

; yyy uses seqrem
(define seqrem
  (lambda (new old l)
    l))

; It's rember! Let's test it.
;
(yyy
  'sausage
  '(pizza with sausage and bacon))      ; '(pizza with and bacon)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The ninth commandment                                                      ;
;                                                                            ;
; Abstract common patterns with a new function.                              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Remember the value function from Chapter 6 (06-shadows.ss)?
;
(define value
  (lambda (nexp)
    (cond
      ((atom? nexp) nexp)
      ((eq? (car (cdr nexp)) 'o+)
       (+ (value (car nexp))
          (value (car (cdr (cdr nexp))))))
      ((eq? (car (cdr nexp)) 'o*)
       (* (value (car nexp))
          (value (car (cdr (cdr nexp))))))
      ((eq? (car (cdr nexp)) 'o^)
       (expt (value (car nexp))
             (value (car (cdr (cdr nexp))))))
      (else #f))))

; Let's abstract it
;
(define atom-to-function
  (lambda (atom)
    (cond
      ((eq? atom 'o+) +)
      ((eq? atom 'o*) *)
      ((eq? atom 'o^) expt)
      (else #f))))

; atom-to-function uses operator
;
(define operator
  (lambda (aexp)
    (car aexp)))

; Example of atom-to-function
;
(atom-to-function (operator '(o+ 5 3)))     ; + (function plus)

; The value function rewritten to use abstraction
;
(define value
  (lambda (nexp)
    (cond
      ((atom? nexp) nexp)
      (else
        ((atom-to-function (operator nexp))
         (value (1st-sub-exp nexp))
         (value (2nd-sub-exp nexp)))))))

; value uses 1st-sub-exp
;
(define 1st-sub-exp
  (lambda (aexp)
    (car (cdr aexp))))

; value uses 2nd-sub-exp
(define 2nd-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp)))))

; Test value
;
(value 13)                                   ; 13
(value '(o+ 1 3))                            ; 4
(value '(o+ 1 (o^ 3 4)))                     ; 82

; The multirember function from Chapter 3 (03-cons-the-magnificent.ss)
;
(define multirember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) a)
       (multirember a (cdr lat)))
      (else
        (cons (car lat) (multirember a (cdr lat)))))))

; The multirember-f is multirember with a possibility to curry f
;
(define multirember-f
  (lambda (test?)
    (lambda (a lat)
      (cond
        ((null? lat) '())
        ((test? (car lat) a)
         ((multirember-f test?) a (cdr lat)))
        (else
          (cons (car lat) ((multirember-f test?) a (cdr lat))))))))

; Test multirember-f
;
((multirember-f eq?) 'tuna '(shrimp salad tuna salad and tuna))
; ==> '(shrimp salad salad and)

; Curry multirember-f with eq?
;
(define multirember-eq? (multirember-f eq?))

; The multiremberT changes the way test works
;
(define multiremberT
  (lambda (test? lat)
    (cond
      ((null? lat) '())
      ((test? (car lat))
       (multiremberT test? (cdr lat)))
      (else
        (cons (car lat)
              (multiremberT test? (cdr lat)))))))

; eq?-tuna tests if element is equal to 'tuna
;
(define eq?-tuna
  (eq?-c 'tuna))

; Example of multiremberT
;
(multiremberT
  eq?-tuna
  '(shrimp salad tuna salad and tuna))
; ==> '(shrimp salad salad and)

; The multiremember&co uses a collector
;
(define multiremember&co
  (lambda (a lat col)
    (cond
      ((null? lat)
       (col '() '()))
      ((eq? (car lat) a)
       (multiremember&co a (cdr lat)
       (lambda (newlat seen)
         (col newlat (cons (car lat) seen)))))
      (else
        (multiremember&co a (cdr lat)
                          (lambda (newlat seen)
                            (col (cons (car lat) newlat) seen)))))))

; The friendly function
;
(define a-friend
  (lambda (x y)
    (null? y)))

; Examples of multiremember&co with friendly function
;
(multiremember&co
  'tuna
  '(strawberries tuna and swordfish)
  a-friend)
; ==> #f
(multiremember&co
  'tuna
  '()
  a-friend)
; ==> #t
(multiremember&co
  'tuna
  '(tuna)
  a-friend)
; ==> #f

; The new friend function
;
(define new-friend
  (lambda (newlat seen)
    (a-friend newlat (cons 'tuna seen))))

; Examples of multiremember&co with the new friend function
;
(multiremember&co
  'tuna
  '(strawberries tuna and swordfish)
  new-friend)
; ==> #f
(multiremember&co
  'tuna
  '()
  new-friend)
; ==> #f
(multiremember&co
  'tuna
  '(tuna)
  new-friend)
; ==> #f

; The last friend function
;
(define last-friend
  (lambda (x y)
    (length x)))

; Examples of multiremember&co with the last friend function
;
(multiremember&co
  'tuna
  '(strawberries tuna and swordfish)
  last-friend)
; ==> 3
(multiremember&co
  'tuna
  '()
  last-friend)
; ==> 0
(multiremember&co
  'tuna
  '(tuna)
  last-friend)
; ==> 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The tenth commandment                                                      ;
;                                                                            ;
; Build functions to collect more than one value at a time.                  ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The multiinsertLR inserts to the left and to the right of elements
;
(define multiinsertLR
  (lambda (new oldL oldR lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) oldL)
       (cons new
             (cons oldL
                   (multiinsertLR new oldL oldR (cdr lat)))))
      ((eq? (car lat) oldR)
       (cons oldR
             (cons new
                   (multiinsertLR new oldL oldR (cdr lat)))))
      (else
        (cons
          (car lat)
          (multiinsertLR new oldL oldR (cdr lat)))))))

; Example of multiinsertLR
;
(multiinsertLR
  'x
  'a
  'b
  '(a o a o b o b b a b o))
; ==> '(x a o x a o b x o b x b x x a b x o)

; The multiinsertLR&co is to multiinsertLR what multirember is to
; multiremember&co
;
(define multiinsertLR&co
  (lambda (new oldL oldR lat col)
    (cond
      ((null? lat)
       (col '() 0 0))
      ((eq? (car lat) oldL)
       (multiinsertLR&co new oldL oldR (cdr lat)
                         (lambda (newlat L R)
                           (col (cons new (cons oldL newlat))
                                (+ 1 L) R))))
      ((eq? (car lat) oldR)
       (multiinsertLR&co new oldL oldR (cdr lat)
                         (lambda (newlat L R)
                           (col (cons oldR (cons new newlat))
                                L (+ 1 R)))))
      (else
        (multiinsertLR&co new oldL oldR (cdr lat)
                          (lambda (newlat L R)
                            (col (cons (car lat) newlat)
                                 L R)))))))

; Some collectors
;
(define col1
  (lambda (lat L R)
    lat))
(define col2
  (lambda (lat L R)
    L))
(define col3
  (lambda (lat L R)
    R))

; Examples of multiinsertLR&co
;
(multiinsertLR&co
  'salty
  'fish
  'chips
  '(chips and fish or fish and chips)
  col1)
; ==> '(chips salty and salty fish or salty fish and chips salty)
(multiinsertLR&co
  'salty
  'fish
  'chips
  '(chips and fish or fish and chips)
  col2)
; ==> 2
(multiinsertLR&co
  'salty
  'fish
  'chips
  '(chips and fish or fish and chips)
  col3)
; ==> 2

; The evens-only* function leaves all even numbers in an sexpression
; (removes odd numbers)
;
(define evens-only*
  (lambda (l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((even? (car l))
          (cons (car l)
                (evens-only* (cdr l))))
         (else
           (evens-only* (cdr l)))))
      (else
        (cons (evens-only* (car l))
              (evens-only* (cdr l)))))))

; Example of evens-only*
;
(evens-only*
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2))  ; '((2 8) 10 (() 6) 2)

; Evens only function with a collector, collects evens, their product,
; and sum of odd numbers
;
(define evens-only*&co
  (lambda (l col)
    (cond
      ((null? l)
       (col '() 1 0))
      ((atom? (car l))
       (cond
         ((even? (car l))
          (evens-only*&co (cdr l)
                          (lambda (newl p s)
                            (col (cons (car l) newl) (* (car l) p) s))))
         (else
           (evens-only*&co (cdr l)
                           (lambda (newl p s)
                             (col newl p (+ (car l) s)))))))
      (else
        (evens-only*&co (car l)
                        (lambda (al ap as)
                          (evens-only*&co (cdr l)
                                          (lambda (dl dp ds)
                                            (col (cons al dl)
                                                 (* ap dp)
                                                 (+ as ds))))))))))

; evens-friend returns collected evens
;
(define evens-friend
  (lambda (e p s)
    e))

; Example of evens-friend used
;
(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  evens-friend)
; ==> '((2 8) 10 (() 6) 2)

; evens-product-friend returns the product of evens
;
(define evens-product-friend
  (lambda (e p s)
    p))

; Example of evens-product-friend used
;
(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  evens-product-friend)
; ==> 1920

; evens-sum-friend returns the sum of odds
;
(define evens-sum-friend
  (lambda (e p s)
    s))

; Example of evens-sum-friend used
;
(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  evens-sum-friend)
; ==> 38

; the-last-friend returns sum, product and the list of evens consed together
;
(define the-last-friend
  (lambda (e p s)
    (cons s (cons p e))))

; Example of the-last-friend
;
(evens-only*&co 
  '((9 1 2 8) 3 10 ((9 9) 7 6) 2)
  the-last-friend)
; ==> '(38 1920 (2 8) 10 (() 6) 2)

;
; Go get yourself this wonderful book and have fun with these examples!
;
; Shortened URL to the book at Amazon.com: http://bit.ly/4GjWdP
;
; Sincerely,
; Peteris Krumins
; http://www.catonmat.net
;

