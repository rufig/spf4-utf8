\ 21-06-2005 �������� �� ������ ���������� id �������� �� �����

	0 VALUE acc

\ �� ������������! ���������� � ����� ���������!
: (scan) ( wid n --> )
	  2DUP
	  BEGIN DUP WHILE
	    2DUP CELLS RP+@ <> WHILE 1-
	   REPEAT -1 EXIT
	  THEN 0 ;

\ �������� ������ ������ �� GET-ORDER �� ������������ ��������
: prepare ( wida widb ... widn n --> wida widb ... widn n )
	1- TO acc

	>R 1 >R

	\ ���� � ������
	BEGIN acc WHILE
	   R> (scan)
	     IF    2DROP >R DROP
	      ELSE 2DROP 1+ 2>R
	     THEN
	  acc 1- TO acc
	REPEAT

	\ ����������� �� ���� ������
	R> DUP TO acc
	BEGIN DUP WHILE R> SWAP 1- REPEAT
	DROP acc ;

\EOF ������������ � FIND
     �������� ����� ���� � �������, �������� ��� ������, �����
     ���������� ����� ��������� � ����� ���� ��������� �����, �����
     ��� ���������� �������� �� ������ ���������.

	�� ����, ���� � ��������� �����:

	ROOT FORTH FORTH

	�� ����� prepare ���������:

	ROOT FORTH

	��������������, ������� ������ �� ����������, ���������
���������� �������� ��� ����������� �� �� ������� � ����������� ��������
�����������.

