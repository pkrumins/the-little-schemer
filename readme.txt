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
    ...
    work in progress, adding new chapters every other day


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


------------------------------------------------------------------------------

That's it. I hope you find these examples useful when reading "The Little
Schemer" yourself! Go get it at http://bit.ly/4GjWdP, if you haven't already!


Sincerely,
Peteris Krumins
http://www.catonmat.net

