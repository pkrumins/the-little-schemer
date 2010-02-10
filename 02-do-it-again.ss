;
; Chapter 2 of The Little Schemer:
; Do It, Do It Again, and Again, and Again ...
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

; lat? function finds if all the elements in the list are atoms
; (lat stands for list of atoms)
;
(define lat?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((atom? (car l)) (lat? (cdr l)))
      (else #f))))
    
; Examples of lats:
;
(lat? '(Jack Sprat could eat no chicken fat))
(lat? '())
(lat? '(bacon and eggs))

; Examples of not-lats:
;
(lat? '((Jack) Sprat could eat no chicken fat)) ; not-lat because (car l) is a list
(lat? '(Jack (Sprat could) eat no chicken fat)) ; not-lat because l contains a list
(lat? '(bacon (and eggs)))                      ; not-lat because '(and eggs) is a list

; Examples of or:
;
(or (null? '()) (atom? '(d e f g)))             ; true
(or (null? '(a b c)) (null? '()))               ; true
(or (null? '(a b c)) (null? '(atom)))           ; false

; member? function determines if an element is in a lat (list of atoms)
;
(define member?
  (lambda (a lat)
    (cond
      ((null? lat) #f)
      (else (or (eq? (car lat) a)
                (member? a (cdr lat)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
; The first commandment (preliminary)                                        ;
;                                                                            ;
; Always ask /null?/ as the first question in expressing any function.       ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of member? succeeding
;
(member? 'meat '(mashed potatoes and meat gravy))
(member? 'meat '(potatoes and meat gravy))
(member? 'meat '(and meat gravy))
(member? 'meat '(meat gravy))

; Examples of member? failing
(member? 'liver '(bagels and lox))
(member? 'liver '())



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                         This space is for doodling                         ;
;                                                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;
; Go get yourself this wonderful book and have fun with these examples!
;
; Shortened URL to the book at Amazon.com: http://bit.ly/4GjWdP
;
; Sincerely,
; Peteris Krumins
; http://www.catonmat.net
;

