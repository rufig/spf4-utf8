\ $Id$

REQUIRE { lib/ext/locals.f
REQUIRE /STRING lib/include/string.f
REQUIRE /TEST ~profit/lib/testing.f

\ взять следующее слово из входного потока не сдвигая парсер
: PICK-NAME ( -- a u ) >IN @ PARSE-NAME ROT >IN ! ;

\ Вырезать имя файла из полного пути
: CUT-FILENAME ( a u -- a2 u2 ) 2DUP CUT-PATH NIP /STRING ;

\ Разбить строку a u на две подстроки, первая длины n, вторая - остаток длины u-n
\ Защита на случай n > u - возвращается исходная строка и пустая
: /GIVE { a u n -- a+n u-n a n }
    u n < IF u -> n THEN

    a n + 
    u n -
    a
    n ;

\ Преобразовать строку a u в число (только символы текущей системы счисления)
: NUMBER ( a u -- n -1 | 0 ) 0 0 2SWAP >NUMBER NIP IF 2DROP FALSE ELSE D>S TRUE THEN ; 

/TEST

REQUIRE TESTCASES ~ygrek/lib/testcase.f

TESTCASES ~ygrek/lib/parse.f

S" createdoes>" 6 /GIVE ( S" does>" S" create" ) S" create" TEST-ARRAY S" does>" TEST-ARRAY
S" createdoes>" 15 /GIVE ( S" " S" createdoes>" ) S" createdoes>" TEST-ARRAY S" " TEST-ARRAY 
S" D:\WORK\FORTH\spf4\devel\~ygrek\lib\parse.f" CUT-FILENAME S" parse.f" TEST-ARRAY

(( S" 323" NUMBER -> 323 -1 ))
(( S" 0x323" NUMBER -> 0 ))
(( S" " NUMBER -> 0 -1 )) \ bug or feature?
(( S" -1" NUMBER -> 0 ))

END-TESTCASES
