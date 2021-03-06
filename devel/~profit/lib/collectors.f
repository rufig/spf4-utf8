\ Накопители текста.

: буффер CREATE 0 , 0 , ; \ буфферы на самом деле не хранят информацию, они записывают лишь ссылку на неё.
\ Например, для текста "<html>text" буффер имя-тэга будет содержать 1 и 4 (начиная с первого символа текста брать четыре буквы).
\ Ненужные перегоны строк туда-сюда исчезают. Соответственно, необходимо хранить основной текст в памяти постоянно. 
\ Можно представить себе такие буфферы как отметки фломастером в большом тексте на доске.

: начало CELL+ @ ;
: длина @ ;

буффер общий-накопитель

USER-VALUE размер-символа
1 TO размер-символа

: начать-копить ( addr -- ) 0 общий-накопитель 2! ;
: копить-дальше размер-символа общий-накопитель +! ;
: протянуть ( addr -- ) общий-накопитель начало - общий-накопитель ! ;

: запомнить ( addr -- ) >R общий-накопитель 2@  R> 2! ;
: очистить ( addr -- ) 0 0 ROT 2! ;