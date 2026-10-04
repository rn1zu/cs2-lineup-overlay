# External Overlay Crosshair for CS2 (Line-Up)

> A transparent overlay with long lines for precise line-ups.  
> Appears when you press a side mouse button, does not inject into the game.

---

## 📖 Table of Contents

- [Purpose](#-purpose)
- [What You'll Need](#-what-youll-need)
- [Step 1. Preparing the Image](#-step-1-preparing-the-crosshair-image-in-photoshop)
- [Step 2. Installing AutoHotkey](#-step-2-installing-autohotkey-v2)
- [Step 3. Creating the Script](#-step-3-creating-the-script)
- [How to Change the Overlay Activation Button](#-how-to-change-the-overlay-activation-button)
- [Step 4. .bat Toggle](#-step-4-creating-a-bat-toggle-onoff-with-one-button)
- [Step 5. Managing the Script](#-step-5-managing-the-script)
- [Step 6. Taskkill via Console](#-step-6-managing-the-process-via-console-taskkill)
- [Step 7. Using in CS2](#-step-7-using-in-cs2)
- [Script Settings](#-script-settings-for-fine-tuning)
- [Safety and VAC](#-safety-and-vac)
- [Changing Crosshair Colors (chcolor.cfg)](#-additional-changing-crosshair-colors-in-game-chcolorcfg)
- [License](#-license-and-copyright)

---

## 🎯 Purpose

After the CS2 "Rush Hour" update (September 2026), the maximum crosshair line length `cl_crosshair_length` is limited to **255 pixels**. For precise line-ups, this is not enough.

This repository describes how to create and use an **external overlay** — a transparent image with long lines that appears on top of the game when you press a side mouse button (mouse5).

The overlay **does not inject** into the game process, does not read its memory, and does not modify its files. It is rendered using Windows tools via AutoHotkey.

> ⚠️ **IMPORTANT:** Use in ranked matches is at your own risk. In tournaments where third-party programs are prohibited, the overlay **must not** be used.

---

## 🧰 What You'll Need

| # | Component | Note |
|---|-----------|------|
| 1 | Windows 10/11 | — |
| 2 | [AutoHotkey v2](https://www.autohotkey.com/) | Download only from the official website |
| 3 | Adobe Photoshop | Or any editor that supports PNG and transparency |
| 4 | CS2 | Running in **"Windowed Borderless"** mode |

> ⚠️ In **"Full Screen"** mode, the overlay will **not** work.

---

## 🖼️ Step 1. Preparing the Crosshair Image in Photoshop

### 1.1. New Document

| Parameter | Value |
|----------|----------|
| Width | `1920 px` |
| Height | `1080 px` |
| Resolution | `72 ppi` |
| Color Mode | `RGB, 8 bit` |
| Background Contents | **Transparent** |

> ⚠️ Be sure to select a **"Transparent"** background. If you choose "White," the crosshair will cover the entire screen with a white square in-game.

### 1.2. Guides

```
View → New Guides
  Vertical:   960 px
  Horizontal: 540 px
```

### 1.3. Drawing the Lines

Use the **"Rectangle"** tool (`U` key).

| Parameter | Value |
|----------|----------|
| Thickness | Same as `cl_crosshairthickness` in CS2 (e.g., `2` px) |
| Color | RGB values from CS2 (e.g., `#4F00FF` = R:79, G:0, B:255) |

**Vertical bars:**

| Bar | X | Y | W | H |
|--------|---|---|---|---|
| Left | 959 | 0 | 1 | 1080 |
| Right | 960 | 0 | 1 | 1080 |

**Horizontal bars** (if you need a full cross):

| Bar | X | Y | W | H |
|--------|---|---|---|---|
| Top | 0 | 539 | 1920 | 1 |
| Bottom | 0 | 540 | 1920 | 1 |

> 💡 **Gap:** In CS2, you can set `cl_crosshairgap` to `0` — the lines will meet. If you need a gap, shift the bars by 1–2 pixels.

> ⚠️ To make the bars perfectly even, enter the coordinates through the **"Properties"** panel (X, Y, W, H) rather than drawing with the mouse.

### 1.4. Hide the Background Layer

Make sure the background layer is **turned off** (the eye icon is not lit).

### 1.5. Save

```
File → Export → Export As...
  Format:     PNG
  Check "Transparency" — mandatory
  File name:  lineup.png
```

> ⚠️ Do not save as JPG — it does not support transparency, and a dark or white rectangle will appear around the crosshair in-game.

---

## ⚙️ Step 2. Installing AutoHotkey v2

1. Download the **v2.0** installer from [autohotkey.com](https://www.autohotkey.com/).
2. Run it. Windows will show a SmartScreen warning — click **"More info → Run anyway."**  
   *This is a standard warning for new programs; it does not mean a virus is present.*
3. Install to any folder (you can use drive D — it doesn't affect functionality).
4. After installation, close the **AutoHotkey Dash** window.

---

## 📝 Step 3. Creating the Script

### 3.1. Create a text file in the folder with `lineup.png`

### 3.2. Paste the code

```autohotkey
#Requires AutoHotkey v2.0
#SingleInstance Force
A_MenuMaskKey := "vkE8"    ; mask Win key so Game Bar doesn't open

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
XButton2:: {
    WinShow("ahk_id " MyGui.Hwnd)
}
XButton2 Up:: {
    WinHide("ahk_id " MyGui.Hwnd)
}

; Minimize game with a single Win key press
LWin:: {
    if KeyWait("LWin", "T0.25")
        WinMinimize("A")
}

; Emergency exit with F12
F12::ExitApp
```

### 3.3. Save as `lineup_overlay.ahk`

> ⚠️ The extension must be **`.ahk`**, not `.txt`.  
> To enable extension display: `View → Show → File name extensions`.

---

## 🖱️ How to Change the Overlay Activation Button

By default, the overlay activates with **mouse5** (`XButton2`). Find this in the code:

```autohotkey
XButton2:: {
    WinShow("ahk_id " MyGui.Hwnd)
}
XButton2 Up:: {
    WinHide("ahk_id " MyGui.Hwnd)
}
```

And replace `XButton2` **in both lines** with the desired value from the table.

### Popular Button Options

| Button | Name in Script |
|--------|-------------------|
| Mouse4 (side, closer to thumb) | `XButton1` |
| Mouse5 (side, farther) | `XButton2` |
| Middle mouse button | `MButton` |
| Left button | `LButton` |
| Right button | `RButton` |
| Scroll up | `WheelUp` |
| Scroll down | `WheelDown` |
| Scroll left | `WheelLeft` |
| Scroll right | `WheelRight` |
| F key | `f` |
| Space key | `Space` |
| V key | `v` |
| H key | `h` |
| CapsLock key | `CapsLock` |
| F1–F12 keys | `F1` … `F12` |
| Tab key | `Tab` |
| Left Alt | `LAlt` |
| Left Ctrl | `LCtrl` |
| Left Shift | `LShift` |

### Example: Rebind to Mouse4

```autohotkey
XButton1:: {
    WinShow("ahk_id " MyGui.Hwnd)
}
XButton1 Up:: {
    WinHide("ahk_id " MyGui.Hwnd)
}
```

After editing — **Reload Script** via the `H` icon in the tray.

> ⚠️ **Important when choosing a button:**
> - Do not assign to buttons used in CS2 (shooting, jumping, crouching, grenades, voice).
> - Check binds in the console: `bind h` will show what's assigned to the key.
> - The pair `X::` and `X Up::` is **mandatory**. If you leave only the first one — the overlay will turn on and never turn off.

---

## 🔁 Step 4. Creating a .bat Toggle (On/Off with One Button)

To avoid digging through folders and double-clicking, create a `.bat` file.

### 4.1. Create a text file and paste the code

```bat
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
start "" "C:\CrosshairOverlay\lineup_overlay.ahk"
echo Overlay ON
timeout /t 1 >NUL
```

### 4.2. Replace the path with your actual one

Line:
```bat
start "" "C:\CrosshairOverlay\lineup_overlay.ahk"
```

**How to find your path:**
1. Open the folder with the `lineup_overlay.ahk` file.
2. Click once on the File Explorer address bar.
3. Copy the path (`Ctrl + C`).
4. Paste it into the `.bat` instead of the example, adding `\lineup_overlay.ahk` at the end.

> ⚠️ The path must be in quotes. If the path contains spaces, the `.bat` will not work without quotes.

### 4.3. Save as `Crosshair.bat`

Remove `.txt`, add `.bat`. If Windows won't let you rename — enable extension display.

### 4.4. Confirm the warning

Windows may show "The file may be unsafe..." — click **"Yes."**

### How to Use

Simply double-click `Crosshair.bat`:

- If the overlay is **off** → it will start (the `H` icon appears in the tray).
- If the overlay is **on** → it will stop (the icon disappears).

### Hotkey for the .bat (optional)

1. Right-click `Crosshair.bat` → **"Send to" → "Desktop (create shortcut)."**
2. On the shortcut: right-click → **"Properties"** → **"Shortcut key"** field → press your desired combination (e.g., `Ctrl + Alt + X`).
3. **"OK."** Now you can toggle the overlay from the keyboard.

---

## 🎛️ Step 5. Managing the Script

| Action | How to Do It |
|----------|-------------|
| **Start** | Double-click `lineup_overlay.ahk`. A green `H` icon will appear in the tray. If not visible — click `^` next to the clock. |
| **Restart after edits** | Right-click the `H` icon → **Reload Script** |
| **Stop** | Right-click the `H` icon → **Exit**. Or use the `.bat` toggle, or `taskkill` (see Step 6). |

> ⚠️ If you shut down or restart your computer, the script will **not** start automatically. You need to launch `lineup_overlay.ahk` manually each time (or via `Crosshair.bat`) before starting CS2.

---

## 🖥️ Step 6. Managing the Process via Console (taskkill)

Open the command prompt (`Win + R` → `cmd`) and run one of the commands:

```cmd
taskkill /IM AutoHotkey.exe /F
taskkill /IM AutoHotkey64.exe /F
taskkill /IM AutoHotkey32.exe /F
```

- If the process is not found — that's normal, it means the script is already off.
- In AutoHotkey v2, the process is usually named `AutoHotkey64.exe` (on a 64-bit system).
- The commands do not contain a username — you can copy them as-is.

---

## 🎮 Step 7. Using in CS2

1. Launch CS2.
2. In video settings, select **"Windowed Borderless"** mode.  
   > ⚠️ In "Full Screen" mode, the overlay will not be visible. This is a Windows limitation, not a script error.
3. Hold `mouse5` — your lines will appear over the game. Release — they disappear.
4. To minimize the game, press `Win` (single press).  
   If you hold `Win` and press another key — the system combination will trigger.

---

## 🔧 Script Settings (for Fine-Tuning)

At the beginning of the `lineup_overlay.ahk` file, you can change:

| Parameter | Description |
|----------|----------|
| `OverlayAlpha` | Transparency (`0` — transparent, `255` — opaque). Optimal is `150–200`. |
| `OverlayX_Offset` | Overlay offset from center on X in pixels. |
| `OverlayY_Offset` | Overlay offset from center on Y in pixels. |
| `ImageFile` | Image file name, if you named it differently. |

After editing — **Reload Script** via the `H` icon.

---

## 🛡️ Safety and VAC

- The overlay **does not inject** into the game, does not read memory, does not modify files. It uses only standard Windows functions (transparent window).
- VAC does not ban for external overlays that do not provide an unfair advantage (e.g., do not show enemies through walls).
- Use in ranked matches is **at your own risk**.
- **Do not use** in tournaments where third-party programs are prohibited.
- Do not run `.ahk` scripts from untrusted sources. Download AutoHotkey only from [autohotkey.com](https://www.autohotkey.com/).

---

## 🎨 Additional: Changing Crosshair Colors In-Game (chcolor.cfg)

If you want to quickly change crosshair colors via the console — use a config with aliases:

```cfg
// chcolor.cfg
alias "chc0"  "cl_crosshaircolor 5; cl_crosshaircolor_r 250; cl_crosshaircolor_g 50;  cl_crosshaircolor_b 50;  echo crosshair: 0 red"
alias "chc1"  "cl_crosshaircolor 5; cl_crosshaircolor_r 50;  cl_crosshaircolor_g 250; cl_crosshaircolor_b 50;  echo crosshair: 1 green"
// ... and so on
alias "chc_next" "chc_c0"
alias "chc_c0"  "cl_crosshaircolor 5; chc0;  alias chc_next chc_c1"
// ... full cycle
bind "h" "chc_next"
```

- For custom colors, `cl_crosshaircolor 5` is required.
- Save as `chcolor.cfg` (not `.txt`).
- In the console: `exec chcolor`.
- The `H` key will cycle through colors.

> ⚠️ Aliases (`alias`) in CS2 now only work when loaded via **autoexec** at game startup or manually through the console. Loading them via `exec` during a match is no longer possible.

---

## 📜 License and Copyright

This README and script are provided "as is" for personal use.  
You are free to distribute and modify them.

---
