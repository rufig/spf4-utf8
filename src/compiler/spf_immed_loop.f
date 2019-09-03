\ $Id$

( Слова немедленного выполнения, используемые при компиляции
  циклов в теле высокоуровневого определения.
  ОС-независимые определения.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  Преобразование из 16-разрядного в 32-разрядный код - 1995-96гг
  Ревизия - сентябрь 1999
)


HEX


: DO   \ 94
\ Интерпретация: семантика неопределена.
\ Компиляция: ( C: -- do-sys )
\ Положить do-sys на стек управления. Добавить семантику времени выполнения, 
\ данную ниже, к текущему определению. Семантика незавершена до разрешения
\ потребителем do-sys, таким как LOOP.
\ Время выполнения: ( n1|u1 n2|u2 -- ) ( R: -- loop-sys )
\ Установить параметры цикла на индекс n2|u2 и предел n1|u1. Неопределенная 
\ ситуация возникает, если n1|u1 и n2|u2 не одного типа. Все, что уже 
\ находилось на стеке возвратов, становится недоступным до тех пор, пока не 
\ будут убраны параметры цикла.
  ?COMP
  ['] C-DO INLINE,
  SetOP  0x68 C, DP @ 4 ALLOT
  SetOP  0x52 C,    \ PUSH EDX
  SetOP  0x53 C,    \ PUSH EBX

  \ to fit body of cycle in one cache line 
   \ we should align to 16 (default value for ALIGN-BYTES) (~day)
  ALIGN-BYTES @ ALIGN-NOP
  DP @ DUP TO :-SET
; IMMEDIATE

: ?DO   \ 94 CORE EXT
\ Интерпретация: семантика неопределена.
\ Компиляция: ( C: -- do-sys )
\ Положить do-sys на стек управления. Добавить семантику времени выполнения, 
\ данную ниже, к текущему определению. Семантика незавершена до разрешения
\ потребителем do-sys, таким как LOOP.
\ Время выполнения: ( n1|u1 n2|u2 -- ) ( R: --  | loop-sys )
\ Если n1|u1 равно n2|u2, продолжить выполнение с места, данного потребителем 
\ do-sys. Иначе установить параметры цикла на индекс n2|u2 и предел n1|u1
\ и продолжить выполнение сразу за ?DO. Неопределенная 
\ ситуация возникает, если n1|u1 и n2|u2 не одного типа. Все, что уже 
\ находилось на стеке возвратов, становится недоступным до тех пор, пока не 
\ будут убраны параметры цикла.
  ?COMP 
  OP0 @ :-SET  UMAX TO :-SET
  ['] NIP DUP INLINE, INLINE,
  0xBB C, HERE 4 ALLOT
  ['] C-?DO INLINE,
  ALIGN-BYTES @ ALIGN-NOP
  DP @ DUP TO :-SET
; IMMEDIATE

: LOOP   \ 94
\ Интерпретация: ( C: do-sys -- )
\ Добавить семантику времени выполнения, данную ниже, к текущему определению.
\ Разрешить все появления LEAVE между позицией, данной do-sys и следующей
\ позицией передачи управления для выполнения слов за LOOP.
\ Время выполнения: ( -- ) ( R: loop-sys1 --  | loop-sys2 )
\ Неопределенная ситуация возникает, если параметры цикла недоступны.
\ Прибавить единицу к индексу цикла. Если индекс цикла стал равным пределу, 
\ убрать параметры цикла и продолжить выполнение сразу за циклом. Иначе 
\ продолжить выполнение с начала цикла.
  ?COMP 
  24 04FF W, C, \ inc dword [esp]
   042444FF , \ inc dword 4 [esp]
  HERE 2+ - DUP SHORT?   SetOP SetJP
  IF
    71 C, C, \ jno short 
  ELSE
    4 - 0F C, 81 C, , \ jno near
  THEN    SetOP
  0C24648D , \ lea esp, 0c [esp]
  DP @ SWAP !
; IMMEDIATE

: +LOOP    \ 94
\ Интерпретация: ( C: do-sys -- )
\ Добавить семантику времени выполнения, данную ниже, к текущему определению.
\ Разрешить все появления LEAVE между позицией, данной do-sys и следующей
\ позицией передачи управления для выполнения слов за LOOP.
\ Время выполнения: ( n -- ) ( R: loop-sys1 --  | loop-sys2 )
\ Неопределенная ситуация возникает, если параметры цикла недоступны.
\ Прибавить n к индексу цикла. Если индекс цикла не пересек границу между
\ пределом цикла минус единица и пределом цикла, продолжить выполнение с
\ начала цикла. Иначе убрать параметры цикла и продолжить выполнение сразу
\ за циклом.
  ?COMP  
  ['] ADD[ESP],EAX  INLINE,
  04244401 , \ ADD     4 [ESP] , EAX 
  ['] DROP INLINE,
  HERE 2+ - DUP SHORT?   SetOP SetJP
  IF
    71 C, C, \ jno short 
  ELSE
    4 - 0F C, 81 C, , \ jno near
  THEN    SetOP
  0C24648D , \ lea esp, 0c [esp]
  DP @ SWAP !
; IMMEDIATE

: I   \ 94
\ Интерпретация: семантика неопределена.
\ Выполнение: ( -- n|u ) ( R: loop-sys -- loop-sys )
\ n|u - копия текущего (внутреннего) индекса цикла. Неопределенная ситуация 
\ возникает, если парметры цикла недоступны.
  ?COMP  ['] C-I  INLINE,
; IMMEDIATE

: LEAVE    \ 94
\ Интерпретация: семантика неопределена.
\ Выполнение: ( -- ) ( R: loop-sys -- )
\ Убрать текущие параметры цикла. Неопределенная ситуация возникает, если 
\ они недоступны. Продолжить выполнение сразу за самыми внутренними DO ... LOOP 
\ или DO ... +LOOP.
  ?COMP
  SetOP 0824648D , \ lea esp, 08 [esp]
  SetOP C3 C,  \ ret
; IMMEDIATE

: UNLOOP  \ 94
\ Интерпретация: семантика неопределена.
\ Выполнение: ( -- ) ( R: loop-sys -- )
\ Убрать параметры цикла текущего уровня. UNLOOP требуется для каждого
\ уровня вложения циклов перед выходом из определения по EXIT.
\ Неоднозначная ситуация возникает, если параметры цикла недоступны.
  ?COMP
  SetOP  0C24648D , \ lea esp, 0c [esp]
; IMMEDIATE

DECIMAL
