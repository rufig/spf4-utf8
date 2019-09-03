\ MEM% - сколько процентов физической памяти занято

WINAPI: GlobalMemoryStatus KERNEL32.DLL

: MEM% ( -- n )
  PAD GlobalMemoryStatus DROP PAD CELL+ @
;