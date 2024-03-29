
SP-Forth
========

<title>SP-Forth</title>

<!-- Revision: 2023-02-27 -->

ОПИСАНИЕ
--------

SP-Forth это надёжная и удобная форт система генерирующая оптимизированный
машинный(native) код для процессоров Intel x86. Работает на Windows 9x, NT и Linux.

SP-Forth является свободным программным обеспечением. См. раздел [ЛИЦЕНЗИЯ](#license)

Мы распространяем данную программу в надежде на то, что она будет вам полезной,
однако НЕ ПРЕДОСТАВЛЯЕМ НА НЕЕ НИКАКИХ ГАРАНТИЙ, в том числе ГАРАНТИИ ТОВАРНОГО
СОСТОЯНИЯ ПРИ ПРОДАЖЕ и ПРИГОДНОСТИ ДЛЯ ИСПОЛЬЗОВАНИЯ В КОНКРЕТНЫХ ЦЕЛЯХ.


УСТАНОВКА (Windows)
-------------------

SP-Forth (SPF) для Windows распространяется как архив или как
самоустанавливающийся исполняемый файл.

Если у вас обычный инсталлятор - просто запустите его. Мастер
настройки проведёт вас через установочный процесс.

Если вы устанавливаете из архива - распакуйте его в желаемый каталог. Всё,
теперь SPF готов к использованию. Если же вы хотите ассоциировать `*.f` и `*.spf`
файлы с `spf4.exe` - запустите `docs/install/install.bat`, который покажет GUI
окошко для настройки реестра. Или вы можете вручную отредактировать файл
`docs/install/spf_path_install.reg` (укажите правильный путь к `spf4.exe`) и
запустить его. Теперь вы можете писать свой код, сохранить его в `*.f` файл и
запускать на исполнение двойным кликом мышью.


УСТАНОВКА (Linux)
-----------------

SP-Forth для Linux распространяется в виде  архива  или  бинарных  пакетов  для
конкретных дистрибутивов (на текущий момент только Debian).

После распаковки архива с исходниками выполните `make -C src install` и создайте 
символическую ссылку на полученный бинарник `spf4` где-нибудь в PATH, чтобы SPF 
мог найти `lib` и `devel`. Во время сборки потребуется gcc для
компиляции `src/posix/consts.c` чтобы сгенерировать форт код с платформенно-зависимыми 
значениями системных констант. Также во время сборки используется spf4orig в качестве целевого
компилятора, использовать его для чего-либо другого не стоит.

SPF из бинарного пакета рапределяет оригинальное дерево исходников по нескольким каталогам, в
соответствии с правилами дистрибутива (`/usr/bin`, `/usr/lib` и `/usr/share`).
Исходный код пропатчен чтобы корректно находить `lib`  и  `devel` и при старте
подключать `~/.spf4.ini`.

CONTENTS
--------

Смотрите файл [/docs/whatsnew.ru.txt](whatsnew.ru.txt) с кратким описанием последних изменений.

Каталоги (от корня установки) :

* `/devel`   - дополнительные библиотеки и примеры
* `/docs`    - документация
* `/lib`     - стандартные библиотеки, ANS и не-ANS расширения такие как `float.f`, `locals.f` ...
* `/samples` - отлаженные GUI и консольные примеры.
* `/src`     - полные исходники с комментариями и скриптом для сборки

Файлы в корневом каталоге:

* `help.fhlp`        - подключается по умолчанию расширением `lib/ext/help.f`
* `jpf375c.exe`      - более старая версия СПФ для пересборки
* `spf4.exe`         - SPF ;)
* `spf4.ini`         - этот файл автоматически подключается SPF'ом при старте (если есть)


ДОКУМЕНТАЦИЯ
------------

Смотрите каталог `/docs`. Большинство документации на русском языке.

1.  [Особенности SPF](intro.ru.md) ([online html](https://spf.sourceforge.net/docs/intro.en.html))

    Если вы уже знакомы с Фортом, но не знакомы с SPF

2.  [Краткий список библиотек](devel.ru.md) ([online html](https://spf.sourceforge.net/docs/devel.en.html))

    Описание дополнительных библиотек из поставки SPF

3.  [~yz](../devel/~yz/index.html)

    Документация к [библиотекам](../devel/~yz/lib.html) Юрия Жиловца.

    В том числе к [WinLib](../devel/~yz/winlib.html)

4.  [HYPE 3](../devel/~day/hype3/reference.pdf)

    Библиотека поддержки парадигмы ООП от Дмитрия Якимова.

    Руководство пользователя.

5.  [SP-Forth SDK](papers/spf_help.chm)

    для SPF/3.70 2002 года.


Расширение SPF (`lib/ext/help.f`) добавляет встроенную помощь в интерпретатор
(слово `HELP`).

Если этой документации недостаточно, задавайте вопросы в
[Issue tracker](https://github.com/rufig/spf/issues).


РАЗРАБОТКА
----------

*   Последнюю версию всегда можно найти на GitHub

    <https://github.com/rufig/spf/releases>

    Исходоники доступны в Git репозитории.
    URI для клонирования репозитория с доступом только для чтения
    `https://github.com/rufig/spf.git`

    Подписка на уведомления о коммитах доступна на
    [стринице проекта](https://github.com/rufig/spf)

*   Контакт с разработчиками через [Issue tracker](https://github.com/rufig/spf/issues)
    Или через Telegram группу <https://t.me/spforthchat>.

*   Багтрекер (пожелания и багрепорты)

    <https://github.com/rufig/spf/issues>

    Пожалуйста приводите подробное описание ошибки и способ воспроизведения.
    Обязательно сообщайте о неточностях или неполноте документации.

    Уведомления об активности на багтрекере доступны через платформу GitHub.

*   Некоторые прошлые проекты с использованием SP-Forth:

    <http://www.eserv.ru>         - HTTP/FTP/SMTP/POP3/IMAP сервер и прокси для Win32

    <http://nncron.ru>            - unix-подобный планировщик cron для Windows с поддержкой скриптов

    <http://forth-script.sf.net>  - SP-Forth как CGI

    <http://acweb.sf.net>         - http сервер для Win32

    <http://acfreeproxy.sf.net>   - http прокси сервер

    <http://acftp.sf.net>         - ftp сервер

*   Русское Форт-сообщество, разделенное на три части:

    <https://t.me/ruforth> (Telegram chat)

    <http://fforum.winglion.ru> (Web forum)

    <http://www.forth.org.ru> (старый веб-сайт)




ЛИЦЕНЗИЯ <a id="license"/>
--------

Вы вправе распространять и/или модифицировать ядро SP-Forth (т.е. все файлы из `src`) в соответствии с
условиями [GNU GPL](http://www.fsf.org/licensing/licenses/gpl.html), опубликованной
[Free Software Foundation](http://www.fsf.org).
Все остальные файлы, включая код из `devel`, по умолчанию лицензированы под
[GNU LGPL](http://www.fsf.org/licensing/licenses/lgpl.html), если не указано что-либо другое.

Коротко говоря это значит следующее :

*    Вы не имеете права модифицировать и распространять результат модификации ядра SPF не предоставляя при этом исходные коды.

*    Вы можете компилировать оригинальным SPF'ом и распространять закрытое ПО.

*    Вы можете использовать оригинальный код из `devel` вместо со своим собственным кодом для создания закрытого ПО.

*    Вы обязаны поделиться с сообществом модификациями к оригинальному коду из `devel` если вы использовали результат этих модификаций
     для создания закрытого ПО, при этом свой собственный код вы раскрывать не обязаны.

АВТОРЫ
------

Русское Форт сообщество и многие добровольцы.

Начат Андреем Черезовым в 1992


----
Последнее обновление: 2023-02-27
