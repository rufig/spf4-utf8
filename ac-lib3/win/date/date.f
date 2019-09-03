REQUIRE TIME&DATE lib/include/facil.f

CREATE ДнейВМесяце 31 C, 28 C, 31 C,  30 C, 31 C, 30 C,  31 C, 31 C, 30 C,  31 C, 30 C, 31 C,

: ДнейДоНачалаМесяца
  1- 0 MAX  0 SWAP 0 ?DO ДнейВМесяце I + C@ + LOOP
;
: ДнейДоНачалаГода
  1900 - DUP 3 + 4 / SWAP 365 * +
;
: ?Високосный
  4 MOD 0=
;
: >Дата ( день месяц год -- число )
  DUP ?Високосный IF 29 ELSE 28 THEN ДнейВМесяце 1+ C!
  ДнейДоНачалаГода
  SWAP ДнейДоНачалаМесяца + +
  1+ \ для совместимости с MS Access считаем даты с 30.12.1899
;
: МесяцДень
  1+
  12 0 DO
       ДнейВМесяце I + C@
       -
       DUP 0 > 0= IF ДнейВМесяце I + C@ + I 1+ UNLOOP EXIT THEN
       LOOP 0
;
: Дата> ( число -- день месяц год )
  2- DUP
  100 36525 */ ( год-1900 )
  1900 + DUP >R
  DUP ?Високосный IF 29 ELSE 28 THEN ДнейВМесяце 1+ C!
  ДнейДоНачалаГода -
  МесяцДень R>
;
: Дата>S ( дата -- addr u )
  Дата> S>D <# # # # # [CHAR] . HOLD
               >R + R> # # [CHAR] . HOLD
               >R + R> # # #>
;
: >Дата:
  BL SKIP [CHAR] . WORD ?LITERAL [CHAR] . WORD ?LITERAL BL WORD ?LITERAL
  >Дата
;
: ТекущаяДата
  TIME&DATE >Дата NIP NIP NIP
;
: Дата.
  Дата>S TYPE
;
: ТекущаяДата.
  ТекущаяДата Дата.
;
: ТекущееВремя.
  TIME&DATE 2DROP DROP
  0 <# [CHAR] : HOLD # # #> TYPE
  0 <# [CHAR] : HOLD # # #> TYPE
  0 <# # # #> TYPE
;
: >Date ( addr u -- date )
  TIB >R >IN @ >R #TIB @ >R
  #TIB ! >IN 0! TO TIB ['] >Дата: CATCH
  R> #TIB ! R> >IN ! R> TO TIB
  THROW
;