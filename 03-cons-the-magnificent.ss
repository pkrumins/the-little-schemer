;
; Chapter 3 of The Little Schemer:
; Cons the Magnificent
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

; The rember function removes the first occurance of the given atom from the
; given list.
;
(define rember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) a) (cdr lat))
      (else (cons (car lat)
                  (rember a (cdr lat)))))))

; Examples of rember function
;
(rember 'mint '(lamb chops and mint flavored mint jelly)) ; '(lamb chops and flavored mint jelly)
(rember 'toast '(bacon lettuce and tomato))               ; '(bacon lettuce and tomato)
(rember 'cup '(coffee cup tea cup and hick cup))          ; '(coffee tea cup and hick cup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The second commandment                                                     ;
;                                                                            ;
; Use /cons/ to build lists.                                                 ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The firsts function builds a list of first s-expressions
;
(define firsts
  (lambda (l)
    (cond
      ((null? l) '())
      (else
        (cons (car (car l)) (firsts (cdr l)))))))

; Examples of firsts
;
(firsts '((apple peach pumpkin)
          (plum pear cherry)
          (grape raisin pea)
          (bean carrot eggplant)))                     ; '(apple plum grape bean)

(firsts '((a b) (c d) (e f)))                          ; '(a c e)
(firsts '((five plums) (four) (eleven green oranges))) ; '(five four eleven)
(firsts '(((five plums) four)
          (eleven green oranges)
          ((no) more)))                                ; '((five plums) eleven (no))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The third commandment                                                      ;
;                                                                            ;
; When building lists, describe the first typical element, and then /cons/   ;
; it onto the natural recursion.                                             ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The insertR function inserts the element new to the right of the first
; occurence of element old in the list lat
;
(define insertR
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons old (cons new (cdr lat))))
      (else
        (cons (car lat) (insertR new old (cdr lat)))))))

; Examples of insertR
;
(insertR
  'topping 'fudge
  '(ice cream with fudge for dessert)) ; '(ice cream with fudge topping for dessert)

(insertR
  'jalapeno
  'and
  '(tacos tamales and salsa))          ; '(tacos tamales and jalapeno salsa)

(insertR
  'e
  'd
  '(a b c d f g d h))                  ; '(a b c d e f g d h)

; The insertL function inserts the element new to the left of the first
; occurrence of element old in the list lat
;
(define insertL
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons new (cons old (cdr lat))))
      (else
        (cons (car lat) (insertL new old (cdr lat)))))))

; Example of insertL
;
(insertL
  'd
  'e
  '(a b c e g d h))                    ; '(a b c d e g d h)

; The subst function substitutes the first occurence of element old with new
; in the list lat
;
(define subst
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons new (cdr lat)))
      (else
        (cons (car lat) (subst new old (cdr lat)))))))

; Example of subst
;
(subst
  'topping
  'fudge
  '(ice cream with fudge for dessert)) ; '(ice cream with topping for dessert)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                 Go cons a piece of cake onto your mouth.                   ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The subst2 function substitutes the first occurence of elements o1 or o2
; with new in the list lat
;
(define subst2
  (lambda (new o1 o2 lat)
    (cond
      ((null? lat) '())
      ((or (eq? (car lat) o1) (eq? (car lat) o2))
       (cons new (cdr lat)))
      (else
        (cons (car lat) (subst new o1 o2 (cdr lat)))))))

; Example of subst2
;
(subst2
  'vanilla
  'chocolate
  'banana
  '(banana ice cream with chocolate topping))  ; '(vanilla ice cream with chocolate topping)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;       If you got the last function, go and repeat the cake-consing.        ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The multirember function removes all occurances of a from lat
;
(define multirember
  (lambda (a lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) a)
       (multirember a (cdr lat)))
      (else
        (cons (car lat) (multirember a (cdr lat)))))))

; Example of multirember
;
(multirember
  'cup
  '(coffee cup tea cup and hick cup))    ; '(coffee tea and hick)

; The multiinsertR function inserts the element new to the right of all
; occurences of element old in the list lat
;
(define multiinsertR
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons old (cons new (multiinsertR new old (cdr lat)))))
      (else
        (cons (car lat) (multiinsertR new old (cdr lat)))))))

; Example of multiinsertR
;
(multiinsertR
  'x
  'a
  '(a b c d e a a b))  ; (a x b c d e a x a x b)


; The multiinsertL function inserts the element new to the left of all
; occurences of element old in the list lat
;
(define multiinsertL
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons new (cons old (multiinsertL new old (cdr lat)))))
      (else
        (cons (car lat) (multiinsertL new old (cdr lat)))))))

; Example of multiinsertL
;
(multiinsertL
  'x
  'a
  '(a b c d e a a b))  ; (x a b c d e x a x a b)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The fourth commandment (preliminary)                                       ;
;                                                                            ;
; Always change at least one argument while recurring. It must be changed to ;
; be closer to termination. The changing argument must be tested in the      ;
; termination condition: when using cdr, test the termination with null?.    ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The multisubst function substitutes all occurence of element old with new
; in the list lat
;
(define multisubst
  (lambda (new old lat)
    (cond
      ((null? lat) '())
      ((eq? (car lat) old)
       (cons new (multisubst new old (cdr lat))))
      (else
        (cons (car lat) (multisubst new old (cdr lat)))))))

; Example of multisubst
;
(multisubst
  'x
  'a
  '(a b c d e a a b))  ; (x b c d e x x b)

;
; Go get yourself this wonderful book and have fun with these examples!
;
; Shortened URL to the book at Amazon.com: http://bit.ly/4GjWdP
;
; Sincerely,
; Peteris Krumins
; http://www.catonmat.net
;

