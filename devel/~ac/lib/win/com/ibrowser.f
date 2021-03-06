\ Управление встроенным браузером. Примеры см. в ~ac/lib/win/window/browser.f

REQUIRE CLSID,  ~ac/lib/win/com/com.f

IID_IDispatch
Interface: IID_IWebBrowser2 {D30C1661-CDAF-11D0-8A3E-00C04FC9E26E}
  Method: ::GoBack ( This)
  Method: ::GoForward ( This)
  Method: ::GoHome ( This)
  Method: ::GoSearch ( This)
  Method: ::Navigate ( This,URL,Flags,TargetFrameName,PostData,Headers)
  Method: ::Refresh ( This)
  Method: ::Refresh2 ( This,Level)
  Method: ::Stop ( This)
  Method: ::get_Application ( This,ppDisp)
  Method: ::get_Parent ( This,ppDisp)
  Method: ::get_Container ( This,ppDisp)
  Method: ::get_Document ( This,ppDisp)
  Method: ::get_TopLevelContainer ( This,pBool)
  Method: ::get_Type ( This,Type)
  Method: ::get_Left ( This,pl)
  Method: ::put_Left ( This,Left)
  Method: ::get_Top ( This,pl)
  Method: ::put_Top ( This,Top)
  Method: ::get_Width ( This,pl)
  Method: ::put_Width ( This,Width)
  Method: ::get_Height ( This,pl)
  Method: ::put_Height ( This,Height)
  Method: ::get_LocationName ( This,LocationName)
  Method: ::get_LocationURL ( This,LocationURL)
  Method: ::get_Busy ( This,pBool)
  Method: ::Quit ( This)
  Method: ::ClientToWindow ( This,pcx,pcy)
  Method: ::PutProperty ( This,Property,vtValue)
  Method: ::GetProperty ( This,Property,pvtValue)
  Method: ::get_Name ( This,Name)
  Method: ::get_HWND ( This,pHWND)
  Method: ::get_FullName ( This,FullName)
  Method: ::get_Path ( This,Path)
  Method: ::get_Visible ( This,pBool)
  Method: ::put_Visible ( This,Value)
  Method: ::get_StatusBar ( This,pBool)
  Method: ::put_StatusBar ( This,Value)
  Method: ::get_StatusText ( This,StatusText)
  Method: ::put_StatusText ( This,StatusText)
  Method: ::get_ToolBar ( This,Value)
  Method: ::put_ToolBar ( This,Value)
  Method: ::get_MenuBar ( This,Value)
  Method: ::put_MenuBar ( This,Value)
  Method: ::get_FullScreen ( This,pbFullScreen)
  Method: ::put_FullScreen ( This,bFullScreen)
  Method: ::Navigate2 ( This,URL,Flags,TargetFrameName,PostData,Headers)
  Method: ::QueryStatusWB ( This,cmdID,pcmdf)
  Method: ::ExecWB ( This,cmdID,cmdexecopt,pvaIn,pvaOut)
  Method: ::ShowBrowserBar ( This,pvaClsid,pvarShow,pvarSize)
  Method: ::get_ReadyState ( This,plReadyState)
  Method: ::get_Offline ( This,pbOffline)
  Method: ::put_Offline ( This,bOffline)
  Method: ::get_Silent ( This,pbSilent)
  Method: ::put_Silent ( This,bSilent)
  Method: ::get_RegisterAsBrowser ( This,pbRegister)
  Method: ::put_RegisterAsBrowser ( This,bRegister)
  Method: ::get_RegisterAsDropTarget ( This,pbRegister)
  Method: ::put_RegisterAsDropTarget ( This,bRegister)
  Method: ::get_TheaterMode ( This,pbRegister)
  Method: ::put_TheaterMode ( This,bRegister)
  Method: ::get_AddressBar ( This,Value)
  Method: ::put_AddressBar ( This,Value)
  Method: ::get_Resizable ( This,Value)
  Method: ::put_Resizable ( This,Value)
Interface;

IID_IUnknown
Interface: IID_IOleInPlaceActiveObject {00000117-0000-0000-C000-000000000046}
\ первые два из IOleWindow
  Method: ::GetWindow ( This,phwnd)
  Method: ::ContextSensitiveHelp ( This,fEnterMode)

  Method: ::TranslateAccelerator ( This,lpmsg) \ единственный способ передать TAB на обработку окну браузера
  Method: ::OnFrameWindowActivate ( This,fActivate)
  Method: ::OnDocWindowActivate ( This,fActivate)
  Method: ::ResizeBorder ( This,prcBorder,pUIWindow,fFrameWindow)
  Method: ::EnableModeless ( This,fEnable)
Interface;
