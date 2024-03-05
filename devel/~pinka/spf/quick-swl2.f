\ 07.Jan.2004 ruv
\ 14.Feb.2004
\ $Id$

( Расширение SPF [зависит от реализации!]
   воплощает быстрый поиск по словарю за счет использования хэш-таблиц.

  Хэш-таблицы создаются динамически, по SAVE не сохраняются.

  Особенности:
    Хэш-таблицы располагаются в общем хипе процесса
    [через механизм HEAP-ID  ~pinka/spf/mem.f]
    Возможна утечка, если не делать FREE-WORDLIST на каждый TEMP-WORDLIST
)
( Переопределяет FREE-WORDLIST  и MARKER /если он есть/
  Поэтому, следует подгружать quick-swl.f до того, 
   как эти слова могут быть использованы в определениях.
  [ в том числе, до locals.f ]
  
  Заменяет/перехватывает/ +SWORD  и переопределяет слова ":" ";"

  Заменяет вектор SEARCH-WORDLIST - метод поиска в стандартных словарях SPF
  Использует ячейку "класс словаря" в заголовке словаря
  для хранения ссылки на экстра-заголовок.
)

REQUIRE HEAP-ID     ~pinka/spf/mem.f
REQUIRE [UNDEFINED] lib/include/tools.f
REQUIRE HASH!       ~pinka/lib/hash-table.f 

MODULE: QuickSWL-Support

EXPORT

 256 VALUE #WL-HASH
 \ размер хэш-таблиц для вновь создаваемых словарей.
 \ При инициализации на этапе AT-PROCESS-STARTING 
 \   размер таблиц берется как 3*n, где n -число слов в словаре.

DEFINITIONS

0 \ ext header  for wordlist
 1 CELLS -- .hash
 1 CELLS -- .last
 1 CELLS -- .wid
CONSTANT /exth
( exth знает свой wid через атрибут .wid
  и из wid можно получить exth
)

: wid-exth ( wid -- exth )
  3 CELLS +  \ использовал ячейку "класс словаря"
  DUP @   DUP IF  NIP EXIT THEN  DROP
  ( ~wid )

  HEAP-ID >R  HEAP-GLOBAL
  /exth ALLOCATE THROW
  SWAP 2DUP !    ( exth ~wid )
  3 CELLS - OVER .wid ! ( exth )
  #WL-HASH  new-hash  OVER !
  R> HEAP-ID!
;
: WL-HASH ( wid -- hash-table )
  wid-exth .hash @
;
( внутри, т.к. способ использования хэш-таблицы - детали реализации )

USER-VALUE hash

: update-hash ( exth -- )
  >R
  R@ .last  @
  R@ .wid @ LATEST-NAME-IN  ( nt2 nt )
  2DUP = IF 2DROP RDROP EXIT THEN
  \ если словарь пуст - 0 0 - тоже выход

  DUP NAME>CSTRING CHAR+ C@ 12 = IF
  \ не добавляем последнее слово, если скрыто ( by HIDE )
    NAME>NEXT-NAME 2DUP = IF 2DROP RDROP EXIT THEN
  THEN

  DUP R@ .last !
  R> .hash @ TO hash

  HEAP-ID >R  HEAP-GLOBAL

  0 >R
  ( l2 l )          BEGIN
  2DUP <>           WHILE
  DUP >R NAME>NEXT-NAME
  DUP 0=            UNTIL THEN 2DROP
  ( )               BEGIN
  R> DUP            WHILE
  DUP NAME>STRING
  hash HASH!N       REPEAT DROP
  \ добавлять в хэш-таблицу надо в том же порядке, 
  \ в котором слова добавлялись в словарь

  R> HEAP-ID!
;

: update-wlhash ( wid -- )
  wid-exth update-hash
;

: update1-wlhash ( nfa wid -- )
  wid-exth DUP .last @     IF
  HEAP-ID >R  HEAP-GLOBAL
    .hash @    >R
    DUP NAME>STRING R> HASH!N
  R> HEAP-ID!               ELSE
  \ чтобы при сцеплении списков все слова добавлялись
  NIP update-hash           THEN
;


: reduce-hash ( last  wid  -- )
\ Исключить из хэш-таблицы слова от wid @ до last
\ last должно иметь место в цепочке словаря wid
\ ( для MARKER ) ( для MARKER не подходит, - 25.Mar.2004 )

  DUP wid-exth ?DUP 0= IF 2DROP EXIT THEN >R
  @ ( l2  l )
  OVER R@ .last  !
  R> .hash @ TO hash

  HEAP-ID >R  HEAP-GLOBAL

  ( l2 l )          BEGIN
  2DUP <>           WHILE
  DUP COUNT hash -HASH
  CDR DUP 0=        UNTIL THEN 2DROP

  R> HEAP-ID!
;

EXPORT

\ SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ 94 SEARCH

: QuickSWL ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ SWL
  WL-HASH ( c-addr u  h )
  HASH@N            IF
  DUP  NAME> 
  SWAP NAME>F C@
  &IMMEDIATE AND
  IF 1 ELSE -1 THEN ELSE
  0                 THEN
;
( для сочетания с MARKER можно было бы в QuickSWL проверять,
   что найденное через хэш слово находиться ниже последенего слова в словаре 
   [ или до границы HERE ], но такая проверка криво работает 
   при сцеплении списков в порядке, отличном от их следования в ОП.
)

: REFRESH-WLHASH ( wid -- )
\ Обновить хэш-таблицу словаря (на случай, если она стала неадекватной..)
\ Неопределенная ситуация, если во время выполнения REFRESH-WLHASH 
\  происходит поиск по словарю wid.
  DUP
  HEAP-ID >R  HEAP-GLOBAL

  wid-exth DUP
  .last 0!
  .hash @ clear-hash

  R> HEAP-ID!
  update-wlhash
;

: FREE-WORDLIST ( wid -- )
  DUP wid-exth DUP
   ( wid exth exth )
   HEAP-ID >R  HEAP-GLOBAL
     .hash @ del-hash
      FREE THROW
   R> HEAP-ID!

  FREE-WORDLIST
;

[DEFINED] MARKER [IF]

: MARKER
  WARNING @ >R WARNING 0!
    LATEST-NAME
    >IN @ >R  MARKER LATEST-NAME-XT  R> >IN !
    ( last marker-xt )
    CREATE
     , , GET-CURRENT ,
  R> WARNING !

  DOES> 
    DUP 0 CELLS +  @ EXECUTE
        2 CELLS +  @ REFRESH-WLHASH
;
( Если слово было переопределено,
  то после reduce-hash  предыдущая версия останется недоступной..
)
[THEN]

[UNDEFINED] WL-#WORDS [IF]
: WL-#WORDS ( wid -- n )
  0 SWAP
  @     BEGIN
  DUP   WHILE
  SWAP 1+ SWAP
  CDR   REPEAT  DROP
;
[THEN]

DEFINITIONS

: erase-refer ( -- )
\ ( аналогично ERASE-IMPORTS )
\ хэш-таблицы динамические, живут только в ОП,
\ поэтому после запуска процесса ссылки на exth в заголовках словарей
\ будут не действительны. Их надо обнулить. 
  VOC-LIST @ BEGIN
  DUP        WHILE
  DUP CELL+ ( a wid )
  3 CELLS + 0!  \ ячейка "класс словаря"
  @          REPEAT  DROP
;

: update-hashes ( -- )
\ инициирует хэш-таблицы для всех словарей (по списку VOC-LIST)
  #WL-HASH >R
  VOC-LIST @ BEGIN
  DUP        WHILE
  DUP CELL+ ( a wid )
    DUP WL-#WORDS 3 *   16 UMAX   TO #WL-HASH
    \ DUP VOC-NAME. SPACE #WL-HASH . CR
  update-wlhash
  @          REPEAT  DROP
  R> TO #WL-HASH
;
( заполнение хэш-таблицы по первому поиску в словаре
  требует синхронизации для реентерабельности к многопоточности,
  не используется.

  Использование локального хипа потока наложило бы ограничения
  на режимы разнопоточной компиляции...
)

VECT 0SWL  \ иниц.-ия модуля QuickSWL  при запуске системы..

: 0SWL1 ( -- )
  erase-refer update-hashes
; ' 0SWL1 TO 0SWL

..: AT-PROCESS-STARTING 0SWL ;..

\ -------------------------------

USER LAST-WID

: LatestWord2Hash ( -- )
  GET-CURRENT LATEST-NAME-IN ?DUP IF GET-CURRENT update1-wlhash THEN
;

EXPORT

USER-VALUE NOW-COLON?

: +SWORD2 ( addr u wid -- )
  DUP LAST-WID !

  HERE LAST !
  HERE 2SWAP S", SWAP DUP @ , !

  NOW-COLON?            IF
  FALSE TO NOW-COLON?   ELSE
  LatestWord2Hash       THEN
;

: : ( C: "<spaces>name" -- colon-sys ) \ 94
  TRUE TO NOW-COLON?
  :
;
: ;
    POSTPONE ;
    LatestWord2Hash
    ( если было NONAME, то передобавит слово, которое уже есть
      - ситуация штатная. )
    FALSE TO NOW-COLON?
; IMMEDIATE



    [DEFINED] +SWORD1                           [IF]
    ' +SWORD2 TO +SWORD                         [ELSE]

    REQUIRE REPLACE-WORD lib/ext/patch.f
    ' +SWORD2 ' +SWORD REPLACE-WORD             [THEN]

0SWL  \ иниц.ия

    [DEFINED] SEARCH-WORDLIST1                  [IF]
    ' QuickSWL TO SEARCH-WORDLIST               [ELSE]

    REQUIRE REPLACE-WORD lib/ext/patch.f
    ' QuickSWL ' SEARCH-WORDLIST REPLACE-WORD   [THEN]

;MODULE
