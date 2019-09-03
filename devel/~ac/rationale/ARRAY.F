: Limits ( addr size -- addr2 addr )
  OVER + SWAP
;
: CELL ( -- cellsize )
  1 CELLS
;

( Выполнить xt над каждым элементом массива, заданного адресом начала
  и размером в байтах. Размер элемента массива - cell.
  возвращается addr - адрес в массиве, при обработке которого xt
  вернул true. Массив при этом проходится не до конца.
  Если везде возвращал false, то по окончании обработки возвращается 0.
)
: ArrayForEach ( ... xt array size -- addr )  \ size - размер массива в байтах
  Limits ?DO I @ SWAP DUP >R EXECUTE
             IF R> DROP I UNLOOP EXIT THEN
             R>
         CELL +LOOP DROP 0
;
: (ArraySearch) ( n -- n flag )
  OVER =
;
: ArraySearch ( n array size -- addr | 0 )
  ['] (ArraySearch) ROT ROT ArrayForEach NIP
;

\ Примеры

\ CREATE Array1 11 , 22 , 33 ,

\ 22 Array1 3 CELLS ArraySearch @ .
\ 33 Array1 3 CELLS ArraySearch @ .
\ 44 Array1 3 CELLS ArraySearch .
