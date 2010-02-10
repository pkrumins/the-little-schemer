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

The first commandment:
Always ask null? as the first question in expressing any function.


------------------------------------------------------------------------------

That's it. I hope you find these examples useful when reading "The Little
Schemer" yourself! Go get it at http://bit.ly/4GjWdP, if you haven't already!


Sincerely,
Peteris Krumins
http://www.catonmat.net

