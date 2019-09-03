( Структурированная обработка исключений.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  Преобразование из 16-разрядного в 32-разрядный код - 1995-96гг
  Ревизия - сентябрь 1999
)

USER HANDLER      \ программные исключения

VECT FATAL-HANDLER      ' NOOP ' FATAL-HANDLER TC-VECT!
\ если в результате сбоев повредилось исходное значение HANDLER,
\ установленное при входе в поток/задачу или позднее,
\ то выполнится этот обработчик FATAL-HANDLER

: THROW ( k*x n -- k*x | i*x n ) \ 94 EXCEPTION
\ Если любые биты n ненулевые, взять верхний кадр исключений со стека
\ исключений, включая все на стеке возвратов над этим кадром. Затем
\ восстановить спецификации входного потока, который использовался перед
\ соответствующим CATCH, и установить глубины всех стеков, определенных
\ в этом Стандарте, в то состояние, которое было сохранено в кадре
\ исключений (i - это то же число, что и i во входных аргументах
\ соответствующего CATCH), положить n на вершину стека данных и передать
\ управление в точку сразу после CATCH, которое положило этот кадр
\ исключений.
\ Если вершина стека не ноль, и на стеке исключений есть кадр 
\ исключений, то поведение следующее:
\   Если n=-1, выполнить функцию ABORT (версию ABORT из слов CORE), 
\   не выводя сообщений.
\   Если n=-2, выполнить функцию ABORT" (версию ABORT" из слов CORE), 
\   выводя символы ccc, ассоциированные с ABORT", генерирующим THROW.
\   Иначе система может вывести на дисплей зависящее от реализации 
\   сообщение об условии, соответствующем THROW с кодом n. Затем 
\   система выполнит функцию ABORT (версию ABORT из CORE).
  DUP 0= IF DROP EXIT THEN
  \ DUP 109 = IF DROP EXIT THEN \ broken pipe - обычно не ошибка, а конец входного потока в CGI
  
  HANDLER @  DUP IF  RP!
  R> HANDLER !
  R> SWAP >R
  SP! DROP R>
  EXIT         THEN
  DROP FATAL-HANDLER
;
( THROW обязанно выполнять исключение при любом коде исключения, отличном от 0.
  Пропуск кода 109 был ошибкой, унаследованной откуда-то очень давно.
  Во первых, полно кода который абсолютно корректно делает DUP IF ... THROW THEN ...
  Во вторых, 109 можно получить не только на READ-FILE, но на WRITE-FILE.
  Поэтому, анализ кода 109 и замена его на 0 допустимо только внутри READ-FILE и др,
  но никак не в THROW
  2014-03-11 ~ruv
)
' THROW TO THROW-CODE \ вектор в инструментальной системе, в рамках TC

VECT <SET-EXC-HANDLER> \ установить обработчик аппаратных исключений

: CATCH ( i*x xt -- j*x 0 | i*x n ) \ 94 EXCEPTION
\ Положить на стек исключений кадр перехвата исключительных ситуаций
\ и выполнить токен xt (как по EXECUTE) таким образом, чтобы управление
\ могло быть передано в точку сразу после CATCH, если во время выполнения
\ xt выполняется THROW.
\ Если выполнение xt заканчивается нормально (т.е. кадр исключений,
\ положенный на стек словом CATCH не был взят выполнением THROW),
\ взять кадр исключений и вернуть ноль на вершину стека данных,
\ остальные элементы стека возвращаются xt EXECUTE. Иначе остаток
\ семантики выполнения дается THROW.
  SP@ >R  HANDLER @ >R
  RP@ HANDLER !
  EXECUTE
  R> HANDLER !
  RDROP
  0
;
: ABORT  \ 94 EXCEPTION EXT
\ Расширить сематику CORE ABORT чтобы было:
  ( i*x -- ) ( R: j*x -- )
\ Выполнить функцию -1 THROW
  -1 THROW
;
