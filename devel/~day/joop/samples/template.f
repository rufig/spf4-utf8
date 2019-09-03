\ Заготовка для простого Windows приложения.
\ То есть практически любое ваше gui приложение должно
\ начинаться с этой заготовки

REQUIRE FrameWindow ~day\joop\win\framewindow.f
REQUIRE Button ~day\joop\win\control.f
REQUIRE Font ~day\joop\win\font.f
\ REQUIRE OpenDialog ~day\joop\win\filedialogs.f
REQUIRE MENUITEM ~day\joop\win\menu.f


CLASS: AppWindow <SUPER FrameWindow

        \ Здесь можно описать кнопочки, типа Button OBJ MyButton
        
: :createPopup ( -- hMenu)
   0 \ Вместо 0 вставьте текст-описание всплывающего меню 
;
        
: :createMenu
   0 \ аналогично, но для меню приложения
;

: :init
   own :init
   \ Здесь действия перед созданием окна ф-ей CreateWindowEx
;

: :create
  \ Здесь действия перед созданием окна ф-ей CreateWindowEx
  own :create
  \ Здесь создание и инициализация кнопочек etc
;

;CLASS


: RUN { \ w }
   AppWindow :new -> w
   0 w :create
   S" Здесь ваш caption" w :setText
   100 50 200 160 w :move
   w :show
   w :run 
   w :free
   BYE
;

HERE IMAGE-BASE - 10000 + TO IMAGE-SIZE \ Вместо 10000 свое значение
' RUN MAINX !
TRUE TO ?GUI
S" yourapp.exe" SAVE BYE
