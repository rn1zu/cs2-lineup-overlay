#Requires AutoHotkey v2.0
#SingleInstance Force
A_MenuMaskKey := "vkE8"    ; Mask Win key so Game Bar doesn't open

; Overlay settings
OverlayAlpha := 180        ; Transparency (0-255)
OverlayX_Offset := 0       ; X offset from center
OverlayY_Offset := 0       ; Y offset from center
ImageFile := "lineup.png"  ; Image file name

; Get screen resolution
ScreenW := A_ScreenWidth
ScreenH := A_ScreenHeight

; Create the window
MyGui := Gui()
MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow +LastFound +E0x80020")
MyGui.MarginX := 0
MyGui.MarginY := 0
MyGui.BackColor := "000000"
MyGui.Add("Picture", "x0 y0 w" ScreenW " h" ScreenH " BackgroundTrans", ImageFile)

; Transparency and click-through
WinSetTransColor("000000 " OverlayAlpha, MyGui)
WinSetExStyle("+0x20", MyGui)

; Show and immediately hide
MyGui.Show("x" (ScreenW/2 - (ScreenW/2) + OverlayX_Offset) " y" (ScreenH/2 - (ScreenH/2) + OverlayY_Offset) " w" ScreenW " h" ScreenH " NoActivate")
WinHide("ahk_id " MyGui.Hwnd)

; --- Hotkeys ---
; Show overlay when mouse5 is held
XButton2:: {
    WinShow("ahk_id " MyGui.Hwnd)
}
; Hide when released
XButton2 Up:: {
    try {
        WinHide("ahk_id " MyGui.Hwnd)
    }
    ; If the window is not found, do nothing and don't show an error
}

; Minimize game with a single Win key press (if held, works as a modifier)
LWin:: {
    if KeyWait("LWin", "T0.25")
        WinMinimize("A")
}

; Emergency exit with F12
F12::ExitApp
