\ bac4th'овая версия ~ygrek/prog/web/irc/quotes.f
\ Просто та программа мне кажется тяжеловатой для восприятия...
\ А зато эта программка легкомысленно обращается с ресурсами --
\ например, thQuote будет всегда анализировать весь файл, даже
\ даже если ему нужна первая строчка (лениво переделывать, хотя
\ и несложно...). А также она постоянно перечитывает файл цитат,
\ т. е. не держит цитаты "в уме", и даже для определения кол-ва
\ цитат идёт чтение текстового файла.

\ Те кто подумали что эта программа -- больше, могут убедиться
\ что текст комментариев к этой программе занимает места больше
\ самого кода.

\ REQUIRE MemReport ~day/lib/memreport.f
REQUIRE FILE ~ac/lib/str4.f
REQUIRE ULIKE ~pinka/lib/like.f
REQUIRE PRO ~profit/lib/bac4th.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE FREEB ~profit/lib/bac4th-mem.f
REQUIRE arr{ ~profit/lib/bac4th-sequence.f
REQUIRE split-patch ~profit/lib/bac4th-str.f
REQUIRE GENRAND ~ygrek/lib/neilbawd/mersenne.f
REQUIRE ATTACH-LINE-CATCH ~pinka/samples/2005/lib/append-file.f

' ANSI>OEM TO ANSI><OEM \ кодировку ставим в консоли



: LOAD-FILE ( addr u -- addr u ) PRO FILE OVER FREEB DROP CONT ; \ хаваем файл
: TAKE-TWO PRO *> <*> BSWAP <* CONT ; \ удвоение успехов


: DCELL/ ( u1 -- u2 ) 2/ CELL / ;

: DCELL[] ( addr u i -- d )        \ addr u -- адрес и длина массива двойных значений
LOCAL i i !                        \ i -- индекс элемента который надо взять из этого массива
DUP DCELL/ i @ <                   \ проверяем превышение индекса
SWAP 0=                            \ и пустоту массива
OR IF DROP S" no quotes found" EXIT THEN \ для обоих краевых случаев -- одна отмаза
i @ 2* CELLS + 2@ ;



WINAPI: GetTickCount KERNEL32.DLL
GetTickCount SGENRAND \ заряжаем рулетку


: randomDCELL[] ( addr u -- d ) DUP DCELL/ GENRANDMAX DCELL[] ;
\ из массива двойных значений берём элемент со случайным индексом

: qF S" .\quotes.txt" ;

: quotes ( -- list-xt ) \ list-xt - итератор-список двойных значений
PRO qF LOAD-FILE
seq{
byRows split-patch \ делим на строки
DUP ONTRUE \ пустые строки убираем
}seq2 CONT ;

: quotesLen ( -- len ) \ считаем кол-во строчек в файле
+{ quotes ENTER  1 }+ ;

: quotesArr ( --> addr u \ <-- ) PRO quotes arr{ ENTER TAKE-TWO }arr CONT ;

: thQuote ( n --> addr u \ <-- ) PRO \ n-ая строка из файла
quotesArr ROT DCELL[] CONT ;

: randomQuote ( --> addr u \ <-- ) \ выводим случайную строчку (цитату) из файла
PRO quotesArr randomDCELL[] CONT ;

\ : FOUND ( addr1 u1 addr2 u2 -- f ) " *{s}*" DUP >R STR@ ULIKE R> STRFREE ;
\ а всё равно не работает даже с ULIKE регистронезависимость, допустим русских букв...
: FOUND ( addr1 u1 addr2 u2 -- f ) SEARCH NIP NIP ;


: searchQuote ( addr u --> addr1 u1 \ <-- ) PRO LOCAL sLen sLen ! LOCAL sAddr sAddr !
quotes arr{ ENTER 2DUP sAddr @ sLen @ FOUND ONTRUE TAKE-TWO }arr ( addr u )
\ подходящие под описание цитаты загоняются в массив
randomDCELL[] CONT ; \ и из массива выковыриваем случайный элемент

: addQuote ( addr u -- ) qF ATTACH-LINE-CATCH THROW ;

\EOF
S" Doh! [Homer]" addQuote


REQUIRE iterateBy ~profit/lib/bac4th-iterators.f

: r 1 10  1 iterateBy  \ десять раз
randomQuote CR TYPE ; \ распечатать случайную цитату
r

: r2 1 4  1 iterateBy \ четыре раза
S" Лен" searchQuote CR TYPE ; \ поискать цитату с "Ле"
CR r2
\ MemReport