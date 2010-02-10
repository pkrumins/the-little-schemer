;
; Chapter 3 of The Little Schemer:
; Cons the Magnificent
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We need to define atom? for Scheme as it's not a primitive                 ;
;                                                                            ;
(define atom?                                                                ;
 (lambda (x)                                                                 ;
    (and (not (pair? x)) (not (null? x)))))                                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

; got tired, gonna finish later

;
; Go get yourself this wonderful book and have fun with these examples!
;
; Shortened URL to the book at Amazon.com: http://bit.ly/4GjWdP
;
; Sincerely,
; Peteris Krumins
; http://www.catonmat.net
;

