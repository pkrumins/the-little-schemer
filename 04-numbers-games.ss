;
; Chapter 4 of The Little Schemer:
; Numbers Games
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

; Assume add1 is a primitive
;
(define add1
  (lambda (n) (+ n 1)))

; Example of add1
;
(add1 67)       ; 68

; Assume sub1 is a primitive
;
(define sub1
  (lambda (n) (- n 1)))

; Example of sub1
;
(sub1 5)        ; 5

; Example of zero?
;
(zero? 0)       ; true
(zero? 1492)    ; false

; The o+ function adds two numbers
;
(define o+
  (lambda (n m)
    (cond
      ((zero? m) n)
      (else (add1 (o+ n (sub1 m)))))))

; Example of o+
;
(o+ 46 12)      ; 58

; The o- function subtracts one number from the other
;
(define o-
  (lambda (n m)
    (cond
      ((zero? m) n)
      (else (sub1 (o- n (sub1 m)))))))

; Example of o-
;
(o- 14 3)       ; 11
(o- 17 9)       ; 8

; Examples of tups (tup is short for tuple)
;
'(2 111 3 79 47 6)
'(8 55 5 555)
'()

; Examples of not-tups
;
'(1 2 8 apple 4 3)      ; not-a-tup because apple is not a number
'(3 (7 4) 13 9)         ; not-a-tup because (7 4) is a list of numbers, not a number

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The first commandment (first revision)                                     ;
;                                                                            ;
; When recurring on a list of atoms, lat, ask two questions about it:        ;
; (null? lat) and else.                                                      ;
; When recurring on a number, n, ask two questions about it: (zero? n) and   ;
; else.                                                                      ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The addtup function adds all numbers in a tup
;
(define addtup
  (lambda (tup)
    (cond
      ((null? tup) 0)
      (else (o+ (car tup) (addtup (cdr tup)))))))

; Examples of addtup
;
(addtup '(3 5 2 8))     ; 18
(addtup '(15 6 7 12 3)) ; 43

; The o* function multiplies two numbers
;
(define o*
  (lambda (n m)
    (cond
      ((zero? m) 0)
      (else (o+ n (o* n (sub1 m)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The fourth commandment (first revision)                                    ;
;                                                                            ;
; Always change at least one argument while recurring. It must be changed to ;
; be closer to termination. The changing argument must be tested in the      ;
; termination condition:                                                     ;
; when using cdr, test the termination with null? and                        ;
; when using sub1, test termination with zero?.                              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of o*
;
(o* 5 3)                ; 15
(o* 13 4)               ; 52

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The fifth commandment                                                      ;
;                                                                            ;
; When building a value with o+, always use 0 for the value of the           ;
; terminating line, for adding 0 does not change the value of an addition.   ;
;                                                                            ;
; When building a value with o*, always use 1 for the value of the           ;
; terminating line, for multiplying by 1 does not change the value of a      ;
; multiplication.                                                            ;
;                                                                            ;
; When building a value with cons, always consider () for the value of the   ;
; terminating line.                                                          ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The tup+ function adds two tups
;
(define tup+
  (lambda (tup1 tup2)
    (cond
      ((null? tup1) tup2)
      ((null? tup2) tup1)
      (else
        (cons (o+ (car tup1) (car tup2))
              (tup+ (cdr tup1) (cdr tup2)))))))

; Examples of tup+
;
(tup+ '(3 6 9 11 4) '(8 5 2 0 7))   ; '(11 11 11 11 11)
(tup+ '(3 7) '(4 6 8 1))            ; '(7 13 8 1)

; The o> function compares n with m and returns true if n>m
;
(define o>
  (lambda (n m)
    (cond
      ((zero? n) #f)
      ((zero? m) #t)
      (else
        (o> (sub1 n) (sub1 m))))))

; Examples of o>
;
(o> 12 133)     ; #f (false)
(o> 120 11)     ; #t (true)
(o> 6 6)        ; #f

; The o< function compares n with m and returns true if n<m
;
(define o<
  (lambda (n m)
    (cond
      ((zero? m) #f)
      ((zero? n) #t)
      (else
        (o< (sub1 n) (sub1 m))))))

; Examples of o<
;
(o< 4 6)        ; #t
(o< 8 3)        ; #f
(o< 6 6)        ; #f

; The o= function compares n with m and returns true if n=m
;
(define o=
  (lambda (n m)
    (cond
      ((o> n m) #f)
      ((o< n m) #f)
      (else #t))))

; Examples of o=
;
(o= 5 5)        ; #t
(o= 1 2)        ; #f

; The o^ function computes n^m
;
(define o^
  (lambda (n m)
    (cond 
      ((zero? m) 1)
      (else (o* n (o^ n (sub1 m)))))))

; Examples of o^
;
(o^ 1 1)        ; 1
(o^ 2 3)        ; 8
(o^ 5 3)        ; 125

; The o/ function computes the integer part of n/m
;
(define o/
  (lambda (n m)
    (cond
      ((o< n m) 0)
      (else (add1 (o/ (o- n m) m))))))

; Example of o/
;
(o/ 15 4)       ; 3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;         Wouldn't a '(ham and cheese on rye) be good right now?             ;
;                                                                            ;
;                    Don't forget the 'mustard!                              ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The olength function finds the length of a lat
;
(define olength
  (lambda (lat)
    (cond
      ((null? lat) 0)
      (else (add1 (olength (cdr lat)))))))

; Examples of length
;
(olength '(hotdogs with mustard sauerkraut and pickles))     ; 6
(olength '(ham and cheese on rye))                           ; 5

; The pick function returns the n-th element in a lat
;
(define pick
  (lambda (n lat)
    (cond
      ((zero? (sub1 n)) (car lat))
      (else
        (pick (sub1 n) (cdr lat))))))

; Example of pick
;
(pick 4 '(lasagna spaghetti ravioli macaroni meatball))     ; 'macaroni

; The rempick function removes the n-th element and returns the new lat
;
(define rempick
  (lambda (n lat)
    (cond
      ((zero? (sub1 n)) (cdr lat))
      (else
        (cons (car lat) (rempick (sub1 n) (cdr lat)))))))

; Example of rempick
;
(rempick 3 '(hotdogs with hot mustard))     ; '(hotdogs with mustard)

; The no-nums function returns a new lat with all numbers removed
;
(define no-nums
  (lambda (lat)
    (cond
      ((null? lat) '())
      ((number? (car lat)) (no-nums (cdr lat)))
      (else
        (cons (car lat) (no-nums (cdr lat)))))))

; Example of no-nums
;
(no-nums '(5 pears 6 prunes 9 dates))       ; '(pears prunes dates)

; The all-nums does the opposite of no-nums - returns a new lat with
; only numbers
;
(define all-nums
  (lambda (lat)
    (cond
      ((null? lat) '())
      ((number? (car lat)) (cons (car lat) (all-nums (cdr lat))))
      (else
        (all-nums (cdr lat))))))

; Example of all-nums
;
(all-nums '(5 pears 6 prunes 9 dates))       ; '(5 6 9)


; The eqan? function determines whether two arguments are te same
; It uses eq? for atoms and = for numbers
;
(define eqan?
  (lambda (a1 a2)
    (cond
      ((and (number? a1) (number? a2)) (= a1 a2))
      ((or  (number? a1) (number? a2)) #f)
      (else
        (eq? a1 a2)))))

; Examples of eqan?
;
(eqan? 3 3)     ; #t
(eqan? 3 4)     ; #f
(eqan? 'a 'a)   ; #t
(eqan? 'a 'b)   ; #f

; The occur function counts the number of times an atom appears
; in a list
;
(define occur
  (lambda (a lat)
    (cond
      ((null? lat) 0)
      ((eq? (car lat) a)
       (add1 (occur a (cdr lat))))
      (else
        (occur a (cdr lat))))))

; Example of occur
;
(occur 'x '(a b x x c d x))     ; 3
(occur 'x '())                  ; 0

; The one? function is true when n=1
;
(define one?
  (lambda (n) (= n 1)))

; Example of one?
;
(one? 5)        ; #f
(one? 1)        ; #t

; We can rewrite rempick using one?
;
(define rempick-one
  (lambda (n lat)
    (cond
      ((one? n) (cdr lat))
      (else
        (cons (car lat) (rempick-one (sub1 n) (cdr lat)))))))

; Example of rempick-one
;
(rempick-one 4 '(hotdogs with hot mustard))     ; '(hotdogs with mustard)

;
; Go get yourself this wonderful book and have fun with these examples!
;
; Shortened URL to the book at Amazon.com: http://bit.ly/4GjWdP
;
; Sincerely,
; Peteris Krumins
; http://www.catonmat.net
;

