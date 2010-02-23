;
; Chapter 5 of The Little Schemer:
; *Oh My Gawd*: It's Full of Stars
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

; The add1 primitive
;
(define add1
  (lambda (n) (+ n 1)))

; The rember* function removes all matching atoms from an s-expression
;
(define rember*
  (lambda (a l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((eq? (car l) a)
          (rember* a (cdr l)))
         (else
           (cons (car l) (rember* a (cdr l))))))
      (else
        (cons (rember* a (car l)) (rember* a (cdr l)))))))

; Examples of rember*
;
(rember*
  'cup
  '((coffee) cup ((tea) cup) (and (hick)) cup))
;==> '((coffee) ((tea)) (and (hick)))

(rember*
  'sauce
  '(((tomato sauce)) ((bean) sauce) (and ((flying)) sauce)))
;==> '(((tomato)) ((bean)) (and ((flying))))

; The insertR* function insers new to the right of all olds in l
;
(define insertR*
  (lambda (new old l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((eq? (car l) old)
          (cons old (cons new (insertR* new old (cdr l)))))
         (else
           (cons (car l) (insertR* new old (cdr l))))))
      (else
        (cons (insertR* new old (car l)) (insertR* new old (cdr l)))))))

; Example of insertR*
;
(insertR*
  'roast
  'chuck
  '((how much (wood)) could ((a (wood) chuck)) (((chuck)))
    (if (a) ((wood chuck))) could chuck wood))
; ==> ((how much (wood)) could ((a (wood) chuck roast)) (((chuck roast)))
;      (if (a) ((wood chuck roast))) could chuck roast wood)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The first commandment (final version)                                      ;
;                                                                            ;
; When recurring on a list of atoms, lat, ask two questions about it:        ;
; (null? lat) and else.                                                      ;
; When recurring on a number, n, ask two questions about it: (zero? n) and   ;
; else.                                                                      ;
; When recurring on a list of S-expressions, l, ask three questions about    ;
; it: (null? l), (atom? (car l)), and else.                                  ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The fourth commandment (final version)                                     ;
;                                                                            ;
; Always change at least one argument while recurring. When recurring on a   ;
; list of atoms, lat, use (cdr l). When recurring on a number, n, use        ;
; (sub1 n). And when recurring on a list of S-expressions, l, use (car l)    ;
; and (cdr l) if neither (null? l) nor (atom? (car l)) are true.             ;
;                                                                            ;
; It must be changed to be closer to termination. The changing argument must ;
; be tested in the termination condition:                                    ;
; * when using cdr, test the termination with null? and                      ;
; * when using sub1, test termination with zero?.                            ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The occur* function counts the number of occurances of an atom in l
;
(define occur*
  (lambda (a l)
    (cond
      ((null? l) 0)
      ((atom? (car l))
       (cond
         ((eq? (car l) a)
          (add1 (occur* a (cdr l))))
         (else
           (occur* a (cdr l)))))
      (else
        (+ (occur* a (car l))
           (occur* a (cdr l)))))))

; Example of occur*
;
(occur*
  'banana
  '((banana)
    (split ((((banana ice)))
            (cream (banana))
            sherbet))
    (banana)
    (bread)
    (banana brandy)))
;==> 5

; The subst* function substitutes all olds for news in l
;
(define subst*
  (lambda (new old l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((eq? (car l) old)
          (cons new (subst* new old (cdr l))))
         (else
           (cons (car l) (subst* new old (cdr l))))))
      (else
        (cons (subst* new old (car l)) (subst* new old (cdr l)))))))

; Example of subst*
;
(subst*
  'orange
  'banana
  '((banana)
    (split ((((banana ice)))
            (cream (banana))
            sherbet))
    (banana)
    (bread)
    (banana brandy)))
;==> '((orange)
;      (split ((((orange ice)))
;              (cream (orange))
;              sherbet))
;      (orange)
;      (bread)
;      (orange brandy))

; The insertL* function insers new to the left of all olds in l
;
(define insertL*
  (lambda (new old l)
    (cond
      ((null? l) '())
      ((atom? (car l))
       (cond
         ((eq? (car l) old)
          (cons new (cons old (insertL* new old (cdr l)))))
         (else
           (cons (car l) (insertL* new old (cdr l))))))
      (else
        (cons (insertL* new old (car l)) (insertL* new old (cdr l)))))))

; Example of insertL*
;
(insertL*
  'pecker
  'chuck
  '((how much (wood)) could ((a (wood) chuck)) (((chuck)))
    (if (a) ((wood chuck))) could chuck wood))
; ==> ((how much (wood)) could ((a (wood) chuck pecker)) (((chuck pecker)))
;      (if (a) ((wood chuck pecker))) could chuck pecker wood)

; The member* function determines if element is in a list l of s-exps
;
(define member*
  (lambda (a l)
    (cond
      ((null? l) #f)
      ((atom? (car l))
       (or (eq? (car l) a)
           (member* a (cdr l))))
      (else
        (or (member* a (car l))
            (member* a (cdr l)))))))

; Example of member*
;
(member
  'chips
  '((potato) (chips ((with) fish) (chips))))    ; #t

; The leftmost function finds the leftmost atom in a non-empty list
; of S-expressions that doesn't contain the empty list
;
(define leftmost
  (lambda (l)
    (cond
      ((atom? (car l)) (car l))
      (else (leftmost (car l))))))

; Examples of leftmost
;
(leftmost '((potato) (chips ((with) fish) (chips))))    ; 'potato
(leftmost '(((hot) (tuna (and))) cheese))               ; 'hot

; Examples of not-applicable leftmost
;
; (leftmost '(((() four)) 17 (seventeen))) ; leftmost s-expression is empty
; (leftmost '())                           ; empty list

; Or expressed via cond
;
; (or a b) = (cond (a #t) (else b))

; And expressed via cond
;
; (and a b) = (cond (a b) (else #f))

; The eqlist? function determines if two lists are equal
;
(define eqlist?
  (lambda (l1 l2)
    (cond
      ; case 1: l1 is empty, l2 is empty, atom, list
      ((and (null? l1) (null? l2)) #t)
      ((and (null? l1) (atom? (car l2))) #f)
      ((null? l1) #f)
      ; case 2: l1 is atom, l2 is empty, atom, list
      ((and (atom? (car l1)) (null? l2)) #f)
      ((and (atom? (car l1)) (atom? (car l2)))
       (and (eq? (car l1) (car l2))
            (eqlist? (cdr l1) (cdr l2))))
      ((atom? (car l1)) #f)
      ; case 3: l1 is a list, l2 is empty, atom, list
      ((null? l2) #f)
      ((atom? (car l2)) #f)
      (else
        (and (eqlist? (car l1) (car l2))
             (eqlist? (cdr l1) (cdr l2)))))))
      

; Example of eqlist?
;
(eqlist?
  '(strawberry ice cream)
  '(strawberry ice cream))                  ; #t

(eqlist?
  '(strawberry ice cream)
  '(strawberry cream ice))                  ; #f

(eqlist?
  '(banan ((split)))
  '((banana) split))                        ; #f

(eqlist?
  '(beef ((sausage)) (and (soda)))
  '(beef ((salami)) (and (soda))))          ; #f

(eqlist?
  '(beef ((sausage)) (and (soda)))
  '(beef ((sausage)) (and (soda))))         ; #t

; eqlist? rewritten
;
(define eqlist2?
  (lambda (l1 l2)
    (cond
      ; case 1: l1 is empty, l2 is empty, atom, list
      ((and (null? l1) (null? l2)) #t)
      ((or (null? l1) (null? l2)) #f)
      ; case 2: l1 is atom, l2 is empty, atom, list
      ((and (atom? (car l1)) (atom? (car l2)))
       (and (eq? (car l1) (car l2))
            (eqlist2? (cdr l1) (cdr l2))))
      ((or (atom? (car l1)) (atom? (car l2)))
       #f)
      ; case 3: l1 is a list, l2 is empty, atom, list
      (else
        (and (eqlist2? (car l1) (car l2))
             (eqlist2? (cdr l1) (cdr l2)))))))

; Tests of eqlist2?
;
(eqlist2?
  '(strawberry ice cream)
  '(strawberry ice cream))                  ; #t

(eqlist2?
  '(strawberry ice cream)
  '(strawberry cream ice))                  ; #f

(eqlist2?
  '(banan ((split)))
  '((banana) split))                        ; #f

(eqlist2?
  '(beef ((sausage)) (and (soda)))
  '(beef ((salami)) (and (soda))))          ; #f

(eqlist2?
  '(beef ((sausage)) (and (soda)))
  '(beef ((sausage)) (and (soda))))         ; #t

; The equal? function determines if two s-expressions are equal
;
(define equal??
  (lambda (s1 s2)
    (cond
      ((and (atom? s1) (atom? s2))
       (eq? s1 s2))
      ((atom? s1) #f)
      ((atom? s2) #f)
      (else (eqlist? s1 s2)))))

; Examples of equal??
;
(equal?? 'a 'a)                              ; #t
(equal?? 'a 'b)                              ; #f
(equal?? '(a) 'a)                            ; #f
(equal?? '(a) '(a))                          ; #t
(equal?? '(a) '(b))                          ; #f
(equal?? '(a) '())                           ; #f
(equal?? '() '(a))                           ; #f
(equal?? '(a b c) '(a b c))                  ; #t
(equal?? '(a (b c)) '(a (b c)))              ; #t
(equal?? '(a ()) '(a ()))                    ; #t

; equal? simplified
;
(define equal2??
  (lambda (s1 s2)
    (cond
      ((and (atom? s1) (atom? s2))
       (eq? s1 s2))
      ((or (atom? s1) (atom? s2)) #f)
      (else (eqlist? s1 s2)))))

; Tests of equal2??
;
(equal2?? 'a 'a)                              ; #t
(equal2?? 'a 'b)                              ; #f
(equal2?? '(a) 'a)                            ; #f
(equal2?? '(a) '(a))                          ; #t
(equal2?? '(a) '(b))                          ; #f
(equal2?? '(a) '())                           ; #f
(equal2?? '() '(a))                           ; #f
(equal2?? '(a b c) '(a b c))                  ; #t
(equal2?? '(a (b c)) '(a (b c)))              ; #t
(equal2?? '(a ()) '(a ()))                    ; #t

; eqlist? rewritten using equal2??
;
(define eqlist3?
  (lambda (l1 l2)
    (cond
      ((and (null? l1) (null? l2)) #t)
      ((or (null? l1) (null? l2)) #f)
      (else
        (and (equal2?? (car l1) (car l2))
             (equal2?? (cdr l1) (cdr l2)))))))

; Tests of eqlist3?
;
(eqlist3?
  '(strawberry ice cream)
  '(strawberry ice cream))                  ; #t

(eqlist3?
  '(strawberry ice cream)
  '(strawberry cream ice))                  ; #f

(eqlist3?
  '(banan ((split)))
  '((banana) split))                        ; #f

(eqlist3?
  '(beef ((sausage)) (and (soda)))
  '(beef ((salami)) (and (soda))))          ; #f

(eqlist3?
  '(beef ((sausage)) (and (soda)))
  '(beef ((sausage)) (and (soda))))         ; #t

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The sixth commandment                                                      ;
;                                                                            ;
; Simplify only after the function is correct.                               ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; rember simplified, it now also works on s-expressions, not just atoms
;
(define rember
  (lambda (s l)
    (cond
      ((null? l) '())
      ((equal2?? (car l) s) (cdr l))
      (else (cons (car l) (rember s (cdr l)))))))

; Example of rember
;
(rember
  '(foo (bar (baz)))
  '(apples (foo (bar (baz))) oranges))
;==> '(apples oranges)

;
; Go get yourself this wonderful book and have fun with these examples!
;
; Shortened URL to the book at Amazon.com: http://bit.ly/4GjWdP
;
; Sincerely,
; Peteris Krumins
; http://www.catonmat.net
;

