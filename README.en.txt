================================================================================

README: EXTERNAL CROSSHAIR OVERLAY FOR CS2 (LINE-UP)

================================================================================





================================================================================

PURPOSE

================================================================================



After the CS2 "Rush Hour" update (September 2026), the maximum crosshair line

length (cl\_crosshair\_length) is capped at 255 pixels. That is not enough for

precise line-ups.



This README explains how to create and use an external overlay — a transparent

image with long lines that appears on top of the game when you hold a side

mouse button (mouse5).



The overlay does NOT inject into the game process, does NOT read its memory,

and does NOT modify any game files. It is drawn by Windows itself via

AutoHotkey.



&#x20; IMPORTANT: Use in competitive matchmaking is at your own risk.

&#x20; Do NOT use this overlay in tournaments where third-party software

&#x20; is prohibited.





================================================================================

REQUIREMENTS

================================================================================



&#x20; 1. Windows 10/11



&#x20; 2. AutoHotkey v2 — download from the official website:

&#x20;    https://www.autohotkey.com/



&#x20; 3. Adobe Photoshop (or any editor that supports PNG and transparency)



&#x20; 4. CS2 running in "Windowed Fullscreen" (Borderless) mode.



&#x20;    IMPORTANT: In "Full Screen" mode the overlay will NOT work.





================================================================================

STEP 1. PREPARING THE CROSSHAIR IMAGE IN PHOTOSHOP

================================================================================



1.1. Create a new document:



&#x20;      Width:             1920 px

&#x20;      Height:            1080 px

&#x20;      Resolution:        72 ppi

&#x20;      Color mode:        RGB, 8 bit

&#x20;      Background:        Transparent



&#x20;    IMPORTANT: Always choose "Transparent" background. If you pick "White",

&#x20;    the overlay will cover your entire screen with a white square.





1.2. Add guides:



&#x20;      View -> New Guide

&#x20;        Vertical:   960 px

&#x20;        Horizontal: 540 px





1.3. Draw the lines with the Rectangle tool (press U).



&#x20;    Line parameters:



&#x20;      Thickness: same as cl\_crosshairthickness in CS2 (e.g. 2 px).

&#x20;                 Note that a stroke adds 1 px on each side, so the final

&#x20;                 visible thickness will be larger. You may skip the stroke,

&#x20;                 but then the lines will be less visible on light backgrounds.



&#x20;      Color:     use the RGB values from CS2.

&#x20;                 For example, #4F00FF (R=79, G=0, B=255).



&#x20;    Vertical bars:



&#x20;      Left:   X = 959, Y = 0, W = 1, H = 1080

&#x20;      Right:  X = 960, Y = 0, W = 1, H = 1080



&#x20;    Horizontal bars (if you want a full cross):



&#x20;      Top:    X = 0, Y = 539, W = 1920, H = 1

&#x20;      Bottom: X = 0, Y = 540, W = 1920, H = 1



&#x20;    Gap: in CS2 you can set cl\_crosshairgap to 0 so the lines meet.

&#x20;         If you want a gap, shift the bars by 1-2 pixels.



&#x20;    IMPORTANT: To make the bars perfectly even, enter the coordinates

&#x20;    through the Properties panel (X, Y, W, H) instead of drawing by hand.





1.4. Make sure the background layer is hidden (the eye icon is off).





1.5. Save the file:



&#x20;      File -> Export -> Export As...



&#x20;        Format:     PNG

&#x20;        "Transparency" checkbox — REQUIRED

&#x20;        File name:  lineup.png



&#x20;      Save it to the folder where the script will live

&#x20;      (for example, C:\\CrosshairOverlay\\).



&#x20;    IMPORTANT: Do NOT save as JPG — it does not support transparency,

&#x20;    and a dark or white rectangle will appear around the crosshair in game.





================================================================================

STEP 2. INSTALLING AUTOHOTKEY V2

================================================================================



2.1. Download the v2.0 installer from the official site autohotkey.com.



2.2. Run the installer. Windows will show a SmartScreen warning —

&#x20;    click "More info" -> "Run anyway".



&#x20;    This is a standard warning for any new program. It does not mean

&#x20;    the file contains a virus.



2.3. Install to any folder. Disk D is fine — it does not affect operation.



2.4. After installation, close the AutoHotkey Dash window.





================================================================================

STEP 3. CREATING THE SCRIPT

================================================================================



3.1. In the folder with lineup.png, create a new text file.



3.2. Open it and paste the following code:



\--------------------------------------------------------------------------------

\#Requires AutoHotkey v2.0

\#SingleInstance Force

A\_MenuMaskKey := "vkE8"    ; mask Win so Game Bar doesn't open



; Overlay settings

OverlayAlpha := 180        ; Opacity (0-255)

OverlayX\_Offset := 0       ; X offset from center

OverlayY\_Offset := 0       ; Y offset from center

ImageFile := "lineup.png"  ; Image file name



; Get screen resolution

ScreenW := A\_ScreenWidth

ScreenH := A\_ScreenHeight



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

MyGui.Show("x" (ScreenW/2 - (ScreenW/2) + OverlayX\_Offset) " y" (ScreenH/2 - (ScreenH/2) + OverlayY\_Offset) " w" ScreenW " h" ScreenH " NoActivate")

WinHide("ahk\_id " MyGui.Hwnd)



; --- Hotkeys ---

; Show overlay while mouse5 is held

XButton2:: {

&#x20;   WinShow("ahk\_id " MyGui.Hwnd)

}

; Hide on release

XButton2 Up:: {

&#x20;   WinHide("ahk\_id " MyGui.Hwnd)

}



; Minimize the game on a single Win press (hold = modifier)

LWin:: {

&#x20;   if KeyWait("LWin", "T0.25")

&#x20;       WinMinimize("A")

}



; Emergency exit on F12

F12::ExitApp

\--------------------------------------------------------------------------------



3.3. Save the file as lineup\_overlay.ahk (extension MUST be .ahk, not .txt).



&#x20;    If Windows hides extensions, enable them in Explorer:

&#x20;    View -> Show -> File name extensions.



&#x20;    IMPORTANT: If the file is saved as lineup\_overlay.ahk.txt, the script

&#x20;    will not run. Check the extension.





================================================================================

HOW TO CHANGE THE OVERLAY ACTIVATION BUTTON

================================================================================



By default the overlay is bound to mouse5 (XButton2). To use a different

button, find these two lines in the code:



&#x20;   XButton2:: {

&#x20;       WinShow("ahk\_id " MyGui.Hwnd)

&#x20;   }

&#x20;   XButton2 Up:: {

&#x20;       WinHide("ahk\_id " MyGui.Hwnd)

&#x20;   }



And replace XButton2 IN BOTH LINES with a value from the table below.





================================================================================

POPULAR BUTTON NAMES IN AUTOHOTKEY V2

================================================================================



&#x20; Button                                      Name in script

&#x20; -----------------------------------------   -----------------

&#x20; Mouse4 (side button, closer to thumb)       XButton1

&#x20; Mouse5 (side button, farther)               XButton2

&#x20; Middle mouse button                         MButton

&#x20; Left mouse button                           LButton

&#x20; Right mouse button                          RButton

&#x20; Mouse wheel up                              WheelUp

&#x20; Mouse wheel down                            WheelDown

&#x20; Mouse wheel left                            WheelLeft

&#x20; Mouse wheel right                           WheelRight

&#x20; Key F                                       f

&#x20; Key Space                                   Space

&#x20; Key V                                       v

&#x20; Key H                                       h

&#x20; Key CapsLock                                CapsLock

&#x20; Keys F1 - F12                               F1 ... F12

&#x20; Key Tab                                     Tab

&#x20; Left Alt                                    LAlt

&#x20; Left Ctrl                                   LCtrl

&#x20; Left Shift                                  LShift





================================================================================

EXAMPLE: REBINDING TO MOUSE4

================================================================================



Replace the hotkey block with:



&#x20;   XButton1:: {

&#x20;       WinShow("ahk\_id " MyGui.Hwnd)

&#x20;   }

&#x20;   XButton1 Up:: {

&#x20;       WinHide("ahk\_id " MyGui.Hwnd)

&#x20;   }



After editing, save the file and click Reload Script via the H tray icon.





================================================================================

IMPORTANT WHEN CHOOSING A BUTTON

================================================================================



&#x20; - Do not bind to keys already used in CS2 (fire, jump, crouch, grenades,

&#x20;   voice) — otherwise there will be a conflict.



&#x20; - If you use a keyboard key, make sure nothing is bound to it in game.

&#x20;   You can check in the console: bind h will show what is currently

&#x20;   bound to the key.



&#x20; - The pair "X::" and "X Up::" is REQUIRED. If you leave only the first

&#x20;   one, the overlay will turn on and never turn off.





================================================================================

STEP 4. CREATING THE .BAT TOGGLE (ON/OFF WITH ONE CLICK)

================================================================================



To avoid digging through folders and double-clicking, create a .bat file

that turns the overlay on and off with a single launch.



4.1. On your Desktop, create a text file and paste:



\--------------------------------------------------------------------------------

@echo off

title Crosshair Overlay Toggle



tasklist /FI "IMAGENAME eq AutoHotkey64.exe" 2>NUL | find /I "AutoHotkey64.exe" >NUL

if "%ERRORLEVEL%"=="0" goto kill

tasklist /FI "IMAGENAME eq AutoHotkey32.exe" 2>NUL | find /I "AutoHotkey32.exe" >NUL

if "%ERRORLEVEL%"=="0" goto kill

goto start



:kill

taskkill /IM AutoHotkey64.exe /F >NUL 2>\&1

taskkill /IM AutoHotkey32.exe /F >NUL 2>\&1

echo Overlay OFF

timeout /t 1 >NUL

exit



:start

start "" "%\~dp0lineup\_overlay.ahk"

echo Overlay ON

timeout /t 1 >NUL

\--------------------------------------------------------------------------------



4.2. IMPORTANT about the path:



&#x20;    The line start "" "%\~dp0lineup\_overlay.ahk" uses a relative path.

&#x20;    %\~dp0 means "the folder where this .bat file is located".



&#x20;    This means the .bat file and lineup\_overlay.ahk MUST be in the SAME

&#x20;    folder. If you move the .bat to the Desktop, it will not find the

&#x20;    script.



&#x20;    If you want the .bat file to be somewhere else, replace the path with

&#x20;    a full absolute path, for example:



&#x20;      start "" "C:\\CrosshairOverlay\\lineup\_overlay.ahk"



&#x20;    NOTE: The path MUST be in double quotes. If the path contains spaces,

&#x20;    the .bat file will not work without quotes.



4.3. Save the file and rename it to Crosshair.bat (remove .txt, add .bat).



&#x20;    If Windows will not let you rename, enable file extensions first.



4.4. Confirm the "File may be unsafe..." warning — click "Yes".



Now just double-click Crosshair.bat:



&#x20; - If the overlay is OFF — it will start (H icon appears in the tray).

&#x20; - If the overlay is ON — it will stop (H icon disappears).





================================================================================

HOTKEY FOR THE .BAT FILE (OPTIONAL)

================================================================================



&#x20; 1. Right-click Crosshair.bat ->

&#x20;    "Send to" -> "Desktop (create shortcut)".



&#x20; 2. On the shortcut: right-click -> "Properties" ->

&#x20;    "Shortcut key" field -> press the desired combination

&#x20;    (for example, Ctrl + Alt + X).



&#x20; 3. Click "OK". Now you can toggle the overlay from the keyboard.





================================================================================

STEP 5. MANAGING THE SCRIPT

================================================================================



&#x20; - Start: double-click lineup\_overlay.ahk.

&#x20;   A green H icon appears in the tray.

&#x20;   If you don't see it, click the ^ arrow near the clock to expand

&#x20;   hidden icons.



&#x20; - Reload after edits: right-click the H icon -> Reload Script.



&#x20; - Stop: right-click the H icon -> Exit.

&#x20;   Or use the .bat toggle, or the taskkill commands (see Step 6).



&#x20; IMPORTANT: If you shut down or restart your PC, the script will NOT

&#x20; auto-start. You must launch lineup\_overlay.ahk manually (or via

&#x20; Crosshair.bat) before starting CS2 each time.





================================================================================

STEP 6. MANAGING THE PROCESS VIA CONSOLE (TASKKILL)

================================================================================



To force-close the script, open Command Prompt (Win + R -> cmd) and run

one of these commands:



&#x20;   taskkill /IM AutoHotkey.exe /F

&#x20;   taskkill /IM AutoHotkey64.exe /F

&#x20;   taskkill /IM AutoHotkey32.exe /F



&#x20; - If the process is not found — that's normal; the script is already off.

&#x20; - In AutoHotkey v2 the process is usually AutoHotkey64.exe

&#x20;   (on 64-bit systems).

&#x20; - These commands contain no username and can be copied as-is.





================================================================================

STEP 7. USING IN CS2

================================================================================



&#x20; 1. Launch CS2.



&#x20; 2. In video settings, choose "Windowed Fullscreen" mode.



&#x20;    IMPORTANT: In "Full Screen" mode the overlay will not be visible.

&#x20;    This is a Windows limitation, not a script bug.



&#x20; 3. Hold mouse5 — the lines will appear on top of the game.

&#x20;    Release — they disappear.



&#x20; 4. To minimize the game, press Win once (single press).

&#x20;    If you hold Win and press another key, the system combination

&#x20;    will trigger instead.





================================================================================

SCRIPT SETTINGS (FOR FINE-TUNING)

================================================================================



At the top of lineup\_overlay.ahk you can change:



&#x20; OverlayAlpha  - opacity (0 = fully transparent,

&#x20;                 255 = opaque). Optimal range is 150-200.



&#x20; OverlayX\_Offset, OverlayY\_Offset

&#x20;               - overlay offset from screen center in pixels.

&#x20;                 Default is 0.



&#x20; ImageFile     - image file name, if you named it differently.



After editing, save the file and click Reload Script via the H tray icon.





================================================================================

SECURITY AND VAC

================================================================================



&#x20; - The overlay does NOT inject into the game, does NOT read memory,

&#x20;   does NOT modify files. It only uses standard Windows features

&#x20;   (a transparent window).



&#x20; - VAC does not ban for external overlays that do not provide an unfair

&#x20;   advantage (e.g. do not show enemies through walls).



&#x20; - Use in competitive matchmaking is at your own risk.



&#x20; - Do NOT use this overlay in tournaments where third-party software

&#x20;   is prohibited.



&#x20; - Do not run .ahk scripts from untrusted sources. Download AutoHotkey

&#x20;   only from the official site autohotkey.com.





================================================================================

BONUS: CHANGING CROSSHAIR COLORS IN GAME (CHCOLOR.CFG)

================================================================================



If you want to quickly change crosshair colors in CS2 via the console,

you can use a config with aliases. Example:



\--------------------------------------------------------------------------------

// chcolor.cfg

alias "chc0"  "cl\_crosshaircolor 5; cl\_crosshaircolor\_r 250; cl\_crosshaircolor\_g 50;  cl\_crosshaircolor\_b 50;  echo crosshair: 0 red"

alias "chc1"  "cl\_crosshaircolor 5; cl\_crosshaircolor\_r 50;  cl\_crosshaircolor\_g 250; cl\_crosshaircolor\_b 50;  echo crosshair: 1 green"

// ... and so on

alias "chc\_next" "chc\_c0"

alias "chc\_c0"  "cl\_crosshaircolor 5; chc0;  alias chc\_next chc\_c1"

// ... full cycle

bind "h" "chc\_next"

\--------------------------------------------------------------------------------



&#x20; - Custom colors require cl\_crosshaircolor 5.

&#x20; - Save the file as chcolor.cfg (not .txt).

&#x20; - In console: exec chcolor.

&#x20; - The H key will cycle through the colors.



&#x20; IMPORTANT: Aliases in CS2 now only work when loaded via autoexec at

&#x20; game start or manually in the console. Loading them via exec during

&#x20; a match no longer works.





================================================================================

LICENSE AND COPYRIGHT

================================================================================



This README and script are provided "as is" for personal use.

You are free to distribute and modify them.

