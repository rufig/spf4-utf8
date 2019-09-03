( str_list.f - реализация простых списков, в частности списков строк.
  DoList, NodeValue, AddNode, FreeList работают с односвязными
  списками. Каждый элемент списка хранит значение value [ячейка]
  и указатель на следующий элемент. Т.е. там не обязательно строки.
  Только inList считает, что значение value списка является 
  адресом xcount-строки.
)

: XCOUNT ( addr -- addr1 u1 )
\ получить строку addr1 u1 из строки со счетчиком addr
\ счетчик - ячейчка, а не байт, в отличие от обычного COUNT
  DUP @ SWAP CELL+ SWAP
;
: NodeValue ( node -- value )
\ получить значение элемента списка
  CELL+ @
;
: NextNode ( node1 -- node2 | 0 )
  @
;
: FirstNode ( list -- node )
  @
;
: DoList ( xt list -- )
\ выполнить токен xt для каждого элемента (node, а не value) списка list
\ xt ( node -- )
  SWAP >R FirstNode
  BEGIN
    DUP
  WHILE
    DUP NextNode SWAP R@ EXECUTE
  REPEAT R> 2DROP
;

: inList ( addr u list -- flag )
\ проверяет, находится ли строка addr u в списке строк list
  ROT ROT 2>R FirstNode
  BEGIN
    DUP
  WHILE
    DUP NodeValue XCOUNT 2R@ COMPARE 0= IF DROP 2R> 2DROP TRUE EXIT THEN
    NextNode
  REPEAT 2R> 2DROP
;
: FreeNode ( node -- )
  FREE THROW
;
: FreeList ( list -- )
\ освобождает динамическую память, занимаемую структурами списка.
\ Не освобождает память, выделенную элементам списка, если эти
\ элементы - внешние значения, например строки.
  ['] FreeNode OVER DoList 0!
;
: AddNode ( value list -- )
\ добавляет value в список list
  2 CELLS ALLOCATE THROW >R
  SWAP R@ CELL+ !
  DUP @ R@ !
  R> SWAP !
;
: ReverseList ( list -- )
\ развернуть порядок элементов в списке на обратный
  DUP >R 0 >R RP@ >R
  FirstNode
  BEGIN
    DUP
  WHILE
    DUP NextNode SWAP DUP NodeValue R@ AddNode FreeNode
  REPEAT DROP
  RDROP R> R> !
;