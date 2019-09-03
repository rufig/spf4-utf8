REQUIRE STR@ ~ac/lib/str5.f
REQUIRE [DEFINED] lib/include/tools.f
REQUIRE state-table ~profit/lib/chartable.f

\ "Шаблонный" (generic) автоматный обработчик ввода
\ _выражений_ в ячейку. Из поданного на вход строкового 
\ представления выражения выделяет следующие лексемы:

\ -- ссылки на ячейки  \ cell_reference_occured
\ -- числовые литералы \ nonnegative_number_occured
\ -- операторы         \ operation_occured
\ -- ошибка            \ error_occured

\ Выделение происходит путём вызова слов которые отвечают
\ за обработку каждой лексической единицы выражения
\ Вызовы происходят в том же порядке в каком лексемы
\ расположены в исходной строке.
\ Обработчик ошибки вызывается при неудаче лексического разбора


\ Этот файл не является независимым и он должен подключаться в контексте,
\ где определены "провисающие" слова-обработчики (своего рода абстрактные методы):

[UNDEFINED] cell_reference_occured [IF] : cell_reference_occured ( row col -- ) 2DROP ; [THEN]
[UNDEFINED] nonnegative_number_occured [IF] : nonnegative_number_occured ( n -- ... ) DROP ; [THEN]
[UNDEFINED] operation_occured [IF] : operation_occured ( char -- ) DROP ; [THEN]
[UNDEFINED] error_occured [IF] : error_occured  ( -- ) ; [THEN]


\ БНФ для выражения выглядит так:
\      expression ::= '=' term {operation term}*
\      term ::= cell_reference | nonnegative_number
\      cell_reference ::= [A-Za-z][0-9] -- 
\      operation ::= '+' | '-' | '*' | '/'

\ Пляша от этой формы, мы будем называть свои состояния автомата
state term
state cell_reference_Col \ отделяем друг от друга ввод столбца ячейки
state cell_reference_Row \ и ввод строки ячейки
state nonnegative_number
state operation

0 VALUE col

term
all: error_occured ;  end-input: same-reaction ;
CHAR A CHAR Z range: rollback1  cell_reference_Col ;
CHAR z CHAR z range: same-reaction ;

symbols: 0123456789 rollback1  nonnegative_number ;


cell_reference_Col
all: error_occured ;  end-input: same-reaction ;
CHAR A CHAR Z range:  symbol [CHAR] A - TO col  cell_reference_Row ;
CHAR z CHAR z range:  symbol [CHAR] a - TO col  cell_reference_Row ;

cell_reference_Row
all: error_occured ;  end-input: same-reaction ;
symbols: 123456789  col symbol [CHAR] 1 - cell_reference_occured  operation ;

operation
all: error_occured ;  end-input: ;
symbols: +-*/  symbol operation_occured term ;

\ в след. состоянии есть сомнительный момент -- передача значения на стеке (собираемого числа) 
\ между вызовами реакций, то есть этим самым мы полагаемся на то что:
\ 1) "пускатель" автомата "стеко-прозрачен" (в случае "канонического" пускателя из примера 
\ в chartable.f это так)
\ 2) очерёдность вызовов реакций именно такая какая она есть сейчас и меняться не будет
nonnegative_number
all: nonnegative_number_occured rollback1  operation ;
end-input: nonnegative_number_occured ;
on-enter: 0 ;
symbols: 0123456789  10 * symbol [CHAR] 0 - + ;

: process-expression ( s -— ) STR@
1 TO размер-символа SWAP поставить-курсор
term -символов-обработать ;