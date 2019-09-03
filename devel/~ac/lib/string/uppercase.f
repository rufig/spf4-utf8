\ МНБЮЪ БЕПЯХЪ ЯДЕКЮМЮ ~ygrek

\ : CHAR-UPPERCASE ( c -- c1 )
\   DUP [CHAR] a [CHAR] z 1+ WITHIN
\   OVER [CHAR] Ю [CHAR] Ъ 1+ WITHIN OR IF 32 - THEN ;

\ ЕЫЕ МНБЕЕ ~ruv

: CHAR-UPPERCASE ( c -- c1 )
  DUP [CHAR] a [CHAR] z 1+ WITHIN IF 32 - EXIT THEN
  DUP [CHAR] Ю [CHAR] Ъ 1+ WITHIN IF 32 - THEN
;

: UPPERCASE ( addr1 u1 -- )
  OVER + SWAP ?DO
    I C@ CHAR-UPPERCASE I C!
  LOOP ;

\EOF

REQUIRE TESTCASES ~ygrek/lib/testcase.f

TESTCASES UPPERCASE
 (( S" qwerty" 2DUP UPPERCASE S" QWERTY" COMPARE -> 0 ))
 : test-str S" !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}:+%юабцдефгхийклмнопярстужвьызшэщчъЮАБЦДЕФГХИЙКЛМНОПЯРСТУЖВЬЫЗШЭЩЧЪ" ;
 : must-str S" !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}:+%юабцдефгхийклмнопярстужвьызшэщчъюабцдефгхийклмнопярстужвьызшэщчъ" ;
 (( test-str 2DUP UPPERCASE must-str COMPARE -> 0 )) END-TESTCASES
