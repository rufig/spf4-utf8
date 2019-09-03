\ XML-сканер (не парсер!). Опознаёт в исходном тексте разные части кода

REQUIRE буффер ~profit/lib/collectors.f
REQUIRE таблица ~profit/lib/chartable.f

буффер накопленный-текст \ туда сливаем куски текста

\ | отмечает текущее положение курсора, на момент вызова обработчика
\ <tag|
' 2DROP ->VECT открыть-тэг ( addr u -- )
\ <tag attr=val|
:NONAME 2DROP 2DROP ; ->VECT внести-атрибут ( addr1 u1 addr2 u2 -- )
\ <tag attr=val>|
VECT закончить-атрибуты ( -- )
\ </tag>|
' 2DROP ->VECT закрыть-тэг ( addr u -- )
\ <tag>text|
' 2DROP ->VECT внести-текст ( addr u -- )
\ <! sdfdf|
' 2DROP ->VECT внести-комментарий ( addr u -- )

буффер имя-тэга
буффер имя-атрибута
буффер значение-атрибута

состояние в-тексте
состояние в-комментариях
состояние в-ожидании-имени-тэга
состояние в-имени-тэга
состояние пропустить-атрибуты
состояние в-имени-закрывающегося-тэга
состояние в-ожидании-имени-атрибута
состояние в-имени-атрибута
состояние в-ожидании-значения-атрибута
состояние в-значении-атрибута
состояние в-значении-атрибута-в-апострофах
состояние в-значении-атрибута-в-кавычках
состояние в-ожидании-знака-равенства-или-следующего-атрибута


: сбросить-накопленное накопленный-текст запомнить  накопленный-текст 2@ внести-текст ;

в-тексте
на-входе:  отсюда начать-копить ; \ делаем отметку
все:  копить-дальше ;
символ: <  сбросить-накопленное в-ожидании-имени-тэга ;
\ начинается тэг, переходим в его обработке
строка-кончилась:  сбросить-накопленное ;
\ страховка: если текст оборвётся на этом месте, до символа ">", то
\ накопленное сбросится как обычный текст

: от-конца-накопленного-текста
накопленный-текст 2@ + начать-копить
отсюда протянуть вернуть-букву  сбросить-накопленное ;
\ Начиная от конца последнего накопленного и сброшенного отрезка текста,
\ до текущего положения курсора, сбросить как текст

в-ожидании-имени-тэга
все:  вернуть-букву  в-имени-тэга ;
\ это OTHERWISE, то что сработает, если не сработает ни одно из нижних случаев.
\ То есть: "если после символа < следующий символ будет не !, не >, не / и этим 
\ файл не кончается, то значит это уже началось имя тэга".
\ Надо вернуть-букву , так как на анализ что это вообще имя тэга первая буква была
\ поглощена, и её нужно вернуть чтобы она правильно встала в имя тэга.
символ: ! в-комментариях ; \ <! -- это начало комментария, обрабатываем
символ: >  от-конца-накопленного-текста в-тексте ; \ <> -- это просто символ
символ: /  в-имени-закрывающегося-тэга ; \ </ -- закрывающий тэг
строка-кончилась:  от-конца-накопленного-текста ;

в-имени-тэга
на-входе:  отсюда начать-копить ;
все:  копить-дальше ;
\ <tag |
разделители:  имя-тэга запомнить  имя-тэга 2@ открыть-тэг  в-ожидании-имени-атрибута ;
\ <tag>|
символ: >  имя-тэга запомнить  имя-тэга 2@ открыть-тэг  закончить-атрибуты  в-тексте ;
строка-кончилась:  от-конца-накопленного-текста ;

в-имени-закрывающегося-тэга
на-входе:  отсюда начать-копить ;
все:  копить-дальше ;
\ </tag |
разделители:  имя-тэга запомнить  имя-тэга 2@ закрыть-тэг  пропустить-атрибуты ;
\ </tag>|
символ: >  имя-тэга запомнить  имя-тэга 2@ закрыть-тэг  в-тексте ;
строка-кончилась:  от-конца-накопленного-текста ;

TRUE VALUE реагировать-на-закрывающую
в-комментариях
на-входе:  отсюда начать-копить ;
все:  копить-дальше ;
\ <!comment>| 
символ: > реагировать-на-закрывающую IF общий-накопитель 2@ внести-комментарий  в-тексте ELSE копить-дальше THEN ;
\ <!comment-|
символ: - дать-букву [CHAR] - = IF копить-дальше  реагировать-на-закрывающую 0= TO реагировать-на-закрывающую
ELSE вернуть-букву THEN копить-дальше ; \ две черты "--" в комментариях переключают реагирование на закрывающую
\ угловую скобку


пропустить-атрибуты
символ: >  в-тексте ; \ просто проходим все символа, ожидая ">"
строка-кончилась:  от-конца-накопленного-текста ;

: пустой-атрибут 0 0 ;
: отметка-атрибута 1 0 ; \ значение атрибута в случае его задания таким образом: <tag attr>

: отметить-атрибут имя-атрибута 2@ отметка-атрибута внести-атрибут ;

в-ожидании-имени-атрибута
все:  вернуть-букву в-имени-атрибута ;
разделители:  ;
символ: /  закончить-атрибуты  имя-тэга 2@ закрыть-тэг  пропустить-атрибуты ;
\ если вместо названия атрибута нам встретился знак "/", то считаем этот тэг -- закрывающим.
символ: >  закончить-атрибуты  в-тексте ;
строка-кончилась: от-конца-накопленного-текста ;

в-имени-атрибута
на-входе:  отсюда начать-копить ;
все:  копить-дальше ;
разделители:  имя-атрибута запомнить  в-ожидании-знака-равенства-или-следующего-атрибута ;
символ: =  имя-атрибута запомнить  в-ожидании-значения-атрибута ;
символ: >  имя-атрибута запомнить отметить-атрибут  закончить-атрибуты  в-тексте ;
строка-кончилась: от-конца-накопленного-текста ;

в-ожидании-знака-равенства-или-следующего-атрибута
все:  отметить-атрибут вернуть-букву в-имени-атрибута ;
символ: =  имя-атрибута запомнить  в-ожидании-значения-атрибута ;
разделители:  ;
символ: >  закончить-атрибуты  в-тексте ;
строка-кончилась:  отметить-атрибут ;

в-ожидании-значения-атрибута
все:  вернуть-букву в-значении-атрибута ;
разделители:  ;
символ: '  в-значении-атрибута-в-апострофах ;
символ: "  в-значении-атрибута-в-кавычках ;
символ: >  отметить-атрибут  закончить-атрибуты  в-тексте ;
строка-кончилась: от-конца-накопленного-текста ;

: запомнить-и-внести-атрибут  значение-атрибута запомнить  значение-атрибута 2@ имя-атрибута 2@ внести-атрибут ;

в-значении-атрибута
на-входе:  отсюда начать-копить ;
все:  копить-дальше ;
разделители:  запомнить-и-внести-атрибут в-ожидании-имени-атрибута ;
символ: >  запомнить-и-внести-атрибут  закончить-атрибуты  в-тексте ;
строка-кончилась:  запомнить-и-внести-атрибут ;

в-значении-атрибута-в-апострофах
на-входе:  отсюда размер-символа - начать-копить  копить-дальше ;
все:  копить-дальше ;
символ: '  копить-дальше запомнить-и-внести-атрибут  в-ожидании-имени-атрибута ;

в-значении-атрибута-в-кавычках
на-входе:  отсюда размер-символа - начать-копить  копить-дальше ;
все:  копить-дальше ;
символ: "  копить-дальше запомнить-и-внести-атрибут  в-ожидании-имени-атрибута ;

: убрать-кавычки ( addr u -- addr u )
DUP 0= IF EXIT THEN
OVER C@ DUP [CHAR] ' = SWAP [CHAR] " = OR
IF SWAP размер-символа + SWAP размер-символа 2* - THEN ;

\EOF
:NONAME CR ." <" TYPE SPACE ; TO открыть-тэг
:NONAME ."  >" ; TO закончить-атрибуты
:NONAME CR ." <\" TYPE ." >" ; TO закрыть-тэг
:NONAME ?DUP IF CR TYPE ELSE DROP THEN ; TO внести-текст
:NONAME CR ." <!" TYPE ." >" ; TO внести-комментарий
:NONAME CR TYPE ." =" убрать-кавычки TYPE ; TO внести-атрибут

REQUIRE ZPLACE ~nn/lib/az.f

CREATE tmp 100 ALLOT
S" <html id='ma"  tmp +ZPLACE
S" in '    	><!-- df d>r--></html>" tmp +ZPLACE

: r 1 TO размер-символа SWAP поставить-курсор в-тексте -символов-обработать ;
tmp ASCIIZ> r