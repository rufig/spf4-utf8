\ ��������� ��� �������� ����������� �������.
\ ������� ������� �������, ������� ������������� � ����. 
\ ��� ������ ������� �������� ������� � ���� ���������.

\ S" 2 DUP * ." axt ( xt ) -- ������ �� ���� ����� ����
\ ������� ������������ ���� ������������� ��� ����������
\ ������

\ ������ ����� ������� ������� ���� ���������� �������
\ ������ DESTROY-VC �� ~profit/lib/compile2Heap.f

\ ����� ������� ������� ���� �������������, ��� ������ 
\ �� �������� ����������� (��� ��� �������� "�� �������"
\ bac4th-������) ����� ������������ axt=>
\ S" 2 DUP * ." axt=> ( xt )

\ �������� ����� ������� ���� ������ � ��������� �����
\ ����� ������������ ������ ~ac/lib/str5.f
\ (�� ������� ������):
\ " 2 DUP
\ * . " straxt=> ( xt )

\ ��� ���� � ������������ ������� ���� ���� ����� ����������������
\ ���� �����, ������� �� �� ����� ��� �������� ������������� ��������
\ IMMEDIATE-������� ��������� LITERAL , ��� ����� ������������ ���
\ �������� ����� �� ����� � ������������� �������:
\ 4 2 1 S" LITERAL LITERAL + LITERAL * ." axt EXECUTE
\ ���������� ��� "1 2 + 4 *" � �������� ���, ����������: "12"

\ ��� �� ����� ������� �������� � ����� ������������� ������� [ � ] :
\ ' . S" 3 0 DO I [ COMPILE, ] LOOP " axt EXECUTE
\ ������� 0 1 2
\ �������� ��� ��������� ����� �� ������ ������� ��������� ( ' . )
\ [ COMPILE, ] ������������� xt ������ ������������ �������

\ ����� �������� ��������, ������ "���������", ������������
\ ���������� ������ ������ 3.2.3.2 ANS-94:

\ "���� ������-����������, �����, �� �� �����������, ��������� 
\ ������������ � ����������. ���� �� ����������, �� ����� ����,
\ �� �� �����������, ���������� � �������������� ����� ������.
\ ������ ����� ������-���������� -- ������������  �����������.
\ ��� ��� ���� ������-����������  ����� ���� ���������� � 
\ �������������� ����� ������, ��������, ���������� �� ���� 
\ ������ ���������� ��� �������� ����� ��������� ���������
\ �� ���� ������-����������, � �������� ����������� �� �������� 
\ ��������� ����� ������-����������."

\ REQUIRE MemReport ~day/lib/memreport.f

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE STR@ ~ac/lib/str5.f
REQUIRE FREEB ~profit/lib/bac4th-mem.f
REQUIRE LOCAL ~profit/lib/static.f
\ REQUIRE EVALUATED-HEAP ~profit/lib/evaluated.f
REQUIRE VC-COMPILED ~profit/lib/compile2Heap.f
REQUIRE A_BEGIN ~mak/lib/a_if.f
REQUIRE no-inline ~profit/lib/no-inline.f

MODULE: bac4th-closures

\ ���������� ��������� ���������� � ��������� control-flow stack
: BEGIN [COMPILE] A_BEGIN ; IMMEDIATE
: WHILE	[COMPILE] A_WHILE ; IMMEDIATE
: AHEAD	[COMPILE] A_AHEAD ; IMMEDIATE
: IF 	[COMPILE] A_IF ; IMMEDIATE
: ELSE	[COMPILE] A_ELSE ; IMMEDIATE
: THEN	[COMPILE] A_THEN ; IMMEDIATE
: AGAIN	[COMPILE] A_AGAIN ; IMMEDIATE
: REPEAT [COMPILE] A_REPEAT ; IMMEDIATE
: UNTIL [COMPILE] A_UNTIL ; IMMEDIATE




WARNING @ WARNING 0!
{{ no-inline DEFINITIONS
\ "������" ����������� � ������� no-inline
\ ����� ��� ���� ������������ ��������� control-flow stack
: DO    CS-SP>< POSTPONE DO    CS-SP>< ; IMMEDIATE
: ?DO   CS-SP>< POSTPONE ?DO   CS-SP>< ; IMMEDIATE
: LOOP  CS-SP>< POSTPONE LOOP  CS-SP>< ; IMMEDIATE
: +LOOP CS-SP>< POSTPONE +LOOP CS-SP>< ; IMMEDIATE
}} DEFINITIONS
WARNING !

EXPORT

: axt ( addr u -- xt ) LOCAL t
CREATE-VC t ! \ ������ ����������� ��������
ALSO bac4th-closures \ ���������� ������� � ������ ����������� ����������
t @ VC-COMPILED \ ����������� ������ � ����������� ��������
PREVIOUS \ ��������� ��� �� ��������� ����������
t @ VC-RET, \ ������ ������� ������
t @ \ ���� ����������� ����� ������ ���������
;


: axt=> ( addr u --> xt \ <-- ) PRO
axt \ ����������� ������, ���� ����������� ����� ����
BACK DESTROY-VC TRACKING RESTB \ �� ��������� ��������� �������� ��������
CONT \ � ������ ��� ������
;

\ �� �� ����� ��� � compiledCode , �� � ������������� �������� �� ~ac/lib/str4.f
\ ��� ��������� ������ ��� � ��������� �����
: straxt=> ( s --> xt \ <-- ) PRO LOCAL s DUP s ! STR@ axt=> s @ STRFREE CONT ;

: compiledCode ( addr u --> xt \ <-- ) \ ������� ��� axt=>
RUSH> axt=> ;

: STRcompiledCode  ( s --> xt \ <-- ) RUSH> straxt=> ;

;MODULE

/TEST
REQUIRE SEE lib/ext/disasm.f

0 VALUE t 

: showMeTheCode ( addr u -- ) compiledCode XT-VC DUP TO t DUP REST EXECUTE CR CR ;

\ ��������� ������ �� ����� ������ ������������� ����
$> 4 2 1 S" LITERAL LITERAL + LITERAL * ." showMeTheCode


\ ��������� ������ �� ����� ������ ����� ������������� ����
$> 23 100 5 S" 0 BEGIN DUP LITERAL < WHILE LITERAL LITERAL + . 1+ REPEAT DROP " showMeTheCode

\ ��������� ������ �� ����� ������ ����� ������������� ����
$> 11 S" 3 0 DO LITERAL . LOOP " showMeTheCode

\ ��������� ��� ������� "������" ���������
$> ' . S" 3 0 DO I [ COMPILE, ] LOOP " showMeTheCode