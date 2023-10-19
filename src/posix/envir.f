\ $Id$
\ 
\ Мелкие, зависящие от ОС, вещи
\ Ю. Жиловец, 13.05.2007

: dl-no-library ( z )
    DROP
    <# DLERROR ASCIIZ> HOLDS 0. #>
    DUP ER-U !
    SYSTEM-PAD SWAP CHARS MOVE
    SYSTEM-PAD ER-A ! -2 THROW
;

: dl-no-symbol ( z -- )
    ASCIIZ>
    <# S" : undefined symbol" HOLDS HOLDS 0. #>
    DUP ER-U !
    SYSTEM-PAD SWAP CHARS MOVE
    SYSTEM-PAD ER-A ! -2 THROW
;


WORDLIST DUP >VIRT CONSTANT ENVIRONMENT-WORDLIST
  ( wid ) \ запишем адрес имени словаря
  LATEST-NAME NAME>CSTRING SWAP VOC-NAME!

: (ENVIR?) ( addr u -- false | i*x true )
   BEGIN
     REFILL
   WHILE
     2DUP PARSE-NAME COMPARE
     0= IF 2DROP INTERPRET TRUE EXIT THEN
   REPEAT 2DROP FALSE
;

: ENVIRONMENT? ( c-addr u -- false | i*x true ) \ 94
\ c-addr и u - адрес и длина строки, содержащей ключевое слово
\ для запроса атрибутов присутствующего окружения.
\ Если системе запрашиваемые атрибуты неизвестны, возвращается флаг
\ "ложь", иначе "истина" и i*x - запрашиваемые атрибуты определенного
\ в таблице запросов типа.
  OVER 1 <( )) getenv ?DUP IF NIP NIP ASCIIZ> TRUE EXIT THEN

  \ расширение spf370: если в windows environment есть
  \ запрашиваемая строка, то возвращаем её - c-addr u true

  2DUP ENVIRONMENT-WORDLIST 
  SEARCH-WORDLIST IF NIP NIP EXECUTE TRUE EXIT THEN

  S" lib/ENVIR.SPF" +ModuleDirName 2DUP FILE-EXIST 0= 
  IF
    2DROP
    S" ENVIR.SPF" +ModuleDirName
  THEN

  R/O OPEN-FILE-SHARED 0=
  IF  DUP >R  
      ['] (ENVIR?) RECEIVE-WITH  IF 0 THEN
      R> CLOSE-FILE THROW 
  ELSE 
    2DROP DROP 0 THEN
;

0 CONSTANT FORTH_ERROR

: (DECODE-ERROR) ( n -- c-addr u )
  STATE @ >R STATE 0!
  BEGIN
    REFILL
  WHILE ( n )
    PARSE-NAME ['] ?SLITERAL CATCH
    IF 2DROP DROP S" Error while error decoding!" R> STATE ! EXIT THEN
    OVER = IF ( n )
      DROP >IN 0! [CHAR] \ PARSE
      TUCK SYSTEM-PAD SWAP CHARS MOVE
      SYSTEM-PAD SWAP   R> STATE ! EXIT
    THEN
  REPEAT ( n )
  <# SOURCE SWAP CHAR+ SWAP 1 - HOLDS  DUP 0< IF DUP S>D #(SIGNED) 2DROP THEN U>D #S #> \ Unknown error
  R> STATE !
;

: DECODE-ERROR ( n u -- c-addr u )
\ Возвратить строку, содержащую расшифровку кода
\ ошибки n при условии u.
\ Scattered Colon.
  ... DROP
  S" lib/SPF.ERR" +ModuleDirName 2DUP FILE-EXIST 0=
  IF
     2DROP
     S" SPF.ERR" +ModuleDirName
  THEN
  R/O OPEN-FILE-SHARED
  IF DROP DUP >R ABS 0 <# #S R> SIGN S" ERROR #" HOLDS #>
     TUCK SYSTEM-PAD SWAP CHARS MOVE SYSTEM-PAD SWAP
  ELSE
    DUP >R
    ['] (DECODE-ERROR) RECEIVE-WITH DROP
    R> CLOSE-FILE THROW
    2DUP -TRAILING + 0 SWAP C!
  THEN
;

: ERROR2 ( ERR-NUM -> ) \ показать расшифровку ошибки
  DUP 0= IF DROP EXIT THEN
  DUP -2 = IF   DROP LAST-WORD
                ER-A @ ER-U @ TYPE
           ELSE
  LAST-WORD  
  BASE @ >R DECIMAL
  FORTH_ERROR DECODE-ERROR TYPE
  R> BASE !
           THEN CR
;

\ --------------------------------------------
\ Слова для компиляции вызовов внешних функций

: USE ( "name" -- )
  PARSE-NAME 2DUP SYSTEM-PAD CZMOVE
  SYSTEM-PAD dlopen2 TRUE name-lookup DROP
;

\ see lib/include/facil.f
\ : extern ( "name" -- )
\   PARSE-NAME 2DUP [T] SHEADER [I]
\   CREATE-CODE COMPILE,
\   symbol-lookup ,
\   (DOES1) (DOES2)
\   @ symbol-address
\ ;

: compile-call ( n -- )
  [COMPILE] LITERAL
  ['] symbol-address COMPILE,
  (__ret2) @ IF
    ['] C-CALL2
  ELSE
    ['] C-CALL
  THEN COMPILE,
  (__ret2) 0!
;

: )) ( "name" -- )
  PARSE-NAME symbol-lookup
  STATE @ IF
    ['] ())) COMPILE,
    compile-call
  ELSE
    ())) 1- SWAP symbol-call
  THEN
; IMMEDIATE

: (()) ( "name" -- )
  PARSE-NAME symbol-lookup
  STATE @ IF
    0 [COMPILE] LITERAL
    compile-call
  ELSE
    0 SWAP symbol-call
  THEN
; IMMEDIATE

\ ------------------------------

: system ( z -- )
  1 <( )) system DROP
;

: #! ( ->eol; -- ) [COMPILE] \ ;
