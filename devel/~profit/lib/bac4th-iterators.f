\ Последовательный пробег по диапазону чисел. От одного до ста,
\ от двух до пяти, от начала одной ячейки к памяти к другой и т.д.

\ Сделано: разрешение обратных проходов с отрицательным шагом.
\ Вопрос: при отрицательном step, должен ли быть отрицательным len?
\ Ответ: чтобы работали iterateByByteValues и прочие, step не должен 
\ быть отрицательным. Поэтому отрицательным должен становится len

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE compiledCode ~profit/lib/bac4th-closures.f

\ Разворот начала и длины для прохода тех же самых значений в обратном порядке
: reverse ( start len -- start+len -len ) DUP NEGATE -ROT + 1- SWAP ;

\ Самый простой (и надёжный) вариант
: iterateBy1  ( start len step --> i \ i <-- i ) PRO LOCAL step step !
OVER + SWAP ?DO
I CONT DROP
step @ +LOOP ;

\ Вариант посложнее, без DO LOOP и использования R-стека
: iterateBy2  ( start len step --> i \ i <-- i ) PRO
LOCAL step step !
OVER +
LOCAL end DUP end !
OVER > IF
BEGIN
CONT
step @ +
DUP end @ < 0= UNTIL
ELSE
BEGIN
CONT
step @ -
DUP end @ > 0= UNTIL
THEN DROP ;

\ Вариант с динамической генерацией кода цикла
: iterateBy3  ( start len step --> i \ i <-- i ) PRO
OVER >R >R
OVER + ( start end  R: len step )
SWAP R> SWAP ( end step start  R: len )
R> 0 > IF
" LITERAL
BEGIN
[ R@ENTER, ]
LITERAL +
DUP LITERAL < 0= UNTIL
DROP RDROP"
ELSE
" LITERAL
BEGIN
[ R@ENTER, ]
LITERAL -
DUP LITERAL > 0= UNTIL
DROP RDROP"
THEN
STRcompiledCode ENTER CONT ;

\ Главное слово итерирования, совершает пару проверок и решает какой из вариантов (2-й или 3-й)
\ будет задействован
: iterateBy ( start len step --> i \ i <-- i )
OVER 0= IF 2DROP DROP RDROP EXIT THEN \ если длина нулевая или меньше, значит делать больше нам нечего..
2DUP 6 LSHIFT ( 2* 2* 2* 2* 2* 2* ) SWAP ABS >
\ Решаем: если кол-во итераций в цикле будет меньше чем, скажем 64 (взято с потолка),
IF RUSH> iterateBy2 ELSE
\ то циклуем статически,
   RUSH> iterateBy3 THEN ;
\ иначе, если больше чем 64, -- то генерируем цикл и пускаем в нём

  \ : iterateBy RUSH> iterateBy1 ;
\ ^-- "разбить в случае аварии" (с) (программы)
\ Если будет глючить в итераторах, можно временно попробовать
\ включить старый, добрый и простой как мычание iterateBy1

: iterateByBytes ( addr u <--> caddr )        1 RUSH> iterateBy ;
\ Только на первый взгляд бесмысленно использовать RUSH>
\ Если писать iterateByBytes без безусловного перехода в RUSH> 
\ пришлось бы для сохранения линии "успеха" (нырка), ставить 
\ скобки PRO ... CONT и это мало того что бесполезно съело бы 
\ значение на L-стеке, но и замедлило бы итерирование.

: iterateByWords ( addr u <--> waddr )        2 RUSH> iterateBy ;
: iterateByCells ( addr u <--> addr )      CELL RUSH> iterateBy ;
: iterateByDCells ( addr u <--> qaddr ) 2 CELLS RUSH> iterateBy ;

: iterateByByteValues ( addr n <--> char ) PRO       iterateByBytes DUP C@ CONT DROP ;
: iterateByWordValues ( addr n <--> word ) PRO 2*    iterateByWords DUP W@ CONT DROP ;
: iterateByCellValues ( addr n <--> cell )  PRO CELLS iterateByCells DUP @ CONT DROP ;

: times ( n --> \ <-- ) 1 SWAP 1 RUSH> iterateBy ;

/TEST
: printByOne iterateByByteValues DUP EMIT ." _" ;
$> S" abc" printByOne  S" ]" TYPE

$> S" abc" reverse  printByOne  S" ]" TYPE

: 10-3. 10 -3 1 iterateBy DUP . ;
$> 10-3.

: 1-100. 1 100 1 iterateBy DUP . ;
$> 1-100.

: 150-50. 150 -100 1 iterateBy DUP . ;
$> 150-50.

: 0. 150 0 1 iterateBy DUP . ;
$> 0.

: s 100 0 DO +{ 1 200000 1 iterateBy DUP }+ . LOOP ;
\ ResetProfiles s .AllStatistic