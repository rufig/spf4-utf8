\ 14.May.2002 Tue 12:57 Ruv
\ 16 May,2002 af  af@forth.org.ru
( Когда CALLBACK-функция работает в контексте потока форт-системы,
  можно обойтись простым и более быстрым вариантом WNDPROC,
  который здесь определен.
  Если функция, определенная через QUICK_WNDPROC , будет работать в ином
  потоке,  то она ни явно ни косвенно не должна обращаться к user-переменным.
)

WINAPI: TlsAlloc    KERNEL32.DLL
WINAPI: TlsFree     KERNEL32.DLL
WINAPI: TlsSetValue KERNEL32.DLL
WINAPI: TlsGetValue KERNEL32.DLL

0 VALUE TlsIndexStore

: SaveTlsIndex ( -- )
\ сохранить TlsIndex текущего потока в специальной локальной ячейке потока
    TlsIndex@ TlsIndexStore TlsSetValue DROP \ ловить исключение некому.
;
: RestoreTlsIndex ( -- )
\ восстановить TlsIndex текущего потока из специальной локальной ячейки потока
    TlsIndexStore TlsGetValue TlsIndex!
;

..: AT-PROCESS-FINISHING ( -- )
    TlsIndexStore TlsFree DROP
;..
..: AT-PROCESS-STARTING ( -- )
    TlsAlloc DUP 0xFFFFFFFF = IF GetLastError THROW THEN
    TO TlsIndexStore
;..
..: AT-THREAD-STARTING ( -- )  SaveTlsIndex ;..

TlsAlloc TO TlsIndexStore
SaveTlsIndex

: EXTERN2 ( xt1 -- xt2 )
  HERE
  ['] RestoreTlsIndex COMPILE,
  SWAP COMPILE,
  RET,
;

: QUICK_WNDPROC ( xt "name" -- )
  EXTERN2
  CREATE  ( -- enter_point )
  ['] _WNDPROC-CODE COMPILE,
  ,
;

( \ example
: MyCallBackWord \ -- 
  ." test passed!" CR
;
' MyCallBackWord QUICK_WNDPROC MyCallBackProc
: test \ --
  MyCallBackProc API-CALL
;
  )