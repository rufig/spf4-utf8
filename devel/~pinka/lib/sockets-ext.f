REQUIRE ReadSocket ~ac/lib/win/winsock/SOCKETS.F

: READOUT-SOCK ( a u1 h -- a u2 ior ) \ on likeness READOUT-FILE
  >R OVER SWAP R>   ( a a h1 h )
  ReadSocket        ( a u2 ior )
  DUP -1002 = IF 2DROP 0. THEN
;
: ReadoutSocket ( a u1 h -- a u2 ior ) \ on likeness ReadSocket
  READOUT-SOCK
;

\ READ-SOCK-EXACT ( a u socket -- ior )
\ ReadSocketExact ( a u socket -- ior )
\ -- � ������� ~ac/lib/win/winsock/SOCKETS.F


REQUIRE PutFileTr   ~ac/lib/win/winsock/transmit.f

: WRITE-SOCK-FILE ( h sock -- ior ) PutFileTr ;
\   file (data to send) should not be larger than 2,147,483,646 bytes
\ TODO:
\   Workstation and client versions of Windows [...] limiting the number of concurrent TransmitFile operations 
\   allowed on the system to a maximum of two. 

: WRITE-SOCK-FILENAME ( d-filename sock -- ior )
  >R
  R/O OPEN-FILE-SHARED-DELETE DUP IF NIP RDROP EXIT THEN ( 0 ) DROP
  R> OVER >R
  WRITE-SOCK-FILE
  R> CLOSE-FILE OVER IF DROP EXIT THEN NIP
  ( ����, ������� ��������� � �������� ��������, ����� �� ������. ���� ��� ������ �����������,
    �� TransmitFile ��� � �������� [� �������� ������ ��� ��������?].
    ������� �������������� ��������: ��������� ����� ���� � ������������ ������, ������ shared.
  )
;

\ just aliases:
: WRITE-SOCKET-FILE     (          h sock -- ior ) WRITE-SOCK-FILE ;
: WRITE-SOCKET-FILENAME ( d-filename sock -- ior ) WRITE-SOCK-FILENAME ;

( -- discussion

  ����� ����, � ������ ������ '-SOCK' ������������ '-SOCKET'?
  ��. ~pinka/model/protocol/http/write-basic.f.xml
)
