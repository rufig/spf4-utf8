\ Промежуточная версия с перебором в ширину

REQUIRE FOR ~profit/lib/for-next.f
REQUIRE ENUM ~nn/lib/enum.f
REQUIRE { lib/ext/locals.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE iterateByCellValues ~profit/lib/bac4th-iterators.f
REQUIRE fetchCell ~profit/lib/fetchWrite.f
REQUIRE CASE lib/ext/case.f 

1 CONSTANT firstOp

firstOp
ENUM SWAPop
ENUM DUPop
ENUM DROPop
ENUM OVERop
ENUM ROTop
CONSTANT operations

0 VALUE previousOp
0 VALUE previousOp2

4 CONSTANT maxOperations \ максимальное кол-во операций
CREATE operationsNumber maxOperations CELLS ALLOT \ берём пространство для операция
operationsNumber HERE OVER - ERASE \ очищаем память заранее
operationsNumber VALUE lastOperation \ пока операций нет

: addOperation ( op -- )  lastOperation !  lastOperation CELL+ TO lastOperation ;
: operationsCount  ( -- n ) lastOperation operationsNumber - CELL / ;

firstOp addOperation \ первая комбинация

: printOp ( op -- op )  DUP CASE
SWAPop OF ." SWAP " ENDOF
DUPop  OF ." DUP "  ENDOF
DROPop OF ." DROP " ENDOF
OVERop OF ." OVER " ENDOF
ROTop  OF ." ROT "  ENDOF ENDCASE ;

: checkOpTable ( op --> op ) PRO DUP           CASE
SWAPop OF previousOp SWAPop = ONFALSE    ENDOF
DROPop OF previousOp DUPop = ONFALSE
          previousOp OVERop = ONFALSE    ENDOF
ROTop  OF previousOp previousOp2 =
          previousOp ROTop = AND ONFALSE ENDOF ENDCASE CONT ;

: incrementOperations { \ [ CELL ] A -- }
operationsNumber A !
BEGIN A @ 1+!
A @ @ operations = WHILE
firstOp A writeCell REPEAT
A @ CELL+ lastOperation MAX TO lastOperation ;

: iterateOperations PRO operationsNumber operationsCount iterateByCellValues CONT ;

: printOps iterateOperations printOp ;
: checkOperations PRO
ALL iterateOperations ARE  
checkOpTable
previousOp TO previousOp2
DUP TO previousOp \ сохраняем предыдущую операцию
OTHER DROP WISE CONT ;

: operationsValid ( -- f ) PREDICATE checkOperations SUCCEEDS ;


: iterations BEGIN
incrementOperations START{ checkOperations CR printOps }EMERGE
operationsCount maxOperations > UNTIL ;

TIMER@ NIP .
iterations
TIMER@ NIP .