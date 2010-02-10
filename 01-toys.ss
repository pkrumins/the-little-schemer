;
; Chapter 1 of The Little Schemer:
; Toys
;
; Code examples assemled by Peteris Krumins (peter@catonmat.net).
; His blog is at http://www.catonmat.net  --  good coders code, great reuse.
;
; Get yourself this wonderful book at Amazon: http://bit.ly/4GjWdP
;

; Examples of atoms:
;
'atom
(quote atom)
'turkey
1492
'*abc$
(quote *abc$)

; Examples of lists and s-expressions
;
'(atom)
(quote (atom))
'(atom turkey or)
'((atom turkey) or)
'xyz
'(x y z)
'((x y z))
'(how are you doing so far)
'(((how) are) ((you) (doing so)) far)
'()
'(() () () ())

; Example of not-lists
;
'(atom turkey) 'or      ; because it's two separate s-expressions

; Example of not-atoms
;
'()     ; because it's a list

; Examples of car
;
(car '(a b c))                ; 'a
(car '((a b c) x y z))        ; '(a b c)

; Examples of not-applicable car
;
; (car 'hotdog)     ; not-applicable because 'hotdog is not a list
; (car '())         ; not-applicable because '() is an empty list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The law of car:                                                            ;
;                                                                            ;
; The primitive /car/ is defined only for non-empty lists.                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; More examples of car
;
(car '(((hotdogs)) (and) (pickle) relish))  ; '((hotdogs))
(car (car '(((hotdogs)) (and))))            ; '(hotdogs)

; Examples of cdr
;
(cdr '(a b c))              ; '(b c)
(cdr '((a b c) x y z))      ; '(x y z)
(cdr '(hamburger))          ; '()
(cdr '((x) t r))            ; '(t r)

; Examples of not-applicable cdr
;
; (cdr 'hotdogs)    ; not-applicable because 'hotdogs is not a list
; (cdr '())         ; not-applicable because '() is an empty list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The law of cdr:                                                            ;
;                                                                            ;
; The primitive /cdr/ is defined only for non-empty lists.                   ;
; The /cdr/ of any non-empty list is always another list.                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of car and cdr
;
(car (cdr '((b) (x y) ((c)))))      ; '(x y)
(cdr (cdr '((b) (x y) ((c)))))      ; '(((c)))

; Examples of cons
;
(cons 'peanut '(butter and jelly))                  ; '(peanut butter and jelly)
(cons '(banana and) '(peanut butter and jelly))     ; '((banana and) peanut butter and jelly)
(cons '((help) this) '(is very ((hard) to learn)))  ; '(((help) this) is very ((hard) to learn))
(cons '(a b (c)) '())                               ; '((a b (c)))
(cons 'a '())                                       ; '(a)

; Examples of not-applicable cons
;
; (cons '((a b c)) 'b)  ; not-applicable because 'b is not a list
; (cons 'a 'b)          ; not-applicable because 'b is not a list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The law of cons                                                            ;
;                                                                            ;
; The primitive /cons/ takes two arguments.                                  ;
; The second argument to /cons/ must be a list.                              ;
; The result is a list.                                                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of cons, car and cdr
;
(cons 'a (car '((b) c d)))     ; (a b)
(cons 'a (cdr '((b) c d)))     ; (a c d)

; Example of the null-list
;
'()

; Examples of null?
;
(null? '())         ; true
(null? '(a b c))    ; false

; Example of not-applicable null?
;
; (null? 'spaghetti)    ; not-applicable because 'spaghetti is not a list

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The law of null?                                                           ;
;                                                                            ;
; The primitive /null?/ is defined only for lists                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; We first need to define atom? for Scheme as it's not a primitive
;
(define atom?
 (lambda (x)
    (and (not (pair? x)) (not (null? x)))))  
  
; Examples of atom?
;
(atom? 'Harry)                          ; true
(atom? '(Harry had a heap of apples))   ; false

; Examples of atom?, car and cdr
;
(atom? (car '(Harry had a heap of apples)))         ; true
(atom? (cdr '(Harry had a heap of apples)))         ; false
(atom? (cdr '(Harry)))                              ; false
(atom? (car (cdr '(swing low sweet cherry oat))))   ; true
(atom? (car (cdr '(swing (low sweet) cherry oat)))) ; false

; Examples of eq?
;
(eq? 'Harry 'Harry)         ; true
(eq? 'margarine 'butter)    ; false

; Example of not-applicable eq?
;
; (eq? '() '(strawberry))   ; not-applicable because eq? works only on atoms
; (eq? 5 6)                 ; not-applicable because eq? works only on non-numeric atoms

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The law of eq?                                                             ;
;                                                                            ;
; The primitive /eq?/ takes two arguments.                                   ;
; Each must be a non-numeric atom.                                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of eq?, car and cdr
;
(eq? (car '(Mary had a little lamb chop)) 'Mary)        ; true
(eq? (car '(beans beans)) (car (cdr '(beans beans))))   ; true


; Examples of not-applicable eq?, car and cdr
;
; (eq? (cdr '(soured milk)) 'milk)  ; not-applicable because (cdr '(...)) is a list



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                            ;
;                         This space reserved for                            ;
;                              JELLY STAINS!                                 ;
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

