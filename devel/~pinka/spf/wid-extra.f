\ 23.Dec.2006 Sat 16:08
( Поддержка экстра-ячейки для списков слов
  с целью их расширения. Код вынесен из quick-swl3.f

  Слово WID-EXTRA [ wid -- addr ] дает свободую ячейку для использования.
  Каждый модуль расширения, который берет эту ячейку для своих нужд,
  должен переопределить слово WID-EXTRA с тем, чтобы оно продолжало 
  давать свободную ячейку.

  Модуль предоставляет цепочку AT-WORDLIST-CREATING [ wid -- wid ]
  вызываемую при создании нового списка слов.

  Использует ячейку "класс словаря" в заголовке словаря для расширения заголовка,
  и переопределяет CLASS! и CLASS@ 
  [ т.к. предназначение их старой ячейки в заголовке переназначено ;]
)

REQUIRE [UNDEFINED] lib/include/tools.f
REQUIRE Included ~pinka/lib/ext/requ.f

[DEFINED] WID-EXTRA [IF] Include wid-extra2.f \EOF [THEN]

\ Note the below implementation is no more used in the new builds.


REQUIRE REPLACE-WORD lib/ext/patch.f

WARNING @  WARNING 0!

MODULE: WidExtraSupport

Require ENUM-VOCS enum-vocs.f

4 CELLS CONSTANT /THIS-EXTR   \ [ hash-table | storage-id | voc class | free cell ]

: MAKE-EXTR ( wid -- )
  HERE DUP /THIS-EXTR DUP ALLOT ERASE
  ( wid here )
  OVER CLASS@ OVER CELL+ CELL+ !
  SWAP CLASS!
;
: MAKE-EXTR2 ( wid -- ) \ не используется; на случай словарей, созданных минуя слово WORDLIST
  GET-CURRENT >R  DUP SET-CURRENT
  MAKE-EXTR
  R> SET-CURRENT
;

EXPORT

: WID-EXTRA ( wid -- a )  \ будет свободная для других расширений ячейка
  3 CELLS + \ an old "class of vocabulary" cell 
  @  3 CELLS +  \ оптимизатор тут все правильно сделает :)
;

DEFINITIONS

: WID-CLASSA ( wid -- a )
  WID-EXTRA CELL-
;

: WID-STORAGEA ( wid -- a )
  WID-EXTRA CELL- CELL-
;

: WID-CACHEA ( wid -- a )
  WID-EXTRA 3 CELLS -  \ и тут оптимизатор все правильно сделает :)
;


EXPORT

WARNING @ WARNING 0!
: CLASS! ( cls wid -- ) WID-CLASSA ! ;
: CLASS@ ( wid -- cls ) WID-CLASSA @ ;
WARNING !

: AT-WORDLIST-CREATING ( wid -- wid ) ... ;

\ : WORDLIST ( -- wid )
\   WORDLIST DUP MAKE-EXTR AT-WORDLIST-CREATING ( wid )
\ ;

\ Ниже закладка для storage.f, чтобы подцепить новый VOC-LIST

( WORDLIST надо переопределить,
  т.к. благодаря оптимизатору оно ссылается на старый VOC-LIST
  несмотря на подмену последнего.
)
' WORDLIST  \ see compiler/spf_wordlist.f
: WORDLIST ( -- wid ) \ 94 SEARCH
  HERE VOC-LIST @ , VOC-LIST !
  HERE 0 , \ здесь будет указатель на имя последнего слова списка
       0 , \ здесь будет указатель на имя списка для именованых
  GET-CURRENT
         , \ wid словаря-предка
       0 , \ класс словаря = wid словаря, определяющего свойства данного

  DUP MAKE-EXTR AT-WORDLIST-CREATING ( wid )
;

' WORDLIST SWAP REPLACE-WORD

: TEMP-WORDLIST ( -- wid )
  GET-CURRENT >R
  TEMP-WORDLIST DUP SET-CURRENT DUP MAKE-EXTR ( wid ) AT-WORDLIST-CREATING ( wid )
  R> SET-CURRENT
;

\ : VOCABULARY
\   VOCABULARY  VOC-LIST @ CELL+
\   DUP MAKE-EXTR AT-WORDLIST-CREATING DROP
\ ;

' VOCABULARY
: VOCABULARY  \ see  compiler/spf_defwords.f
  CREATE
  HERE 0 , \ cell for wid
  WORDLIST ( addr wid )
  LATEST-NAME NAME>CSTRING OVER VOC-NAME! \ ссылка на имя словаря
  GET-CURRENT OVER PAR! \ словарь-предок
  \ FORTH-WORDLIST SWAP CLASS! ( класс )
  SWAP ! \ сам wid
  VOC    \ признак "словарь"
  DOES> @ CONTEXT !
;
' VOCABULARY SWAP REPLACE-WORD  \ чтобы повлияло и на 'MODULE:', и было совместимо со storage.f


' MAKE-EXTR ENUM-VOCS \ фикс существующих словарей (!!!)

Include enum-vocs.f \ переопределение на новый CLASS@

;MODULE

WARNING !