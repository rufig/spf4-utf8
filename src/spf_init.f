\ $Id$
( Инициализация USER-переменных.
  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
  Сентябрь 1999
)

VARIABLE MAINX
ALIGN-BYTES-CONSTANT CONSTANT ALIGN-BYTES-CONSTANT
TC-USER-HERE ALIGNED ' USER-OFFS EXECUTE !

: AT-THREAD-STARTING ( -- ) ...  ;
: AT-PROCESS-STARTING ( -- ) ... AT-THREAD-STARTING ;

: POOL-INIT ( n -- )
  SP@  + CELL+ S0 !
  RP@ R0 !
  DECIMAL
  ATIB TO TIB
  0 TO SOURCE-ID
  0 TO SOURCE-ID-XT
  ONLY FORTH DEFINITIONS
  POSTPONE [
  HANDLER 0!
  CURSTR 0!
  CURFILE 0!
  INCLUDE-DEPTH 0!
  TRUE WARNING !
  12 C-SMUDGE !
  ALIGN-BYTES-CONSTANT ALIGN-BYTES !
  INIT-MACROOPT-LIGHT
;


: ERR-EXIT ( xt -- )
  CATCH
  ?DUP IF ['] ERROR CATCH IF 4 ELSE 3 THEN HALT THEN
  \ выходим с кодом ошибки 3, если обычная ошибка при инициализации 
  \ 4 - если вложенная
;

: (ADDR.) BASE @ >R HEX 8 .0 R> BASE ! ;
: ADDR. ( n -- ) (ADDR.) SPACE ;

: STACK-ADDR. ( addr -- addr )
      DUP ADDR. ." :  "
      DUP ['] @ CATCH 
      IF DROP 
      ELSE DUP ADDR. WordByAddrSilent TYPE CR THEN
;

\ : AT-EXC-DUMP ( addr -- addr ) ... ;
\ example: ..: AT-EXC-DUMP ." REGISTERS:" DUP 12 CELLS DUMP CR ;..

: DUMP-TRACE ( addr-h addr-l -- ) \ bottom top --
  BEGIN 2DUP U< 0= WHILE STACK-ADDR. CELL+ REPEAT 2DROP
;

12 VALUE TRACE-HEAD-SIZE
15 VALUE TRACE-TAIL-SIZE

: DUMP-TRACE-SHRUNKEN ( addr-h addr-l -- ) \ bottom top --
  2DUP -  TRACE-HEAD-SIZE TRACE-TAIL-SIZE + 5 + CELLS
  U< IF DUMP-TRACE EXIT THEN
  DUP TRACE-HEAD-SIZE CELLS + SWAP DUMP-TRACE ." [...]" CR
  DUP TRACE-TAIL-SIZE CELLS - DUMP-TRACE
;

: DUMP-EXCEPTION-HEADER ( addr num -- )
  ." EXCEPTION!  CODE:" ADDR.
  ."  ADDRESS:" DUP ADDR.
  ."  WORD:" WordByAddr TYPE 
  CR
  ." USER DATA: " TlsIndex@ ADDR.
  ." THREAD ID: " THREAD-ID ADDR.
  ." HANDLER: " HANDLER @ ADDR. 
  CR 
;

: DUMP-TRACE-USING-REGS ( esp eax ebp -- )
  BASE @ >R DECIMAL
  ." STACK: (" S0 @ OVER - 1 CELLS / 1+ S>D (D.) TYPE ." ) "
  R> BASE !
  ( ebp ) DUP 6 CELLS + BEGIN CELL- DUP ['] @ CATCH IF DROP ELSE ADDR. THEN 2DUP = UNTIL 2DROP
  ( eax ) ." [" (ADDR.) ." ]" CR
  ( esp )

  ." RETURN STACK:" CR
  R0 @ 
  
  2DUP U<
  IF ( top bottom )
    2DUP HANDLER @ WITHIN IF
      >R HANDLER @ SWAP DUMP-TRACE-SHRUNKEN
      HANDLER @ CELL+ R> 
    THEN
    2DUP  TRACE-HEAD-SIZE TRACE-TAIL-SIZE + CELLS - 10 CELLS -
    U< IF 10 CELLS - THEN \ skip early bottom
    SWAP DUMP-TRACE-SHRUNKEN
  ELSE ( esp bottom ) 
    NIP DUP 50 CELLS - DUMP-TRACE 
    \ при несогласованности предпочтение отдается R0
  THEN
;

: (FATAL-HANDLER1) ( ior -- )
  HEX
  ." UNHANDLED EXCEPTION: " DUP U. CR
  ." RETURN STACK: " CR
  R0 @ RP@ DUMP-TRACE-SHRUNKEN
  ." SOURCE: " CR ERROR CR
  ." THREAD EXITING." CR
  TERMINATE
;
: FATAL-HANDLER1 ( ior -- )
  ['] (FATAL-HANDLER1) CATCH 5 ['] HALT CATCH -1 PAUSE
  \ Вывод сообщения об ошибке может вызвать исключение.
  \ Если поток не завершился, то завршаем процесс.
  \ Если не получилось -- поток засыпает.
  \ FATAL-HANDLER не имеет права возвращать управление!
  \ (в том числе, возвращать управление через THROW)
;
' FATAL-HANDLER1 ' FATAL-HANDLER TC-VECT!  \ see THROW

TARGET-POSIX [IF]
  S" src/posix/init.f" INCLUDED
[ELSE]
  S" src/win/spf_win_init.f" INCLUDED
[THEN]

' NOOP         ' <PRE>      TC-VECT!
' FIND1        ' FIND       TC-VECT!
' ?LITERAL2    ' ?LITERAL   TC-VECT!
' ?SLITERAL2   ' ?SLITERAL  TC-VECT!
' OK1          ' OK         TC-VECT!
' ERROR2       ' ERROR      TC-VECT!
' (ABORT1")    ' (ABORT")   TC-VECT!

' USER-INIT ' FORTH-INSTANCE>  TC-VECT!
' USER-EXIT ' <FORTH-INSTANCE  TC-VECT!
' QUIT      ' <MAIN>           TC-VECT!

: (TITLE)
  ." SP-FORTH - ANS FORTH 94 for " PLATFORM TYPE CR
  ." Open source project at https://github.com/rufig/spf" CR
  ." Russian FIG at http://www.forth.org.ru ; Started by A.Cherezov" CR
  ." Version " VERSION 1000 / 0 <# # # [CHAR] . HOLD # #> TYPE
  ."  Build " VERSION 0 <# # # # #> TYPE
  ."  at " BUILD-DATE COUNT TYPE CR CR
;

: TITLE  CGI? @ 0=  ?GUI 0= AND COMMANDLINE-OPTIONS NIP 0= AND IF (TITLE) THEN ;
' TITLE ' MAINX TC-ADDR!

: (OPTIONS) ( -- )
  ['] INTERPRET CATCH PROCESS-ERR THROW
;
: OPTIONS ( -> ) \ интерпретировать командную строку
  COMMANDLINE-OPTIONS TUCK HEAP-COPY SWAP ['] (OPTIONS) EVALUATE-WITH
;

: +HomeDirName ( a u -- a2 u2 )
\ Добавить addr u к "значение_окружения_HOME/"
  S" HOME" ENVIRONMENT? 0= IF EXIT THEN
  SYSTEM-PAD DUP >R /SYSTEM-PAD CROP S" /" CROP- CROP ( a2-rest u2-rest )
  DROP 0 OVER C! R> TUCK -
  
  \ Данное определение нельзя поместить в spf_module.f
  \ т.к. должно быть после определения "ENVIRONMENT?"
;


: SPF-INI
  S" spf4.ini" INCLUDED-EXISTING IF EXIT THEN
  +ModuleDirName INCLUDED-EXISTING IF EXIT THEN 2DROP
  S" .spf4.ini" +HomeDirName INCLUDED-EXISTING IF EXIT THEN 2DROP
  \ надо ли искать ".spf4.ini" в других местах?
  \ сделать ли имя ini-файла платформенно-зависимым?
  \ см. Bug#3274947
;

\ Scattering a Colon Definition
: ... 0 BRANCH, >MARK DUP , 1 >RESOLVE ; IMMEDIATE 
: ..: '  >BODY DUP @  1 >RESOLVE ] ;
: ;..  DUP CELL+ BRANCH, >MARK SWAP ! [COMPILE] [ ; IMMEDIATE

TRUE VALUE SPF-INIT?

\ Startup
\ Точка входа при запуске:

TARGET-POSIX [IF]
: (INIT) ( env argv argc -- )
  TO ARGC TO ARGV
  \ concat argv for COMMANDLINE-OPTIONS
  HERE 
  ARGC 1 ?DO
   BL C,
   ARGV I CELLS + @ ASCIIZ> S,
  LOOP
  HERE OVER - TO #CMDLINE TO CMDLINE
  0 C,
[ELSE]
: (INIT)
[THEN]
  NATIVE-LINES
  0 TO H-STDLOG
  CONSOLE-HANDLES
  ['] CGI-OPTIONS ERR-EXIT
  MAINX @ ?DUP IF ERR-EXIT THEN
  SPF-INIT?
  IF
    ['] SPF-INI ERR-EXIT
    ['] OPTIONS CATCH ERROR \ продолжить не смотря на ошибку
  THEN
  CGI? @ 0= POST? @ OR IF ['] <MAIN> ERR-EXIT THEN
  BYE
  \ если где-то тут произойдет исключение (например, при исполнении ERROR),
  \ то его обработает FATAL-HANDLER и процесс завершится.
;

' PROCESS-INIT TO TC-FORTH-INSTANCE>
' (INIT) PROCESSPROC: INIT

TARGET-POSIX 0 = [IF]
' INIT OVER - OVER 1+ +!
[THEN]
