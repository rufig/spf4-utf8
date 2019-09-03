\ 04-06-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ набор удобных слов для работы со стеками

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

\ -- стековые манипуляции -----------------------------------------------------

\ поменять значения данных на вершине стека со значением переменной
: change ( n addr --> [addr] ) DUP @ -ROT ! ;

\ вычислить границы массива заданного своим адресом и длинной
: bounds ( addr # --> up low ) OVER + SWAP ;

\ опустить три значения со стека данных
: 3DROP ( a b c --> ) 2DROP DROP ;

\ копировать три верхних элемента на стеке возвратов
: 3DUP ( a b c --> a b c a b c ) >R 2DUP R@ -ROT R> ;

\ удалить с вершины стека указанное число параметров
\ если нужен контроль переопустошения стека раскоментировать содержимое скобок
: nDROP ( [ .. ] n --> ) 1 + CELLS SP@ + ( S0 @ MIN) SP! ;

\ удалить нижнее двойное значение
: 2NIP ( da db --> db ) 2SWAP 2DROP ;

\ упорядочить значения по возрастанию
: RANKING ( a b --> a b ) 2DUP MIN -ROT MAX ;

\ выравнять число base на указанное значение n »
\ граница выравнивания произвольная.
\ выравнивание производится в большую сторону
: ROUND ( n base --> n ) TUCK 1 - + OVER / * ;

\ выделить на стеке данных место под массив
\ вернуть неинициализированный массив и его длину на вершине стека
: FRAME ( # --> [frame] # ) >R SP@ R@ CELLS - SP! R> ;

\ -- логические операции ------------------------------------------------------

\ Получить по номеру бита его маску
: ?BIT  ( N --> mask ) 1  SWAP LSHIFT ;

\ получить по номеру бита его инверсную маску
: N?BIT ( N --> mask ) ?BIT INVERT ;

\ вернуть TRUE если выполняется условие a < или = b, иначе FALSE
: >= ( a b --> flag ) < 0= ;

?DEFINED test{ \EOF -- тестовая секция ---------------------------------------

test{ \ тут просто проверка на собираемость.
  S" passed" TYPE
}test
