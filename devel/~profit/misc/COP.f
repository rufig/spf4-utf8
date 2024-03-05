REQUIRE /TEST ~profit/lib/testing.f

\ inspired by ~mlg/COP-93/cop93.html

MODULE: mechanisms

0 VALUE cur-status-variable

: undefined-status ( addr u status -- ) ." undefined-status: " DUP @ WordByAddr TYPE ."  in " WordByAddr TYPE ." ::" TYPE ;
\ undefined method for status, error reporting with RTTI

: trigger ( addr "word" -- )
CREATE , LATEST-NAME-XT , DOES> 2@ ! ;

EXPORT

: :+ ( "word" -- )
>IN @ >R
NextWord 2DUP SFIND 0= IF 2DROP 0 THEN
R> >IN ! ( addr u xt|0 )
WARNING @ WARNING 0! : WARNING !
cur-status-variable LIT, POSTPONE @
cur-status-variable @ LIT, \ текущее состояние механизма

?DUP 0= IF ( addr u )
POSTPONE <> 0 ?BRANCH, >MARK 1
2SWAP SLIT,
cur-status-variable LIT,
['] undefined-status BRANCH,
>ORESOLVE
ELSE
POSTPONE = ?BRANCH,
2DROP
THEN ;


: MECHANISM ( "word" -- )
CREATE HERE 0 , ( status )
TO cur-status-variable
DOES> trigger
LATEST-NAME-XT EXECUTE ;

: STATUS ( "word" -- )
CREATE cur-status-variable , DOES> @ @ ;

;MODULE

/TEST

MECHANISM animals \ new 'animals' mechanism (set of methods)
STATUS get-animal \ define getter for 'animals' status

animals dog \ create a new 'dog' status for 'animals' mechanism
:+ name-yourself ." dog " ;
:+ make-noise ." bow" ;

animals cat
:+ name-yourself ." cat " ;
:+ make-noise ." meow" ;

animals fish
:+ name-yourself ." fish " ;
:+ make-noise ;

animals cuckoo
:+ name-yourself ." cuckoo " ;
:+ make-noise name-yourself ;

animals dragon

CR dog \ saying 'dog' changes status of 'animals' mechanism
name-yourself make-noise \ call status-depended methods
CR fish name-yourself make-noise
CR cat name-yourself make-noise
CR cuckoo name-yourself make-noise
CR dragon name-yourself make-noise \ this should give an 'undefined status' errors

CR CR
cat get-animal ( status )
dog make-noise
CR 
EXECUTE make-noise


\ lib/ext/disasm.f SEE name-yourself