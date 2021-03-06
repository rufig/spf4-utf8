\ 30.12.2001 ac Исправлены ошибки с числом параметров в (ServiceControlHandler)
\               и в (ServiceMain)
\ 20.09.2002 ruvim: исправления в стековой нотации и исправление CreateSevice

REQUIRE OpenServiceA ~ac/lib/win/service/service_struct.f

WARNING @ WARNING 0!
: DeleteService ( addr u -- 0 | 1 )
  2>R DELETE_SERVICE 2R> DROP
  SC_MANAGER_ALL_ACCESS 0 0 OpenSCManagerA DUP >R
  OpenServiceA DUP >R DeleteService
  R> CloseServiceHandle DROP
  R> CloseServiceHandle DROP
;
WARNING !

: CreateService ( addr u -- 0 | handle )
  2DUP DeleteService DROP
  2>R
  0 0 0 0 0
  ModuleName DROP
  SERVICE_ERROR_NORMAL S_AUTO \ SERVICE_DEMAND_START 
  SERVICE_WIN32_OWN_PROCESS SERVICE_INTERACTIVE_PROCESS OR
  SERVICE_ALL_ACCESS
  2R@ DROP
  2R> DROP
  SC_MANAGER_ALL_ACCESS 0 0 OpenSCManagerA
  CreateServiceA
;

\ ***********************
VARIABLE CtrlHandler

: (ServiceControlHandler) ( fdwControl -- )
  \ управляющая процедура сервиса
  \ поступают аргументы =1 или =4

  DUP SERVICE_CONTROL_STOP = ( 1 )
  IF
    DROP
    SERVICE_WIN32 SERVICE_INTERACTIVE_PROCESS OR
                        SERVICE_STATUS dwServiceType !
    SERVICE_STOPPED     SERVICE_STATUS dwCurrentState !
    SERVICE_ACCEPT_STOP SERVICE_STATUS dwControlsAccepted !
    SERVICE_STATUS CtrlHandler @ SetServiceStatus DROP
    0 EXIT
  THEN
  DUP SERVICE_CONTROL_INTERROGATE = ( 4 )
  IF
    DROP
    SERVICE_WIN32 SERVICE_INTERACTIVE_PROCESS OR
                        SERVICE_STATUS dwServiceType !
    SERVICE_RUNNING     SERVICE_STATUS dwCurrentState !
    SERVICE_ACCEPT_STOP SERVICE_STATUS dwControlsAccepted !
    SERVICE_STATUS CtrlHandler @ SetServiceStatus DROP
    0 EXIT
  THEN
  DROP 120
;
' (ServiceControlHandler) WNDPROC: ServiceControlHandler

0 VALUE SERVICE_TABLE

VECT ServiceProc  ' NOOP TO ServiceProc


: (ServiceMain) ( dwArgc *lpszArgv -- void )
  2DROP

  SERVICE_WIN32 SERVICE_INTERACTIVE_PROCESS OR
                      SERVICE_STATUS dwServiceType !
  SERVICE_RUNNING     SERVICE_STATUS dwCurrentState !
  SERVICE_ACCEPT_STOP SERVICE_STATUS dwControlsAccepted !

  ['] ServiceControlHandler SERVICE_TABLE @ \ на этом участке ошибки
  RegisterServiceCtrlHandlerA DUP CtrlHandler !  \ означают скорее всего Win95
  SERVICE_STATUS SWAP SetServiceStatus DROP      \ поэтому игнорируем

  ServiceProc
  0
;
' (ServiceMain) WNDPROC: ServiceMain

: StartService ( addr u -- flag )
  HERE DUP >R SWAP DUP ALLOT MOVE 0 C,
  HERE TO SERVICE_TABLE R> , ['] ServiceMain , 0 , 0 ,
  SERVICE_TABLE StartServiceCtrlDispatcherA 0=
  ( flag=true функция не работает, возможно Win95 
    иначе выход из сервиса - останов )
;
