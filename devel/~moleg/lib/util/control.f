\ 19-04-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ структуры управления: ветвления и циклы
\ можно использовать даже во время исполнения.

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE IFNOT    devel\~moleg\lib\util\ifnot.f
 REQUIRE ;stop    devel\~moleg\lib\util\run.f

\ Начало ветвления. Код за словом IF выполняется в случае, если flag <> 0
: IF ( flag --> )
     STATE @ IFNOT init: THEN
     2 controls +!
     HERE ?BRANCH, >MARK 1 ; IMMEDIATE

\ Альтернативное ветвление. Код за else выполняется в случае, если
\ пропущен код за основным: IF или IFNOT ветвлением.
: ELSE ( --> ) ?COMP HERE BRANCH, >RESOLVE  >MARK 2  ; IMMEDIATE

\ Описатель начала цикла. На код за словом BEGIN передается управление
\ в случае повторений цикла
: BEGIN ( --> )
        STATE @ IFNOT init: THEN
        2 controls +!
        <MARK 3 ; IMMEDIATE

\ возврат без условий на точку BEGIN. Отмечает конец кода бесконечного цикла.
: AGAIN ( --> )
        ?COMP -2 controls +!
        3 = IFNOT -2006 THROW THEN  BRANCH,
        controls @ IFNOT ;stop THEN ; IMMEDIATE

\ Возврат на точку после BEGIN если flag <> 0 (цикл с постусловием)
: UNTIL ( flag --> )
        ?COMP -2 controls +!
        3 = IFNOT -2004 THROW THEN ?BRANCH,
        controls @ IFNOT ;stop THEN ; IMMEDIATE

\ условный выход из цикла, если flag = 0
\ используется между BEGIN и REPEAT, отмечающими начало и конец цикла
: WHILE ( flag --> )
        ?COMP 2 controls +!
        HERE ?BRANCH, >MARK 1 2SWAP ; IMMEDIATE

\ условынй выход из цикла, если flag <> 0. Используется аналогично WHILE
: WHILENOT ( flag --> )
           ?COMP 2 controls +!
           HERE N?BRANCH, >MARK 1 2SWAP ; IMMEDIATE

\ безусловный возврат на BEGIN. Используется вместе с BEGIN и WHILE
: REPEAT ( --> )
         ?COMP -4 controls +!
         3 = IFNOT -2005 THROW THEN BRANCH, >RESOLVE
         controls @ IFNOT ;stop THEN ; IMMEDIATE

\ Начало ветвления. Промежуточное имя.
: ifnot ( flag --> )
        STATE @ IFNOT init: THEN
        2 controls +!
        HERE N?BRANCH, >MARK 1 ;

\ Конец ветвления. На точку за THEN переходит управление после выполнения
\ одной из альтернатив, то есть кода после IF IFNOT или ELSE
: THEN ( --> )
       ?COMP -2 controls +!
       >RESOLVE
       controls @ IFNOT ;stop THEN ; IMMEDIATE

\ Начало ветвления. Код за словом IFNOT выполняется в случае, если flag = 0
: IFNOT ifnot ; IMMEDIATE

?DEFINED test{ \EOF -- тестовая секция ---------------------------------------

test{ 123 456 FALSE IF DROP ELSE NIP THEN 456 <> THROW
      123 456 TRUE IF DROP ELSE NIP THEN 123 <> THROW
   S" passed" TYPE
}test

\EOF -- примеры использования ------------------------------------------------

S" должно быть true = " TYPE  1 IF ." true " ELSE ." false " THEN CR
S" должно быть false = " TYPE 0 IF ." true " ELSE ." false " THEN CR
: testa IF ." true " ELSE ." false " THEN CR ;

S" должно быть true = " TYPE  1 testa
S" должно быть false = " TYPE 0 testa

S" убывающий ряд от 10 до 0 = " TYPE 10
 BEGIN DUP . DUP WHILE 1 - REPEAT DROP CR

S" убывающий ряд от 10 до 1 = " TYPE 10
 BEGIN DUP . 1 - DUP 0= UNTIL DROP CR

S" убывающий ряд от 9 до 6 = "  TYPE 10
 BEGIN 1 - DUP WHILE DUP 5 <> WHILE DUP . REPEAT THEN DROP CR

S" убывающий ряд от 10 до 6 = " TYPE 10
 BEGIN DUP . 1 - DUP WHILE DUP 5 = UNTIL ELSE THEN DROP CR
