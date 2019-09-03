( Работа с сокетами в стиле PHP.  Andrey Cherezov 30.Mar.2000

  fsockopen < server port -- socketline >
    Например: " www.forth.org.ru" 80 fsockopen -> s
    - соединиться с сервером server по порту port и вернуть соединенный сокет.

  fclose < socketline -- >
    - закрыть сокет и соответственно разорвать его соединение
    - для той стороны это будет graceful close, т.е. нормальное закрытие

  fputs < str socketline -- >
    Например " MAIL FROM:<ac@forth.org.ru>{CRLF}" s fputs
    - отправить строку str в сокет socketline

  fgets < socketline -- str >
    - прочесть строку из сокета

  Все слова throwable - в случае любой ошибки выполняется THROW.
  Сбор строчной памяти на совести вызывающей программы.

  Дополнительный пример TEST в конце текста.

)

REQUIRE CreateSocket ~ac/lib/win/winsock/ws2/sockets.f
REQUIRE SocketLine   ~ac/lib/win/winsock/ws2/socketline2.f
REQUIRE STR@         ~ac/lib/str5.f

\ socketline - замена сокета во всех операциях
\ специальная структура, хранящая доп.данные для буферизации

: fsock ( socketline -- socket )
  sl_socket @
;
: fsockopen ( server port -- socketline )
  { server port \ sock ip }
  server STR@ GetHostIP THROW -> ip
  CreateSocket THROW -> sock
  60000 sock SetSocketTimeout THROW
  ip port sock ConnectSocket 
  ?DUP IF sock CloseSocket DROP THROW THEN
  sock SocketLine
;
\ : fclose ( socketline -- )
\   fsock CloseSocket THROW
\ ;
: fclose ( socketline -- )
\ fixed by Sergey Shisminzev [sergey@michint.kiev.ua]
  DUP fsock CloseSocket THROW  \ лучше DROP
  FREE THROW
;
: fputs ( str socketline -- )
  { str sock }
  str STR@
  sock fsock WriteSocket THROW
;
\ : fgets ( socketline -- str )
\   { sock \ str }
\   "" -> str
\   sock SocketReadLine str STR!
\   str
\ ;
: fgets ( socketline -- str ) \ ~ruv 13.02.2002
  { sock \ str }
  sock SocketReadLine
  "" -> str  str STR!
  str
;


( \ Пример: обращение к локальному веб-серверу и печать 20 строк ответа

: TEST
  { \ s }
  SocketsStartup THROW
  " localhost" 80 fsockopen -> s
" GET / HTTP/1.0
Connection: close

" s fputs
  20 0 DO s fgets STYPE CR LOOP
  s fclose
;
)