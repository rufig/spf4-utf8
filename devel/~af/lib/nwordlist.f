\ Организация словарей. в которых в качестве имен слов используются числа.
\ Можно использовать ( например) для записи обработчиков вин-сообщений
\ в виде слов.

: SEARCH-NLIST ( msg wid -- 0 | xt 1 )
  \ найти n-слово
  SWAP >R  RP@ 4  ROT  SEARCH-WORDLIST  RDROP
;

: +NWORD ( n wid -> )
  HERE LAST !
  HERE ROT 4 C, , SWAP DUP @ , !
;

: NHEADER ( n -- )
  HERE 0 , ( cfa )
  DUP LAST-CFA !
  0 C,     ( flags )
  SWAP WARNING @
  IF DUP GET-CURRENT SEARCH-NLIST
     IF DROP DUP . ."  isn't unique" CR THEN
  THEN
  GET-CURRENT +NWORD
  ALIGN
  HERE SWAP ! ( заполнили cfa )
;

: :M ( "WM_..." -- )
  \ определить обработчик сообщения
  NHEADER
  ]
  HIDE
;
