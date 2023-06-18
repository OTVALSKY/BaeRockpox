#SingleInstance Force
#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 2
Persistent
SetWorkingDir A_WorkingDir
FileDelete "*.file" ;clear temp file
;this code is a mess, don't try to understand anything :(
    ;-----------begin Initialize Hotkeys-------------;

global GHotKey1 := "XButton1" 
global GHotKey2 := "XButton2" 
global ChosenHotKey := "f12" ;f12 is placeholder

Hotkey GHotKey1, Do  
Hotkey GHotKey2, Do  
Hotkey ChosenHotKey, Do  

HotKey GHotKey1, "off"
HotKey ChosenHotKey, "off"
    ;-----------End Initialize Hotkeys-------------;

    ;-----------Begin Initialize Tray-------------;
Tray := A_TrayMenu ;call tray menu
Tray.Delete ;Set up tray menu
A_TrayMenu.Add("Bye Rockpox! By Otvalsky", c)
tray.Disable("Bye Rockpox! By Otvalsky") ;;Credits!
tray.add ; separator
tray.add "Use Mouse Button 4", Toggle1
tray.add "Use Mouse Button 5", Toggle2
tray.add "Map Custom Button", Custom
tray.add ; separator
tray.add "Exit App", Q
tray.ToggleCheck "Use Mouse Button 5" ;default value is XMB2
TraySetIcon "Shell32.dll", 42
    ;-----------End Initialize Tray-------------;

Q(*) ;handle app exit
{
    ExitApp
}
c(*) ;dummy for creds
{
    ExitApp
}

Toggle1(*)
{
    tray.ToggleCheck "Use Mouse Button 4"
    tray.Uncheck("Map Custom Button")
    tray.Uncheck("Use Mouse Button 5")


    Hotkey GHotKey1, "on"
    Hotkey GHotKey2, "off"
    Hotkey ChosenHotKey, "off"
     
}

Toggle2(*)
{
    tray.ToggleCheck "Use Mouse Button 5"
    tray.Uncheck("Map Custom Button")
    tray.Uncheck("Use Mouse Button 4")

    Hotkey GHotKey2, "on"
    Hotkey GHotKey1, "off"
    Hotkey ChosenHotKey, "off"
}

Custom(*) ;if user decides to assign different hotkey
{
    global 
    tray.ToggleCheck "Map Custom Button"
    tray.Uncheck("Use Mouse Button 4")
    tray.Uncheck("Use Mouse Button 5")
    myGui := gui()
    myGui.Opt(" -MaximizeBox -Resize -ToolWindow -SysMenu")
    myGui.OnEvent("Escape", (*) => WinHide())


    AttributeString := FileExist("temp.file")
    if AttributeString != "" ;If we assigned hotkey before, show it in GUI for user to know
    {
        Temp := FileRead('temp.file')
        MyHotKey := MyGui.Add("Hotkey", "vChosenHotkey", Temp)
        MyGui.Add("Button", "w44 Default", "Ok").OnEvent("Click", BtnOkClick)

    }
    else {       ;otherwise just let user assign hotkey \\ effective til script restart
        MyHotKey := MyGui.Add("Hotkey", "vChosenHotkey")
        MyGui.Add("Button", "w44 Default", "Ok").OnEvent("Click", BtnOkClick)
    }

    MyGui.Title := "Set Custom Key Bind"
    mygui.Show("AutoSize Center") ;show gui

    BtnOkClick(*)
    {
        
       ChosenHotKey := MyHotKey.Value
        FileDelete "*.file" ;create temp file, insert new value
        FileAppend ChosenHotKey, 'temp.file' ;remember hotkey
        Hotkey ChosenHotKey, Do ;trigger stuff when we press it
    
        Hotkey GHotKey2, "off"
        Hotkey GHotKey1, "off"
        Hotkey ChosenHotKey, "On"

        myGui.Hide ; hide gui on ok click

    }
}

#Hotif WinActive(":FSD-Win64-Shipping.exe") ;detect DRG window and check if active
{
    Do(GHotKey)
    { 
         ;Our button!, XMB2 by default
        state := GetKeyState(GHotKey, "P")
        While state = 1  ; While true
        { ;mash buttons like crazy
            send "{a Down}"
            sleep 5
            send "{a Up}"
            sleep 20
            send "{d Down}"
            sleep 5
            send "{d Up}"
            state := GetKeyState(GHotKey, "P")
            if state = 0
                break ;stop mashing when key is released
        }
    }

}
