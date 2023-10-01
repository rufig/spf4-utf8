REQUIRE HEAP-COPY ~ac/lib/ns/heap-copy.f

: EVALUATE, ( addr u -- ) \ компилирует строку в словарь
TRUE STATE ! \ включаем компиляцию
EVALUATE \ выполняем строку-параметр
RET, \ заканчиваем определение
STATE 0! \ выключаем компиляцию
;

: EVALUATED ( addr u -- addr-xt u-xt ) \ компилирует строку в словарь
\ выдаёт адрес и длину сгенерированного шитого кода,
\ возвращает словарь в исходное состояние
HERE >R
EVALUATE,
HERE \ текущее значение HERE, после компиляции
R@ DP ! \ восстанавливаем HERE к изначальному значению
R@ \ старое значение HERE, перед ней
( новое старое )
- ( новое-старое ) \ подсчитываем длину скомпилированной последовательности
R> SWAP ;

: COPY-CODE ( xt dest -- ) HERE SWAP DP ! SWAP INLINE, RET, DP ! ;

: EVALUATED-HEAP ( addr u -- xt ) \ компилирует строку в заводимую область в куче
EVALUATED ALLOCATE-RWX THROW TUCK COPY-CODE ;

\EOF
REQUIRE SEE lib/ext/disasm.f

: r 1 S" LITERAL SFIND RECURSE " EVALUATED-HEAP REST ; r