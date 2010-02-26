;
; Chapter 6 of The Little Schemer:
; Shadows
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

; The numbered? function determines whether a representation of an arithmetic
; expression contains only numbers besides the o+, ox and o^ (for +, * and exp).
;
(define numbered?
  (lambda (aexp)
    (cond
      ((atom? aexp) (number? aexp))
      ((eq? (car (cdr aexp)) 'o+)
       (and (numbered? (car aexp))
            (numbered? (car (cdr (cdr aexp))))))
      ((eq? (car (cdr aexp)) 'ox)
       (and (numbered? (car aexp))
            (numbered? (car (cdr (cdr aexp))))))
      ((eq? (car (cdr aexp)) 'o^)
       (and (numbered? (car aexp))
            (numbered? (car (cdr (cdr aexp))))))
      (else #f))))

; Examples of numbered?
;
(numbered? '5)                               ; #t
(numbered? '(5 o+ 5))                        ; #t
(numbered? '(5 o+ a))                        ; #f
(numbered? '(5 ox (3 o^ 2)))                 ; #t
(numbered? '(5 ox (3 'foo 2)))               ; #f
(numbered? '((5 o+ 2) ox (3 o^ 2)))          ; #t

; Assuming aexp is a numeric expression, numbered? can be simplified
;
(define numbered?
  (lambda (aexp)
    (cond
      ((atom? aexp) (number? aexp))
      (else
        (and (numbered? (car aexp))
             (numbered? (car (cdr (cdr aexp)))))))))

; Tests of numbered?
;
(numbered? '5)                               ; #t
(numbered? '(5 o+ 5))                        ; #t
(numbered? '(5 ox (3 o^ 2)))                 ; #t
(numbered? '((5 o+ 2) ox (3 o^ 2)))          ; #t

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The seventh commandment                                                    ;
;                                                                            ;
; Recur on the subparts that are of the same nature:                         ;
; * On the sublists of a list.                                               ;
; * On the subexpressions of an arithmetic expression.                       ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The value function determines the value of an arithmetic expression
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

; Examples of value
;
(value 13)                                   ; 13
(value '(1 o+ 3))                            ; 4
(value '(1 o+ (3 o^ 4)))                     ; 82

; The value function for prefix notation
;
(define value-prefix
  (lambda (nexp)
    (cond
      ((atom? nexp) nexp)
      ((eq? (car nexp) 'o+)
       (+ (value-prefix (car (cdr nexp)))
          (value-prefix (car (cdr (cdr nexp))))))
      ((eq? (car nexp) 'o*)
       (* (value-prefix (car (cdr nexp)))
          (value-prefix (car (cdr (cdr nexp))))))
      ((eq? (car nexp) 'o^)
       (expt (value-prefix (car (cdr nexp)))
             (value-prefix (car (cdr (cdr nexp))))))
      (else #f))))

; Examples of value-prefix
;
(value-prefix 13)                            ; 13
(value-prefix '(o+ 3 4))                     ; 7
(value-prefix '(o+ 1 (o^ 3 4)))              ; 82

; It's best to invent 1st-sub-exp and 2nd-sub-exp functions
; instead of writing (car (cdr (cdr nexp))), etc.
; These are for prefix notation.
;
(define 1st-sub-exp
  (lambda (aexp)
    (car (cdr aexp))))

(define 2nd-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp)))))

; It's also best to invent operator function,
; instead of writing (car nexp), etc.
; This is for prefix notation
;
(define operator
  (lambda (aexp)
    (car aexp)))

; The new value function that uses helper functions
;
(define value-prefix-helper
  (lambda (nexp)
    (cond
      ((atom? nexp) nexp)
      ((eq? (operator nexp) 'o+)
       (+ (value-prefix (1st-sub-exp nexp))
          (value-prefix (2nd-sub-exp nexp))))
      ((eq? (car nexp) 'o*)
       (* (value-prefix (1st-sub-exp nexp))
          (value-prefix (2nd-sub-exp nexp))))
      ((eq? (car nexp) 'o^)
       (expt (value-prefix (1st-sub-exp nexp))
             (value-prefix (2nd-sub-exp nexp))))
      (else #f))))

; Examples of value-prefix-helper
;
(value-prefix-helper 13)                            ; 13
(value-prefix-helper '(o+ 3 4))                     ; 7
(value-prefix-helper '(o+ 1 (o^ 3 4)))              ; 82

; Redefine helper functions for infix notation
;
(define 1st-sub-exp
  (lambda (aexp)
    (car aexp)))

(define 2nd-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp)))))

(define operator
  (lambda (aexp)
    (car (cdr aexp))))

; Examples of value-prefix-helper of infix notation expressions
;
(value-prefix 13)                            ; 13
(value-prefix '(o+ 3 4))                     ; 7
(value-prefix '(o+ 1 (o^ 3 4)))              ; 82

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The eighth commandment                                                     ;
;                                                                            ;
; Use help functions to abstract from representations.                       ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A different number representation:
; () for zero, (()) for one, (() ()) for two, (() () ()) for three, etc.
;

; sero? just like zero?
;
(define sero?
  (lambda (n)
    (null? n)))

; edd1 just like add1
;
(define edd1
  (lambda (n)
    (cons '() n)))

; zub1 just like sub1
;
(define zub1
  (lambda (n)
    (cdr n)))

; .+ just like o+
;
(define .+
  (lambda (n m)
    (cond
      ((sero? m) n)
      (else
        (edd1 (.+ n (zub1 m)))))))
    
; Example of .+
;
(.+ '(()) '(() ()))     ; (+ 1 2)
;==> '(() () ())

; tat? just like lat?
;
(define tat?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((atom? (car l))
       (tat? (cdr l)))
      (else #f))))

; But does tat? work

(tat? '((()) (()()) (()()())))  ; (lat? '(1 2 3))
; ==> #f

; Beware of shadows.

;
; Go get yourself this wonderful book and have fun with these examples!
;
; Shortened URL to the book at Amazon.com: http://bit.ly/4GjWdP
;
; Sincerely,
; Peteris Krumins
; http://www.catonmat.net
;

