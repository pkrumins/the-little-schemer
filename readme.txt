This repository contains all the code examples from the book "The Little
Schemer." The code in this book is presented in a subset version of the Scheme
programming language. The book is a dialogue between you and the authors about
interesting examples of Scheme programs and it teaches you to think
recursively.

If you're interested, get the book from Amazon: http://bit.ly/4GjWdP

The code examples were copied (and completed where necessary) from
"The Little Schemer" by Peteris Krumins (peter@catonmat.net).

His blog is at http://www.catonmat.net  --  good coders code, great reuse.

------------------------------------------------------------------------------

Table of contents:
    [01] Chapter  1: Toys
         01-toys.ss
    [02] Chapter  2: Do It, Do It Again, and Again, and Again...
         02-do-it-again.ss
    [03] Chapter  3: Cons the Magnificent
         03-cons-the-magnificent.ss
    [04] Chapter  4: Numbers Games
         04-numbers-games.ss
    [05] Chapter  5: *Oh My Gawd*: It's Full of Stars
         05-full-of-stars.ss
    [06] Chapter  6: Shadows
         06-shadows.ss
    [07] Chapter  7: Shadows
         07-friends-and-relations.ss
    [08] Chapter  8: Lambda the Ultimate
         08-lambda-the-ultimate.ss
    [09] Chapter  9: ... and Again, and Again, and Again ...
         09-and-again.ss
    [10] Chapter 10: What Is the Value of All of This?
         10-value-of-all-of-this.ss


[01]-Chapter-1-Toys-----------------------------------------------------------

See 01-toys.ss file for code examples.

Chapter 1 introduces language primitives, operations and tests on them.

The primitives include: atoms, lists and s-expressions.
Operations include: car, cdr, cons.
Tests include: null?, atom?, eq?.

It also defines five rules on using car, cdr, cons, null? and eq?.

The law of car:   The primitive car is defined only for non-empty lists.
The law of cdr:   The primitive cdr is defined only for non-empty lists.
                  The cdr of any non-empty list is always another list.
The law of cons:  The primitive cons takes two arguments.
                  The second argument to cons must be a list.
                  The result is a list.
The law of null?: The primitive null? is defined only for lists.
The law of eq?:   The primitive eq? takes two arguments.
                  Each must be a non-numeric atom.


.----------------------------------------------------------------------------.
|                                                                            |
|                         This space reserved for                            |
|                              JELLY STAINS!                                 |
|                                                                            |
'----------------------------------------------------------------------------'


[02]-Chapter-2-Do-It-Do-It-Again-and-Again-and-Again--------------------------

See 02-do-it-again.ss file for code examples.

Chapter 2 introduces two recursive functions and steps through them again, and
again, and again until you understand recursion.

The first function introduced is lat? that tests if the given list consists
only of atoms (lat stands for list of atoms).

The second function introduced is member? that tests if an element is in a
lat.

It also defines a preliminary version of the first commandment that always
should be followed when programming recursively.

.----------------------------------------------------------------------------.
| The first commandment: (preliminary version)                               |
|                                                                            |
| Always ask null? as the first question in expressing any function.         |
'----------------------------------------------------------------------------'


[03]-Chapter-3-Cons-the-Magnificent-------------------------------------------

See 03-cons-the-magnificent.ss file for code examples.

Chapter 3 explains how to build lists with cons. It's done via showing how to
write a function that removes an element from the list. Then the second
commandment is presented.

.----------------------------------------------------------------------------.
| The second commandment:                                                    |
|                                                                            |
| Use cons to build lists.                                                   |
'----------------------------------------------------------------------------'

Next, it's precisely explained how to do recursion and when to stop recursing,
this leads to the third commandment and a preliminary version of the fourth
commandment. The examples include a function that inserts an element in a list
to the right and to the left of the given element, and a function that removes
the first occurrence of an element from a list.

.----------------------------------------------------------------------------.
| The third commandment:                                                     |
|                                                                            |
| When building lists, describe the first typical element, and then cons it  |
| onto the natural recursion.                                                |
'----------------------------------------------------------------------------'

Next the multi-versions of the same functions are written that insert element
to the right and to the left of all occurrences of the given element in a list,
and a function that removes all occurrences of an element from a list.

.----------------------------------------------------------------------------.
| The fourth commandment: (preliminary version)                              |
|                                                                            |
| Always change at least one argument while recurring. It must be changed to |
| be closer to termination. The changing argument must be tested in the      |
| termination condition: when using cdr, test the termination with null?.    |
'----------------------------------------------------------------------------'

[04]-Chapter-4-Numbers-Games--------------------------------------------------

See 04-numbers-games.ss file for code examples.

Chapter 4 builds the arithmetic system from the primitives add1 and sub1.

Using add1 the usual + addition operation on two numbers is developed, next
using sub1 the usual - subtraction operation is developed, then multiplication
and exponentiation are written.

Along the way the first and fourth commandments are revisited:

.----------------------------------------------------------------------------.
| The first commandment (first revision)                                     |
|                                                                            |
| When recurring on a list of atoms, lat, ask two questions about it:        |
| (null? lat) and else.                                                      |
| When recurring on a number, n, ask two questions about it: (zero? n) and   |
| else.                                                                      |
'----------------------------------------------------------------------------'

.----------------------------------------------------------------------------.
| The fourth commandment (first revision)                                    |
|                                                                            |
| Always change at least one argument while recurring. It must be changed to |
| be closer to termination. The changing argument must be tested in the      |
| termination condition:                                                     |
| when using cdr, test the termination with null? and                        |
| when using sub1, test termination with zero?.                              |
'----------------------------------------------------------------------------'

And the fifth commandment is postulated:

.----------------------------------------------------------------------------.
| The fifth commandment                                                      |
|                                                                            |
| When building a value with o+, always use 0 for the value of the           |
| terminating line, for adding 0 does not change the value of an addition.   |
|                                                                            |
| When building a value with o*, always use 1 for the value of the           |
| terminating line, for multiplying by 1 does not change the value of a      |
| multiplication.                                                            |
|                                                                            |
| When building a value with cons, always consider () for the value of the   |
| terminating line.                                                          |
'----------------------------------------------------------------------------'

Next the < greater than and > less than operations are derived, then the =
equals operation and quotient operation.

Then various utility functions are written, such as length that determines the
length of a list, pick that picks the n-th element from the list, rempick that
removes the n-th element from the list, no-nums that extracts all non-numeric
elements from the list, all-nums that does the opposite and extracts all
numeric elements from the list.

[05]-Chapter-5-Oh-My-Gawd-It's-Full-of-Stars----------------------------------

See 05-full-of-stars.ss file for code examples.

Chapter 5 introduces you to S-expressions and functions that manipulate them.

The first commandment is finalized:

.----------------------------------------------------------------------------.
| The first commandment (final version)                                      |
|                                                                            |
| When recurring on a list of atoms, lat, ask two questions about it:        |
| (null? lat) and else.                                                      |
| When recurring on a number, n, ask two questions about it: (zero? n) and   |
| else.                                                                      |
| When recurring on a list of S-expressions, l, ask three questions about    |
| it: (null? l), (atom? (car l)), and else.                                  |
'----------------------------------------------------------------------------'

And the fourth commandment is stated:

.----------------------------------------------------------------------------.
| The fourth commandment (final version)                                     |
|                                                                            |
| Always change at least one argument while recurring. When recurring on a   |
| list of atoms, lat, use (cdr l). When recurring on a number, n, use        |
| (sub1 n). And when recurring on a list of S-expressions, l, use (car l)    |
| and (cdr l) if neither (null? l) nor (atom? (car l)) are true.             |
|                                                                            |
| It must be changed to be closer to termination. The changing argument must |
| be tested in the termination condition:                                    |
| * when using cdr, test the termination with null? and                      |
| * when using sub1, test termination with zero?.                            |
'----------------------------------------------------------------------------'

Functions rember, insertR, insertL, occur, subst, member are then rewritten to
manipulate S-expressions and not just lists of atoms.

Then functions for comparing two S-expressions are written, and rewritten
several times to teach you Scheme for great good.

Finally the sixth commandment is presented:

.----------------------------------------------------------------------------.
| The sixth commandment                                                      |
|                                                                            |
| Simplify only after the function is correct.                               |
'----------------------------------------------------------------------------'

[06]-Chapter-6-Shadows--------------------------------------------------------

See 06-shadows.ss file for code examples.

Chapter 6 develops an evaluator for simple arithmetic expressions involving
only +, * and exp.

The seventh commandment is formulated as evaluator is developed:

.----------------------------------------------------------------------------.
| The seventh commandment                                                    |
|                                                                            |
| Recur on the subparts that are of the same nature:                         |
| * On the sublists of a list.                                               |
| * On the subexpressions of an arithmetic expression.                       |
'----------------------------------------------------------------------------'

Next different representations for arithmetic expressions are introduced. An
expression (1 + 2) can be written as (+ 1 2) and (1 2 +) or even (plus 1 2).

The concept of abstraction from representations is introduced. The eighth
commandment follows:

.----------------------------------------------------------------------------.
| The eighth commandment                                                     |
|                                                                            |
| Use help functions to abstract from representations.                       |
'----------------------------------------------------------------------------'

Finally chapter shows how numbers 0, 1, 2, ... can be represented purely as
lists. The number 0 becomes (), number 1 becomes (()), 2 becomes (() ()),
3 becomes (() () ()), ... . Then functions for adding, subtracting and
checking if the new number is zero are written. But beware of shadows, the
lat? function doesn't work on a list of these numbers.


[07]-Chapter-7-Friends-and-Relations------------------------------------------

See 07-friends-and-relations.ss file for code examples.

Chapter 7 is all about sets. It defines functions to test if the given list is
a set, to construct a set from a list, to test if set1 is a subset of set2, to
determine if two sets are equal, to find intersect of two sets, to fund
intersect of a bunch of sets, to find union of two sets.

Then it introduces pairs and writes several helper functions: first that
returns the first element of a pair, second that returns the second element of
a pair, and build that builds a pair. (Remember commandment eight.)

Then it plays with mathematical functions. It introduces relations, creates
functions to reverse relations, and test if the given list of relations is a
function and is it a full function.


[08]-Chapter-8-Lambda-the-Ultimate--------------------------------------------

See 08-lambda-the-ultimate.ss file for code examples.

Chapter 8 introduces the concept that functions can be passed and returned
from functions. It also introduces currying.

Next it reviews several functions from Chapter 3 and shows how they differ
only by two lines. Those lines can be factored out as separate functions that
simplifies the whole thing.

The ninth commandment follows.

.----------------------------------------------------------------------------.
| The ninth commandment                                                      |
|                                                                            |
| Abstract common patterns with a new function.                              |
'----------------------------------------------------------------------------'

Finally continuations are introduced via a bunch of examples, for example,
multirember&co function collects the elements to be removed in one list, and
the elements that were not removed in the other. After it's done, the
collector is called, which is your own function so you may do anything you
wish with those two lists.

The final, tenth commandment, is stated.

.----------------------------------------------------------------------------.
| The tenth commandment                                                      |
|                                                                            |
| Build functions to collect more than one value at a time.                  |
'----------------------------------------------------------------------------'

And remember, an apple a day keeps the doctor away.


[09]-Chapter-9-and-Again-and-Again-and-Again----------------------------------

See 09-and-again.ss file for code examples.

...

Used this chapter to write an article on derivation of Y-Combinator:
http://www.catonmat.net/blog/derivation-of-ycombinator/

...


[10]-Chapter-10-What-Is-the-Value-of-All-of-This------------------------------

See 10-value-of-all-of-this.ss file for code examples.

Chapter 10 implements Scheme in Scheme. That's it.

It was a great adventure and now it's time for banquet!


------------------------------------------------------------------------------

That's it. I hope you find these examples useful when reading "The Little
Schemer" yourself! Go get it at http://bit.ly/4GjWdP, if you haven't already!


Sincerely,
Peteris Krumins
http://www.catonmat.net

