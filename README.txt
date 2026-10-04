================================================================================
README: EXTERNAL CROSSHAIR OVERLAY FOR CS2 (LINE-UP)
================================================================================

================================================================================
PURPOSE
================================================================================

After the CS2 "Rush Hour" update (September 2026), the maximum crosshair line
length (cl_crosshair_length) is capped at 255 pixels. That is not enough for
precise line-ups.

This README explains how to create and use an external overlay — a transparent
image with long lines that appears on top of the game when you hold a side
mouse button (mouse5).

The overlay does NOT inject into the game process, does NOT read its memory,
and does NOT modify any game files. It is drawn by Windows itself via
AutoHotkey.

; IMPORTANT: Use in competitive matchmaking is at your own risk.
; Do NOT use this overlay in tournaments where third-party software
; is prohibited.

================================================================================
REQUIREMENTS
================================================================================

; 1. Windows 10/11

; 2. AutoHotkey v2 — download from the official website:
;    https://www.autohotkey.com/

; 3. Adobe Photoshop (or any editor that supports PNG and transparency)

; 4. CS2 running in "Windowed Fullscreen" (Borderless) mode.

;    IMPORTANT: In "Full Screen" mode the overlay will NOT work.

================================================================================
STEP 1. PREPARING THE CROSSHAIR IMAGE IN PHOTOSHOP
================================================================================

1.1. Create a new document:

;      Width:             1920 px
;      Height:            1080 px
;      Resolution:        72 ppi
;      Color mode:        RGB, 8 bit
;      Background:        Transparent

;    IMPORTANT: Always choose "Transparent" background. If you pick "White",
;    the overlay will cover your entire screen with a white square.

1.2. Add guides:

;      View -> New Guide
;        Vertical:   960 px
;        Horizontal: 540 px

1.3. Draw the lines with the Rectangle tool (press U).

;    Line parameters:

;      Thickness: same as cl_crosshairthickness in CS2 (e.g. 2 px).
;                 Note that a stroke adds 1 px on each side, so the final
;                 visible thickness will be larger. You may skip the stroke,
;                 but then the lines will be less visible on light backgrounds.

;      Color:     use the RGB values from CS2.
;                 For example, #4F00FF (R=79, G=0, B=255).

;    Vertical bars:

;      Left:   X = 959, Y = 0, W = 1, H = 1080
;      Right:  X = 960, Y = 0, W = 1, H = 1080

;    Horizontal bars (if you want a full cross):

;      Top:    X = 0, Y = 539, W = 1920, H = 1
;      Bottom: X = 0, Y = 540, W = 1920, H = 1

;    Gap: in CS2 you can set cl_crosshairgap to 0 so the lines meet.
;         If you want a gap, shift the bars by 1-2 pixels.

;    IMPORTANT: To make the bars perfectly even, enter the coordinates
;    through the Properties panel (X, Y, W, H) instead of drawing by hand.

1.4. Make sure the background layer is hidden (the eye icon is off).

1.5. Save the file:

;      File -> Export -> Export As...

;        Format:     PNG
;        "Transparency" checkbox — REQUIRED
;        File name:  lineup.png

;      Save it to the folder where the script will live
;      (for example, C:\CrosshairOverlay\).

;    IMPORTANT: Do NOT save as JPG — it does not support transparency,
;    and a dark or white rectangle will appear around the crosshair in game.

================================================================================
STEP 2. INSTALLING AUTOHOTKEY V2
================================================================================

2.1. Download the v2.0 installer from the official site autohotkey.com.

2.2. Run the installer. Windows will show a SmartScreen warning —
;    click "More info" -> "Run anyway".

;    This is a standard warning for any new program. It does not mean
;    the file contains a virus.

2.3. Install to any folder. Disk D is fine — it does not affect operation.

2.4. After installation, close the AutoHotkey Dash window.

================================================================================
STEP 3. CREATING THE SCRIPT
================================================================================

3.1. In the folder with lineup.png, create a new text file.

3.2. Open it and paste the following code:

--------------------------------------------------------------------------------
#Requires AutoHotkey v2.0
#SingleInstance Force
A_MenuMaskKey := "vkE8"    ; mask Win so Game Bar doesn't open

; Overlay settings
OverlayAlpha := 180        ; Opacity (0-255)
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

; Show, then hide immediately
MyGui.Show("x" (ScreenW/2 - (ScreenW/2) + OverlayX_Offset) " y" (ScreenH/2 - (ScreenH/2) + OverlayY_Offset) " w" ScreenW " h" ScreenH " NoActivate")
WinHide("ahk_id " MyGui.Hwnd)

; --- Hotkeys ---
; Show overlay while mouse5 is held
XButton2:: {
    WinShow("ahk_id " MyGui.Hwnd)
}
; Hide on release
XButton2 Up:: {
    try {
        WinHide("ahk_id " MyGui.Hwnd)
    }
    ; If the window is not found, do nothing and don't show an error
}

; Minimize the game on a single Win press (hold = modifier)
LWin:: {
    if KeyWait("LWin", "T0.25")
        WinMinimize("A")
}

; Emergency exit on F12
F12::ExitApp
--------------------------------------------------------------------------------

3.3. Save the file as lineup_overlay.ahk (extension MUST be .ahk, not .txt).

;    If Windows hides extensions, enable them in Explorer:
;    View -> Show -> File name extensions.

;    IMPORTANT: If the file is saved as lineup_overlay.ahk.txt, the script
;    will not run. Check the extension.

================================================================================
HOW TO CHANGE THE OVERLAY ACTIVATION BUTTON
================================================================================

By default the overlay is bound to mouse5 (XButton2). To use a different
button, find these two lines in the code:

;   XButton2:: {
;       WinShow("ahk_id " MyGui.Hwnd)
;   }
;   XButton2 Up:: {
;       WinHide("ahk_id " MyGui.Hwnd)
;   }

And replace XButton2 IN BOTH LINES with a value from the table below.

================================================================================
POPULAR BUTTON NAMES IN AUTOHOTKEY V2
================================================================================

; Button                                      Name in script
; -----------------------------------------   -----------------
; Mouse4 (side button, closer to thumb)       XButton1
; Mouse5 (side button, farther)               XButton2
; Middle mouse button                         MButton
; Left mouse button                           LButton
; Right mouse button                          RButton
; Mouse wheel up                              WheelUp
; Mouse wheel down                            WheelDown
; Mouse wheel left                            WheelLeft
; Mouse wheel right                           WheelRight
; Key F                                       f
; Key Space                                   Space
; Key V                                       v
; Key H                                       h
; Key CapsLock                                CapsLock
; Keys F1 - F12                               F1 ... F12
; Key Tab                                     Tab
; Left Alt                                    LAlt
; Left Ctrl                                   LCtrl
; Left Shift                                  LShift

================================================================================
EXAMPLE: REBINDING TO MOUSE4
================================================================================

Replace the hotkey block with:

;   XButton1:: {
;       WinShow("ahk_id " MyGui.Hwnd)
;   }
;   XButton1 Up:: {
;       WinHide("ahk_id " MyGui.Hwnd)
;   }

After editing, save the file and click Reload Script via the H tray icon.

================================================================================
IMPORTANT WHEN CHOOSING A BUTTON
================================================================================

; - Do not bind to keys already used in CS2 (fire, jump, crouch, grenades,
;   voice) — otherwise there will be a conflict.

; - If you use a keyboard key, make sure nothing is bound to it in game.
;   You can check in the console: bind h will show what is currently
;   bound to the key.

; - The pair "X::" and "X Up::" is REQUIRED. If you leave only the first
;   one, the overlay will turn on and never turn off.

================================================================================
STEP 4. CREATING THE .BAT TOGGLE (ON/OFF WITH ONE CLICK)
================================================================================

To avoid digging through folders and double-clicking, create a .bat file
that turns the overlay on and off with a single launch.

4.1. On your Desktop, create a text file and paste:

--------------------------------------------------------------------------------
@echo off
title Crosshair Overlay Toggle

tasklist /FI "IMAGENAME eq AutoHotkey64.exe" 2>NUL | find /I "AutoHotkey64.exe" >NUL
if "%ERRORLEVEL%"=="0" goto kill
tasklist /FI "IMAGENAME eq AutoHotkey32.exe" 2>NUL | find /I "AutoHotkey32.exe" >NUL
if "%ERRORLEVEL%"=="0" goto kill
goto start

:kill
taskkill /IM AutoHotkey64.exe /F >NUL 2>&1
taskkill /IM AutoHotkey32.exe /F >NUL 2>&1
echo Overlay OFF
timeout /t 1 >NUL
exit

:start
start "" "%~dp0lineup_overlay.ahk"
echo Overlay ON
timeout /t 1 >NUL
--------------------------------------------------------------------------------

4.2. IMPORTANT about the path:

;    The line start "" "%~dp0lineup_overlay.ahk" uses a relative path.
;    %~dp0 means "the folder where this .bat file is located".

;    This means the .bat file and lineup_overlay.ahk MUST be in the SAME
;    folder. If you move the .bat to the Desktop, it will not find the
;    script.

;    If you want the .bat file to be somewhere else, replace the path with
;    a full absolute path, for example:

;      start "" "C:\CrosshairOverlay\lineup_overlay.ahk"

;    NOTE: The path MUST be in double quotes. If the path contains spaces,
;    the .bat file will not work without quotes.

4.3. Save the file and rename it to Crosshair.bat (remove .txt, add .bat).

;    If Windows will not let you rename, enable file extensions first.

4.4. Confirm the "File may be unsafe..." warning — click "Yes".

Now just double-click Crosshair.bat:

; - If the overlay is OFF — it will start (H icon appears in the tray).
; - If the overlay is ON — it will stop (H icon disappears).

================================================================================
HOTKEY FOR THE .BAT FILE (OPTIONAL)
================================================================================

; 1. Right-click Crosshair.bat ->
;    "Send to" -> "Desktop (create shortcut)".

; 2. On the shortcut: right-click -> "Properties" ->
;    "Shortcut key" field -> press the desired combination
;    (for example, Ctrl + Alt + X).

; 3. Click "OK". Now you can toggle the overlay from the keyboard.

================================================================================
STEP 5. MANAGING THE SCRIPT
================================================================================

; - Start: double-click lineup_overlay.ahk.
;   A green H icon appears in the tray.
;   If you don't see it, click the ^ arrow near the clock to expand
;   hidden icons.

; - Reload after edits: right-click the H icon -> Reload Script.

; - Stop: right-click the H icon -> Exit.
;   Or use the .bat toggle, or the taskkill commands (see Step 6).

; IMPORTANT: If you shut down or restart your PC, the script will NOT
; auto-start. You must launch lineup_overlay.ahk manually (or via
; Crosshair.bat) before starting CS2 each time.

================================================================================
STEP 6. MANAGING THE PROCESS VIA CONSOLE (TASKKILL)
================================================================================

To force-close the script, open Command Prompt (Win + R -> cmd) and run
one of these commands:

;   taskkill /IM AutoHotkey.exe /F
;   taskkill /IM AutoHotkey64.exe /F
;   taskkill /IM AutoHotkey32.exe /F

; - If the process is not found — that's normal; the script is already off.
; - In AutoHotkey v2 the process is usually AutoHotkey64.exe
;   (on 64-bit systems).
; - These commands contain no username and can be copied as-is.

================================================================================
STEP 7. USING IN CS2
================================================================================

; 1. Launch CS2.

; 2. In video settings, choose "Windowed Fullscreen" mode.

;    IMPORTANT: In "Full Screen" mode the overlay will not be visible.
;    This is a Windows limitation, not a script bug.

; 3. Hold mouse5 — the lines will appear on top of the game.
;    Release — they disappear.

; 4. To minimize the game, press Win once (single press).
;    If you hold Win and press another key, the system combination
;    will trigger instead.

================================================================================
SCRIPT SETTINGS (FOR FINE-TUNING)
================================================================================

At the top of lineup_overlay.ahk you can change:

; OverlayAlpha  - opacity (0 = fully transparent,
;                 255 = opaque). Optimal range is 150-200.

; OverlayX_Offset, OverlayY_Offset
;               - overlay offset from screen center in pixels.
;                 Default is 0.

; ImageFile     - image file name, if you named it differently.

After editing, save the file and click Reload Script via the H tray icon.

================================================================================
SECURITY AND VAC
================================================================================

; - The overlay does NOT inject into the game, does NOT read memory,
;   does NOT modify files. It only uses standard Windows features
;   (a transparent window).

; - VAC does not ban for external overlays that do not provide an unfair
;   advantage (e.g. do not show enemies through walls).

; - Use in competitive matchmaking is at your own risk.

; - Do NOT use this overlay in tournaments where third-party software
;   is prohibited.

; - Do not run .ahk scripts from untrusted sources. Download AutoHotkey
;   only from the official site autohotkey.com.

================================================================================
BONUS: CHANGING CROSSHAIR COLORS IN GAME (CHCOLOR.CFG)
================================================================================

If you want to quickly change crosshair colors in CS2 via the console,
you can use a config with aliases. Example:

--------------------------------------------------------------------------------
// chcolor.cfg
alias "chc0"  "cl_crosshaircolor 5; cl_crosshaircolor_r 250; cl_crosshaircolor_g 50;  cl_crosshaircolor_b 50;  echo crosshair: 0 red"
alias "chc1"  "cl_crosshaircolor 5; cl_crosshaircolor_r 50;  cl_crosshaircolor_g 250; cl_crosshaircolor_b 50;  echo crosshair: 1 green"
// ... and so on
alias "chc_next" "chc_c0"
alias "chc_c0"  "cl_crosshaircolor 5; chc0;  alias chc_next chc_c1"
// ... full cycle
bind "h" "chc_next"
--------------------------------------------------------------------------------

; - Custom colors require cl_crosshaircolor 5.
; - Save the file as chcolor.cfg (not .txt).
; - In console: exec chcolor.
; - The H key will cycle through the colors.

; IMPORTANT: Aliases in CS2 now only work when loaded via autoexec at
; game start or manually in the console. Loading them via exec during
; a match no longer works.

================================================================================
LICENSE AND COPYRIGHT
================================================================================

This README and script are provided "as is" for personal use.
You are free to distribute and modify them.
