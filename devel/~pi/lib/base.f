\ Библиотека для вывода числа в различных счислениях на консоль
\ Pretorian 2007 v1.1

\ Вывести на консоль число в двоичной форме
: .BIN ( n -> n )
	BASE @ 2 BASE ! SWAP . BASE ! ;

\ Вывести на консоль без знаковое число в двоичной форме
: .UBIN ( n -> )
	BASE @ 2 BASE ! SWAP U. BASE ! ;

\ Вывести на консоль число в восьмеричной форме
: .OCT ( n -> )
	BASE @ 8 BASE ! SWAP . BASE ! ;

\ Вывести на консоль без знаковое число в восьмеричной форме
: .UOCT ( n -> )
	BASE @ 8 BASE ! SWAP U. BASE ! ;

\ Вывести на консоль число без знаковое в десятичной форме
: .DEC ( n -> )
	BASE @ 10 BASE ! SWAP . BASE ! ;

\ Вывести на консоль без знаковое число в десятичной форме
: .UDEC ( n -> )
	BASE @ 10 BASE ! SWAP U. BASE ! ;

\ Вывести на консоль число в шестнадцатиричной форме
: .HEX ( n -> )
	BASE @ 16 BASE ! SWAP . BASE ! ;

\ Вывести на консоль без знаковое число в шестнадцатиричной форме
: .UHEX ( n -> )
	BASE @ 16 BASE ! SWAP U. BASE ! ;

\EOF

.BIN	( n -> ) - вывести на консоль число в двоичной форме
.UBIN	( n -> ) - вывести на консоль без знаковое число в двоичной форме
.OCT	( n -> ) - вывести на консоль число в восьмеричной форме
.UOCT	( n -> ) - вывести на консоль без знаковое число в восьмеричной форме
.DEC	( n -> ) - вывести на консоль число в десятичной форме
.DEC	( n -> ) - вывести на консоль число без знаковое в десятичной форме
.HEX	( n -> ) - вывести на консоль число в шестнадцатиричной форме
.UHEX	( n -> ) - вывести на консоль без знаковое число в шестнадцатиричной форме

