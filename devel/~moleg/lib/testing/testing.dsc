\ 2006-12-09 ~mOleg
\ вынес сюда из исходника
comment:                     ДЛЯ ЧЕГО ЭТО НАДО

     Я   предлагаю   в   каждую   библиотечку   вставлять   код  для
 автоматической  проверки  ее работоспособности. Таким образом можно
 автоматически  проверять работоспособность всех библиотек, входящих
 в  дистрибутив  СПФа,  да  и  самого  СПФа. Соответственно придется
 написать скрипт, который будет перебирать все либы в .\devel\~??? и
 автоматически  их  подключать.  Ошибка  же себя сразу покажет 8). К
 тому   же  данный  подход  можно  использовать  для  автоматической
 генерации  версий  кода,  различных  алгоритмов.  Ну и много других
 применений можно найти.

     Место  в  котором  будет  проводиться  тестирование,  а  так же
 состояние переменной state не влияет на работоспособность процесса.
 То  есть  можно  вставлять пары tеst: ;tеst и внутрь определений, а
 можно  использовать  отдельно  для  работы  в режиме интерпретации.
 Вложение  пар tеst: ;tеst не предусматривается так как в отличие от
 СМАЛ32  у  слов  нет  признака immediatest, но пары tеst wоrk могут
 чередоваться и быть вложенными друг в друга.


 16-10-2006. добавилась поддержка коментариев в стиле СМАЛ32.
             Собственно сейчас вы читаете секцию коментария.
 17-10-2006. добавились секции rus: ;rus eng: ;eng текст из этих
             секций будет интерпретироваться лишь в случае, если
             в контексте будет найдено слово russian или слово
             english. Соответственно, наличие обоих ключевых слов
             приведет к интерпретации кода из двух этих секций.
 27-04-2007. изменил слово iNextWord и его код на NEXT-WORD.
comment;
