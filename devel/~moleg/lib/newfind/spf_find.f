\ 11-11-2006 ��� ����������� ��� ������ ������������ ����������
\            sfind �� ��-������, ���������� �� �����, � �� ������
\            ������� ����� �������� Sfind. ������������ ����� ����
\            �� ������ 4.17

\ 2006-12-09
\ �� ������ ����� ������ ��������� ������
: ID>ASC COUNT ;

\ 22-09-2006
\ ����� �������� ��������� ��������� �������������� �����
\ � �������� ������� � ���������� �����
: identify ( asc # nameid --> flag )
           ID>ASC 2SWAP COMPARE ;



\ ����� �����������, �������� ������� c-addr u � ������ ����, ����������������
\ wid. ���� ����������� �� �������, ������� ����.
\ ���� ����������� �������, ������� ���������� ����� xt � ������� (1), ����
\ ����������� ������������ ����������, ����� ����� ������� (-1).
: SEARCH-WORDLIST1 ( c-addr u wid -- 0 | xt 1 | xt -1 )
      @ BEGIN DUP WHILE
\              DUP >R ID>ASC 2OVER COMPARE
               >R 2DUP R@ identify
                  WHILE
                  R>
              CDR
         REPEAT
           2DROP
           R> DUP NAME>C @
              SWAP ?IMMEDIATE IF 1 ELSE -1 THEN  \ ���������, �� ����� �����
         EXIT                                    \ ���� ����� ���� ��� ���������
        THEN NIP NIP ;                           \ � ?IMMEDIATE

DECIMAL

\ 2006-12-09
' SEARCH-WORDLIST1 TO SEARCH-WORDLIST

\ ����� ���������� ����� �����, ����������������� ������� asc #
\ � ������ �������� widn .. wid1. ������ �������� ����� �������������� �����
: sfindin ( 0 widn .. wid1 asc # --> addr u 0 | xt 1 | xt -1 )
          2>R

          BEGIN DUP WHILE
                2R@ ROT SEARCH-WORDLIST
                        DUP 0= WHILE
                DROP
           REPEAT
              BEGIN ROT WHILE REPEAT
              RDROP RDROP EXIT
          THEN

          2R> ROT ;


\ ��������� ��������� CORE FIND ���������:
\ ������ ����������� � ������, �������� ������� addr u.
\ ���� ����������� �� ������� ����� ��������� ���� ������� � ������� ������,
\ ���������� addr u � ����. ���� ����������� �������, ���������� xt.
\ ���� ����������� ������������ ����������, ������� ����� ������� (1);
\ ����� ����� ������� ����� ������� (-1). ��� ������ ������, ��������,
\ ������������ FIND �� ����� ����������, ����� ���������� �� ��������,
\ ������������ �� � ������ ����������.
: SFIND ( addr u -- addr u 0 | xt 1 | xt -1 ) \ 94 SEARCH
        2>R 0 GET-ORDER DROP
        2R> sfindin ;

: LATEST ( -> NFA ) GET-CURRENT @ ;

\ ��������� ��������� CORE FIND ���������:
\ ������ ����������� � ������, �������� ������� �� ��������� c-addr.
\ ���� ����������� �� ������� ����� ��������� ���� ������� � ������� ������,
\ ���������� c-addr � ����. ���� ����������� �������, ���������� xt.
\ ���� ����������� ������������ ����������, ������� ����� ������� (1);
\ ����� ����� ������� ����� ������� (-1). ��� ������ ������, ��������,
\ ������������ FIND �� ����� ����������, ����� ���������� �� ��������,
\ ������������ �� � ������ ����������.
: FIND1 ( c-addr -- c-addr 0 | xt 1 | xt -1 ) \ 94 SEARCH
        DUP >R COUNT SFIND
        DUP 0= IF NIP NIP R> SWAP ELSE RDROP THEN ;
