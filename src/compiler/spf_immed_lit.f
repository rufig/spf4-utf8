\ $Id$

( Слова немедленного выполнения, используемые при компиляции
  числовых и строчных литералов в тело высокоуровневого определения.
  ОС-независимые определения.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  Преобразование из 16-разрядного в 32-разрядный код - 1995-96гг
  Ревизия - сентябрь 1999
)

: LITERAL \ 94 CORE
\ Интерпретация: семантика неопределена.
\ Компиляция: ( x -- )
\ Добавить семантику времени выполнения, данную ниже, к текущему определению.
\ Время выполнения: ( -- x )
\ Положить x на стек.
  STATE @ IF LIT, THEN
; IMMEDIATE

: 2LITERAL \ 94 DOUBLE
\ Интерпретация: семантика неопределена.
\ Компиляция: ( x1 x2 -- )
\ Добавить семантику времени выполнения, данную ниже, к текущему определению.
\ Время выполнения: ( -- x1 x2 )
\ Положить пару ячеек x1 x2 на стек.
  STATE @ IF DLIT, THEN
; IMMEDIATE

: SLITERAL  \ 94 STRING
\ Интерпретация: семантика не определена.
\ Компиляция: ( c-addr1 u -- )
\ Добавить семантику времени выполнения, данную ниже, к текущему определению.
\ Время выполнения: ( -- c-addr2 u )
\ Возвратить c-addr2 u, описывающие строку, состоящую из символов, заданных
\ c-addr1 u во время компиляции. Программа не может менять возвращенную
\ строку.

  STATE @ IF SLIT, ELSE  2DUP CHARS + 0 SWAP C! THEN
; IMMEDIATE

: CLITERAL ( addr -- )
  STATE @ IF
            ['] _CLITERAL-CODE COMPILE,
            COUNT DUP C, CHARS
            HERE SWAP DUP ALLOT MOVE 0 C,
          THEN
; IMMEDIATE

: S"   \ 94+FILE
\ Интерпретация: ( "ccc<quote>" -- c-addr u )
\ Выделить ccc, ограниченные " (двойными кавычками). Записать полученную
\ строку c-addr u во временный буфер. Максимальная длина временного
\ буфера зависит от реализации, но не может быть меньше 80 символов.
\ Следующее использование S" может переписать временный буфер.
\ Обеспечивается как минимум один такой буфер.
\ Компиляция: ( "ccc<quote>" -- )
\ Выделить ccc, ограниченные " (двойными кавычками). Добавить семантику
\ времени выполнения, описанную ниже, к текущему определению.
\ Время выполнения: ( -- c-addr u )
\ Вернуть c-addr и u, которые описывают строку, состоящую из символов ccc.
  [CHAR] " PARSE [COMPILE] SLITERAL
; IMMEDIATE

: C"   \ 94 CORE EXT
\ Интерпретация: семантика не определена.
\ Компиляция: ( "ccc<quote>" -- )
\ Выделить ccc, ограниченные " (двойными кавычками) и добавить 
\ семантику времени выполнения, данную ниже, к текущему определению.
\ Время выполнения: ( -- c-addr )
\ Возвратить c-addr, строку со счетчиком, состоящую из символов ccc.
\ Программа не должна менять возвращенную строку.
  [CHAR] "
  PeekChar OVER = IF \ empty counted string C" "
    DROP >IN 1+!
    SYSTEM-PAD DUP 0!
  ELSE
    WORD \ it doesn't understand a token with 0-length.
  THEN 
  [COMPILE] CLITERAL
; IMMEDIATE

: ."  \ 94
\ Интерпретация: семантика неопределена.
\ Компиляция: ( "ccc<quote>" -- )
\ Выделить ccc, ограниченное " (двойными кавычками). Добавить семантику времени 
\ выполнения, данную ниже, к текущему определению.
\ Время выполнения: ( -- )
\ Вывести ccc на экран.
  ?COMP
  ['] _CLITERAL-CODE COMPILE,
  [CHAR] " PARSE DUP C, CHARS
  HERE SWAP DUP ALLOT MOVE 0 C,
  ['] (.") COMPILE,
; IMMEDIATE

: [CHAR]  \ 94
\ Интерпретация: семантика неопределена.
\ Компиляция: ( "<spaces>name" -- )
\ Пропустить ведущие пробелы. Выделить name, ограниченное пробелами. Добавить 
\ семантику времени выполнения, данную ниже, к текущему определению.
\ Время выполнения: ( -- char )
\ Положить char, значение первого символа name, на стек.
  ?COMP
  PARSE-NAME DROP C@ [COMPILE] LITERAL
; IMMEDIATE

: ABORT"   \ 94
\ Интерпретация: семантика не определена.
\ Компиляция: ( "ccc<quote>" -- )
\ Выделить ccc, ограниченные " (двойными кавычками). Добавить описанную
\ ниже семантику времени выполнения в текущее определение.
\ Выполнение: ( i*x x1 -- | i*x )
\ Убрать x1 со стека. Если любой бит x1 ненулевой, вывести на экран ccc и
\ выполнить зависящие от реализации действия, включающие ABORT.
\ : ABORT"  \ 94 EXCEPTION EXT
\ Расширить семантику CORE ABORT" чтобы было:
\ Интерпретация: семантика не определена.
\ Компиляция: ( "ccc<quote>" -- )
\ Выделить ccc, ограниченные " (двойными кавычками). Добавить семантику
\ времени выполнения, данную ниже, к текущему определению.
\ Время выполнения: ( i*x x1 -- | i*x ) ( R: j*x -- | j*x )
\ Убрать x1 со стека. Если любой бит x1 ненулевой, выполнить функцию
\ -2 THROW, выводя ccc, если на стеке исключений нет кадра исключений.
  ?COMP
  ['] _CLITERAL-CODE COMPILE,
  [CHAR] " PARSE DUP C, CHARS
  HERE SWAP DUP ALLOT MOVE 0 C,
  ['] (ABORT") COMPILE,
; IMMEDIATE

: [']  \ 94
\ Интерпретация: семантика неопределена.
\ Компиляция: ( "<spaces>name" -- )
\ Пропустить ведущие пробелы. Выделить name, ограниченное пробелом. Найти name.
\ Добавить семантику времени выполнения, данную ниже, к текущему определению.
\ Неопределенная ситуация возникает, если name не найдено.
\ Добавить семантику времени выполнения, данную ниже, к текущему определению,
\ Время выполнения: ( -- xt )
\ Положить выполнимый токен имени xt на стек. Выполнимый токен, возвращаемый
\ скомпилированной фразой "['] X" является тем же значением, что и возвращаемое
\ "' X" вне состояния компиляции.
  ?COMP
  ' LIT,
; IMMEDIATE
