#Requires AutoHotkey v2.0
#SingleInstance Force
A_MenuMaskKey := "vkE8"    ; маскировка Win, чтобы не открывался Game Bar

; Настройки оверлея
OverlayAlpha := 180        ; Прозрачность (0-255)
OverlayX_Offset := 0       ; Смещение по X от центра
OverlayY_Offset := 0       ; Смещение по Y от центра
ImageFile := "lineup.png"  ; Имя файла с картинкой

; Получаем разрешение экрана
ScreenW := A_ScreenWidth
ScreenH := A_ScreenHeight

; Создаём окно
MyGui := Gui()
MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow +LastFound +E0x80020")
MyGui.MarginX := 0
MyGui.MarginY := 0
MyGui.BackColor := "000000"
MyGui.Add("Picture", "x0 y0 w" ScreenW " h" ScreenH " BackgroundTrans", ImageFile)

; Прозрачность и клик-сквозность
WinSetTransColor("000000 " OverlayAlpha, MyGui)
WinSetExStyle("+0x20", MyGui)

; Показываем и сразу скрываем
MyGui.Show("x" (ScreenW/2 - (ScreenW/2) + OverlayX_Offset) " y" (ScreenH/2 - (ScreenH/2) + OverlayY_Offset) " w" ScreenW " h" ScreenH " NoActivate")
WinHide("ahk_id " MyGui.Hwnd)

; --- Горячие клавиши ---
; Показ оверлея при зажатии mouse5
XButton2:: {
    WinShow("ahk_id " MyGui.Hwnd)
}
; Скрытие при отпускании
XButton2 Up:: {
    WinHide("ahk_id " MyGui.Hwnd)
}

; Сворачивание игры по одиночному нажатию Win (если зажать — работает как модификатор)
LWin:: {
    if KeyWait("LWin", "T0.25")
        WinMinimize("A")
}

; Аварийный выход по F12
F12::ExitApp