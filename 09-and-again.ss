;
; Chapter 8 of The Little Schemer:
; ...and Again, and Again, and Again, ...
;
; Code examples assemled by Jinpu Hu (hujinpu@gmail.com).
; His blog is at http://hujinpu.com  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;


; The pick function returns the n-th element in a lat
;
(define pick
  (lambda (n lat)
    (cond
      ((zero? (sub1 n)) (car lat))
      (else
        (pick (sub1 n) (cdr lat))))))

; Functions like looking are called partial functions.
;
(define looking
  (lambda (a lat)
    (keep-looking a (pick 1 lat) lat)))

; Example of looking
;
(looking 'caviar '(6 2 4 caviar 5 7 3))         ; #t
(looking 'caviar '(6 2 grits caviar 5 7 3))     ; #f

; It does not recur on a part of lat.
; It is truly unnatural.
;
(define keep-looking
  (lambda (a sorn lat)
    (cond
      ((number? sorn)
       (keep-looking a (pick sorn lat) lat))
      (else (eq? sorn a )))))

; It is the most partial function.
;
(define eternity
  (lambda (x)
    (eternity x)))

; Helper functions for working with pairs
;
(define first
  (lambda (p)
    (car p)))

(define second
  (lambda (p)
    (car (cdr p))))

(define build
  (lambda (s1 s2)
    (cons s1 (cons s2 '()))))

; The function shift takes a pair whose first component is a pair 
; and builds a pair by shifting the second part of the first component
; into the second component
;
(define shift
  (lambda (pair)
    (build (first (first pair))
      (build (second (first pair))
        (second pair)))))

; Example of shift
;
(shift '((a b) c))                            ; '(a (b c))
(shift '((a b) (c d)))                        ; '(a (b (c d)))

; The a-pair? function determines if it's a pair
;
(define a-pair?
  (lambda (x)
    (cond
      ((atom? x) #f)
      ((null? x) #f)
      ((null? (cdr x)) #f)
      ((null? (cdr (cdr x))) #t)
      (else #f))))

; We first need to define atom? for Scheme as it's not a primitive
;
(define atom?
 (lambda (x)
    (and (not (pair? x)) (not (null? x))))) 

; align is not a partial function, because it yields a value for every argument.
;
(define align
  (lambda (pora)
    (cond
      ((atom? pora) pora)
      ((a-pair? (first pora))
       (align (shift pora)))
      (else (build (first pora)
              (align (second pora)))))))

; counts the number of atoms in align's arguments
;
(define length*
  (lambda (pora)
    (cond
      ((atom? pora) 1)
      (else
        (+ (length* (first pora))
           (length* (second pora)))))))

(define weight*
  (lambda (pora)
    (cond
      ((atom? pora) 1)
      (else
        (+ (* (weight* (first pora)) 2)
           (weight* (second pora)))))))

; Example of weight*
;
(weight* '((a b) c))                          ; 7
(weight* '(a (b c))                           ; 5

; Let's simplify revrel by using inventing revpair that reverses a pair
;
(define revpair
  (lambda (p)
    (build (second p) (first p))))  

(define shuffle
  (lambda (pora)
    (cond
      ((atom? pora) pora)
      ((a-pair? (first pora))
       (shuffle (revpair pora)))
      (else
        (build (first pora)
          (shuffle (second pora)))))))

; Example of shuffle
;
(shuffle '(a (b c)))                          ; '(a (b c))
(shuffle '(a b))                              ; '(a b)
(shuffle '((a b) (c d)))                      ; infinite swap pora  Ctrl + c  to break and input q to exit

; The one? function is true when n=1
;
(define one?
  (lambda (n) (= n 1)))

; not total function
(define C
  (lambda (n)
    (cond
      ((one? n) 1)
      (else
        (cond
          ((even? n) (C (/ n 2)))
          (else
            (C (add1 (* 3 n)))))))))

(define A
  (lambda (n m)
    (cond
      ((zero? n) (add1 m))
      ((zero? m) (A (sub1 n) 1))
      (else
        (A (sub1 n)
           (A n (sub1 m)))))))

; Example of A
(A 1 0)                                       ; 2
(A 1 1)                                       ; 3
(A 2 2)                                       ; 7

; length0
;
(lambda (l)
  (cond
    ((null? l) 0)
    (else
      (add1 (eternity (cdr l))))))

; length<=1
;
(lambda (l)
  (cond
    ((null? l) 0)
    (else
      (add1
        ((lambda(l)
           (cond
             ((null? l) 0)
             (else
               (add1 (eternity (cdr l))))))
         (cdr l))))))

; All these programs contain a function that looks like length.
; Perhaps we should abstract out this function.

; rewrite length0
;
((lambda (length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else (add1 (length (cdr l)))))))
 eternity)

; rewrite length<=1
;
((lambda (f)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else (add1 (f (cdr l)))))))
 ((lambda (g)
    (lambda (l)
      (cond
        ((null? l) 0)
        (else (add1 (g (cdr l)))))))
  eternity))

; make length
;
(lambda (mk-length)
  (mk-length eternity))

; rewrite length<=1
((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else
         (add1
           ((mk-length eternity) (cdr l))))))))

; It's (length '(1 2 3 4 5))
;
(((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else
         (add1
           ((mk-length mk-length) (cdr l))))))))
 '(1 2 3 4 5))

; 5


((lambda (mk-length)
   (mk-length mk-length))
 (lambda (mk-length)
   ((lambda (length)
      (lambda (l)
        (cond
          ((null? l) 0)
          (else
            (add1 (length (cdr l)))))))
    (lambda (x)
      ((mk-length mk-length) x)))))

; move out length function
;
((lambda (le)
   ((lambda (mk-length)
      (mk-length mk-length))
    (lambda (mk-length)
      (le (lambda (x)
            ((mk-length mk-length) x))))))
 (lambda (length)
   (lambda (l)
     (cond
       ((null? l) 0)
       (else (add1 (length (cdr l))))))))

; Y
;
(lambda (le)
  ((lambda (mk-length)
     (mk-length mk-length))
   (lambda (mk-length)
     (le (lambda (x)
           ((mk-length mk-length) x))))))

; it is called the applicative-order Y combinator.
;
(define Y
  (lambda (le)
    ((lambda (f) (f f))
     (lambda (f)
       (le (lambda (x) ((f f) x)))))))