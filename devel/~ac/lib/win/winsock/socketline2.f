( Библиотека для построчного буферизированного чтения из сокета.
  Copyright 1996-1999 A.Cherezov ac@eserv.ru
)

REQUIRE { ~ac/lib/locals.f
REQUIRE CreateSocket ~ac/lib/win/winsock/sockets.f

10000 VALUE LINE_BUFF_SIZE         \ размер буфера

0                                  \ структура "строчный сокет"
4 -- sl_socket                     \ читаемый сокет
4 -- sl_point                      \ смещение в буфере текущей позиции чтения
4 -- sl_last                       \ адрес в буфере текущей позиции выборки
CONSTANT /sl


\ SocketLine инициализирует буфер для построчного чтения заданного сокета
\ и возвращает адрес этой структуры

: SocketLine ( socket -- addr-S )
  { \ addr }
  LINE_BUFF_SIZE /sl + ALLOCATE THROW -> addr
  addr sl_socket !
  addr sl_point 0!
  addr /sl + addr sl_last !
  addr
;

\ SocketGetPending получает из буфера всё, что там осталось,
\ не меняя указателей в буфере

: SocketGetPending ( addr-S -- addr1 u1 )
  { addr }
  addr sl_last @
  addr /sl + addr sl_point @ + OVER - 0 MAX
;

\ SocketReadFromPending получает из оставшихся в буфере данных
\ не более u1 байт
\ Указатели сдвигаются, т.е. эти данные "убираются" из буфера.

: SocketReadFromPending ( u1 addr-S -- addr1 u2 ) \ u2 <= u1
  { u1 addr }
  addr SocketGetPending NIP u1 > 0=
  IF addr SocketGetPending
     addr sl_point 0!
     addr /sl + addr sl_last !
  ELSE
     addr SocketGetPending u1 MIN
     addr sl_last @ OVER + addr sl_last !
  THEN
;

\ SocketContRead
\

: SocketContRead1 ( addr-S -- )
  { addr \ a u }
  addr SocketGetPending
  OVER C@ 10 ( LF ) = OVER 0 > AND IF 1- SWAP 1+ SWAP THEN -> u -> a
  a addr /sl + u MOVE
  addr /sl + addr sl_last !

  addr /sl + u +
  LINE_BUFF_SIZE u -
  DUP 0 > 
  IF
    addr sl_socket @ ReadSocket THROW
    u + addr sl_point !
  ELSE 2DROP THEN
;
: SocketContRead2 ( addr-S -- ior )
  { addr \ a u }
  addr SocketGetPending -> u -> a
  a addr /sl + u MOVE
  addr /sl + addr sl_last !

  addr /sl + u +
  LINE_BUFF_SIZE u -
  addr sl_socket @ ReadSocket
\  DUP 10060 = IF a u DUMP CCR THEN
  DUP IF NIP 0 ELSE SWAP THEN ( ior 0|n )
  u + addr sl_point !
;
: SocketContRead SocketContRead2 THROW ;

\ SocketReadLine читает строку, ограниченную LF или CRLF
\ Сам ограничитель в возвращаемую строку не включается.
\ Если строка достигла размера буфера, но разделитель не
\ найден, то строка режется на текущей длине. Остаток будет
\ выдаваться следующими вызовами этой функции.
\ Если разделитель не найден, и в буфере еще есть куда
\ читать, то продолжается реальное чтение из сокета 
\ (возможно блокирующее).
: SocketReadLine ( addr -- addr1 u1 )
  { addr \ pa1 pu1 acr }
  BEGIN
    addr SocketGetPending -> pu1 -> pa1
    pa1 pu1 LT 1+ 1 SEARCH
    IF
        DROP -> acr
        acr 1+ addr sl_last !
        pa1 acr OVER - 2DUP + 1- C@ 13 = IF 1- 0 MAX THEN
        EXIT
    THEN  2DROP
    pu1 LINE_BUFF_SIZE =
    IF
       addr sl_point 0!
       addr /sl + addr sl_last !
       pa1 pu1 EXIT
    THEN
    addr SocketContRead2
    DUP -1002 = IF pu1 IF ( ior ) DROP
      LINE_BUFF_SIZE addr SocketReadFromPending EXIT
    THEN THEN THROW
  AGAIN
;
: CreateServerSocket ( port -- socket )
  { port \ s }
  CreateSocket THROW -> s
  port s BindSocket THROW
  s ListenSocket THROW
  s
;
