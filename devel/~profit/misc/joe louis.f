REQUIRE RANDOM lib/ext/rnd.f 
REQUIRE NOT ~profit/lib/logic.f 

MODULE: louis

123 ->VARIABLE r2
123 ->VARIABLE r3

\ тут должны быть мозги
\ память и прочие анализы
\ но их нет.. (пока?)

EXPORT

: move ( -- flag ) 32 CHOOSE 15 >  DUP r3 @ = OVER r2 @ = AND IF NOT THEN DUP r2 @ r3 ! r2 ! ;
: board ( state -- ) DROP ;

;MODULE

\ Луис работает случайными ударами. Но обязательно следит чтобы не дисквалифицироваться.