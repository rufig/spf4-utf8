\ 15-01-2007 ~moleg

     Загружаем либу,
     запускаем нужный нам процесс
     отчет выводится на экран, и в spf.log
     смотрим в spf.log

     При  входе в двоеточное определение, будет выводиться сообщение
 после  которых  пойдет распечатка стека, при выходе из определения,
 будет выводиться символ ». ( если будет много выводов подряд, то на
 одной строке будет много ».
     Каждое  следующее вложенное определение будет находиться дальше
 на  один  пробел  от  начала строки. Понятно, что, если будет очень
 много уровней вложений, то все выйдет за пределы экрана.

     При  всей  простоте  примера, данный подход может сильно помочь
 найти  проблемное  место.  Не стоит использовать данную методику на
 словах,  содержащих  #  #  не  обрамленные  <# .. #> TYPE - так как
 распечатка  стека использует буффер PAD, а так же в словах напрямую
 работающих со стеком возвратов (если такие определения не соблюдают
 баланса  стека  возвратов  на  входе и выходе.) Вроде все, но могут
 быть еще некоторые нюансы, которые в голову сразу не пришли.
