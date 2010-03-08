;
; Chapter 7 of The Little Schemer:
; Friends and Relations
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

; member function from Chapter 2 (02-do-it-again.ss)
;
(define member?
  (lambda (a lat)
    (cond
      ((null? lat) #f)
      (else (or (eq? (car lat) a)
                (member? a (cdr lat)))))))

; atom? function from Chapter 1 (01-toys.ss)
(define atom?
 (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

; Example of a set
;
'(apples peaches pears plums)

; Example of not a set
;
'(apple peaches apple plum)             ; because 'apple appears twice

; The set? function determines if a given lat is a set
;
(define set?
  (lambda (lat)
    (cond
      ((null? lat) #t)
      ((member? (car lat) (cdr lat)) #f)
      (else
        (set? (cdr lat))))))

; Examples of set?
;
(set? '(apples peaches pears plums))            ; #t
(set? '(apple peaches apple plum))              ; #f
(set? '(apple 3 pear 4 9 apple 3 4))            ; #f

; The makeset funciton takes a lat and produces a set
;
(define makeset
  (lambda (lat)
    (cond
      ((null? lat) '())
      ((member? (car lat) (cdr lat)) (makeset (cdr lat)))
      (else
        (cons (car lat) (makeset (cdr lat)))))))

; Example of makeset
;
(makeset '(apple peach pear peach plum apple lemon peach))
; ==> '(pear plum apple lemon peach)

; makeset via multirember from Chapter 3 (03-cons-the-magnificent.ss)
;
(define multirember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) a)
       (multirember a (cdr lat)))
      (else
        (cons (car lat) (multirember a (cdr lat)))))))

(define makeset
  (lambda (lat)
    (cond
      ((null? lat) '())
      (else
        (cons (car lat)
              (makeset (multirember (car lat) (cdr lat))))))))

; Test makeset
;
(makeset '(apple peach pear peach plum apple lemon peach))
; ==> '(apple peach pear plum lemon)

(makeset '(apple 3 pear 4 9 apple 3 4))
; ==> '(apple 3 pear 4 9)

; The subset? function determines if set1 is a subset of set2
;
(define subset?
  (lambda (set1 set2)
    (cond
      ((null? set1) #t)
      ((member? (car set1) set2)
       (subset? (cdr set1) set2))
      (else #f))))

; Examples of subset?
;
(subset? '(5 chicken wings)
         '(5 hamburgers 2 pieces fried chicken and light duckling wings))
; ==> #t

(subset? '(4 pounds of horseradish)
         '(four pounds of chicken and 5 ounces of horseradish))
; ==> #f

; A shorter version of subset?
;
(define subset?
  (lambda (set1 set2)
    (cond
      ((null? set1) #t)
      (else (and (member? (car set1) set2)
                 (subset? (cdr set1) set2))))))

; Tests of the new subset?
;
(subset? '(5 chicken wings)
         '(5 hamburgers 2 pieces fried chicken and light duckling wings))
; ==> #t

(subset? '(4 pounds of horseradish)
         '(four pounds of chicken and 5 ounces of horseradish))
; ==> #f

; The eqset? function determines if two sets are equal
;
(define eqset?
  (lambda (set1 set2)
    (and (subset? set1 set2)
         (subset? set2 set1))))

; Examples of eqset?
;
(eqset? '(a b c) '(c b a))          ; #t
(eqset? '() '())                    ; #t
(eqset? '(a b c) '(a b))            ; #f

; The intersect? function finds if two sets intersect
;
(define intersect?
  (lambda (set1 set2)
    (cond
      ((null? set1) #f)
      ((member? (car set1) set2) #t)
      (else
        (intersect? (cdr set1) set2)))))

; Examples of intersect?
;
(intersect?
  '(stewed tomatoes and macaroni)
  '(macaroni and cheese))
; ==> #t

(intersect?
  '(a b c)
  '(d e f))
; ==> #f

; A shorter version of intersect?
;
(define intersect?
  (lambda (set1 set2)
    (cond
      ((null? set1) #f)
      (else (or (member? (car set1) set2)
                (intersect? (cdr set1) set2))))))

; Tests of intersect?
;
(intersect?
  '(stewed tomatoes and macaroni)
  '(macaroni and cheese))
; ==> #t

(intersect?
  '(a b c)
  '(d e f))
; ==> #f

; The intersect function finds the intersect between two sets
;
(define intersect
  (lambda (set1 set2)
    (cond
      ((null? set1) '())
      ((member? (car set1) set2)
       (cons (car set1) (intersect (cdr set1) set2)))
      (else
        (intersect (cdr set1) set2)))))

; Example of intersect
;
(intersect
  '(stewed tomatoes and macaroni)
  '(macaroni and cheese))
; ==> '(and macaroni)

; The union function finds union of two sets
;
(define union
  (lambda (set1 set2)
    (cond
      ((null? set1) set2)
      ((member? (car set1) set2)
       (union (cdr set1) set2))
      (else (cons (car set1) (union (cdr set1) set2))))))

; Example of union
;
(union
  '(stewed tomatoes and macaroni casserole)
  '(macaroni and cheese))
; ==> '(stewed tomatoes casserole macaroni and cheese)

; The xxx function is the set difference function
;
(define xxx
  (lambda (set1 set2)
    (cond
      ((null? set1) '())
      ((member? (car set1) set2)
       (xxx (cdr set1) set2))
      (else
        (cons (car set1) (xxx (cdr set1) set2))))))

; Example of set difference
;
(xxx '(a b c) '(a b d e f))     ; '(c)

; The intersectall function finds intersect between multitude of sets
;
(define intersectall
  (lambda (l-set)
    (cond
      ((null? (cdr l-set)) (car l-set))
      (else
        (intersect (car l-set) (intersectall (cdr l-set)))))))

; Examples of intersectall
;
(intersectall '((a b c) (c a d e) (e f g h a b)))       ; '(a)
(intersectall
  '((6 pears and)
    (3 peaches and 6 peppers)
    (8 pears and 6 plums)
    (and 6 prunes with some apples)))                   ; '(6 and)

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

; Examples of pairs
;
(a-pair? '(pear pear))          ; #t
(a-pair? '(3 7))                ; #t
(a-pair? '((2) (pair)))         ; #t
(a-pair? '(full (house)))       ; #t

; Examples of not-pairs
(a-pair? '())                   ; #f
(a-pair? '(a b c))              ; #f

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

; Just an example of how you'd write third
;
(define third
  (lambda (l)
    (car (cdr (cdr l)))))

; Example of a not-relations
;
'(apples peaches pumpkins pie)
'((apples peaches) (pumpkin pie) (apples peaches))

; Examples of relations
;
'((apples peaches) (pumpkin pie))
'((4 3) (4 2) (7 6) (6 2) (3 4))

; The fun? function determines if rel is a function
;
(define fun?
  (lambda (rel)
    (set? (firsts rel))))

; It uses firsts function from Chapter 3 (03-cons-the-magnificent.ss)
(define firsts
  (lambda (l)
    (cond
      ((null? l) '())
      (else
        (cons (car (car l)) (firsts (cdr l)))))))

; Examples of fun?
;
(fun? '((4 3) (4 2) (7 6) (6 2) (3 4)))     ; #f
(fun? '((8 3) (4 2) (7 6) (6 2) (3 4)))     ; #t
(fun? '((d 4) (b 0) (b 9) (e 5) (g 4)))     ; #f

; The revrel function reverses a relation
;
(define revrel
  (lambda (rel)
    (cond
      ((null? rel) '())
      (else (cons (build (second (car rel))
                         (first (car rel)))
                  (revrel (cdr rel)))))))

; Example of revrel
;
(revrel '((8 a) (pumpkin pie) (got sick)))
; ==> '((a 8) (pie pumpkin) (sick got))

; Let's simplify revrel by using inventing revpair that reverses a pair
;
(define revpair
  (lambda (p)
    (build (second p) (first p))))

; Simplified revrel
;
(define revrel
  (lambda (rel)
    (cond
      ((null? rel) '())
      (else (cons (revpair (car rel)) (revrel (cdr rel)))))))

; Test of simplified revrel
; 
(revrel '((8 a) (pumpkin pie) (got sick)))
; ==> '((a 8) (pie pumpkin) (sick got))

; The fullfun? function determines if the given function is full
;
(define fullfun?
  (lambda (fun)
    (set? (seconds fun))))

; It uses seconds helper function
;
(define seconds
  (lambda (l)
    (cond
      ((null? l) '())
      (else
        (cons (second (car l)) (seconds (cdr l)))))))

; Examples of fullfun?
;
(fullfun? '((8 3) (4 2) (7 6) (6 2) (3 4)))     ; #f
(fullfun? '((8 3) (4 8) (7 6) (6 2) (3 4)))     ; #t
(fullfun? '((grape raisin)
            (plum prune)
            (stewed prune)))                    ; #f

; one-to-one? is the same fullfun?
;
(define one-to-one?
  (lambda (fun)
    (fun? (revrel fun))))

(one-to-one? '((8 3) (4 2) (7 6) (6 2) (3 4)))     ; #f
(one-to-one? '((8 3) (4 8) (7 6) (6 2) (3 4)))     ; #t
(one-to-one? '((grape raisin)
               (plum prune)
               (stewed prune)))                    ; #f

(one-to-one? '((chocolate chip) (doughy cookie)))
; ==> #t and you deserve one now!

;
; Go get yourself this wonderful book and have fun with these examples!
;
; Shortened URL to the book at Amazon.com: http://bit.ly/4GjWdP
;
; Sincerely,
; Peteris Krumins
; http://www.catonmat.net
;

