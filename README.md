# BGEE-Hold2Turbo

**BGEE-Hold2Turbo** is a small utility for *Baldur's Gate: Enhanced Edition* that lets you temporarily speed up the game while holding a mouse side button.

It does not patch BGEE game files directly. Instead, it combines **AutoHotkey v2** and **Cheat Engine Speedhack**:

- Hold `XButton1` while the BGEE window is active → switch to turbo speed.
- Release `XButton1` → return to normal speed.
- The AutoHotkey script watches for the BGEE process and opens the included Cheat Engine table automatically.
- The Cheat Engine table registers BGEE process names for auto-attach.

## Requirements

- Baldur's Gate: Enhanced Edition
- AutoHotkey v2
- Cheat Engine

## Files

```text
BGEE-Hold2Turbo/
├─ BGEE-Hold2Turbo.ahk
├─ BGEE-Hold2Turbo.ct
└─ README.md
```

## Setup

### 1. Configure Cheat Engine Speedhack hotkeys

Open Cheat Engine and configure Speedhack hotkeys like this:

```text
Ctrl + Alt + Shift + 1 → Speedhack 2.0x
Ctrl + Alt + Shift + 2 → Speedhack 1.0x
```

The AutoHotkey script does not directly change the speed value itself. It sends these hotkeys to Cheat Engine when you press or release the mouse side button.

### 2. Keep the files together

Place these two files in the same folder:

```text
BGEE-Hold2Turbo.ahk
BGEE-Hold2Turbo.ct
```

### 3. Check the Cheat Engine path

The script automatically checks common Cheat Engine install paths, including:

```text
C:\Program Files\Cheat Engine 7.6\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine 7.5\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine 7.4\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine\cheatengine-x86_64.exe
```

If auto-detection fails, open `BGEE-Hold2Turbo.ahk` and set `ceExe` manually.

Example:

```ahk
ceExe := "C:\Program Files\Cheat Engine 7.5\cheatengine-x86_64.exe"
```

### 4. Run the script

Run:

```text
BGEE-Hold2Turbo.ahk
```

Then start BGEE. The script will detect the game process and open the Cheat Engine table.

Expected behavior:

```text
AHK starts
→ BGEE process is detected
→ BGEE-Hold2Turbo.ct opens through Cheat Engine
→ The CT Lua script registers Baldur.exe / Baldur64.exe for auto-attach
→ Hold XButton1 while the BGEE window is active: turbo speed
→ Release XButton1: normal speed
```

## Start with Windows

To run the script automatically when Windows starts:

1. Press `Win + R`.
2. Enter:

```text
shell:startup
```

3. Place a shortcut to `BGEE-Hold2Turbo.ahk` in that folder.

## Change the mouse button

The default button is `XButton1`.

To use `XButton2`, edit the two hotkey labels near the bottom of `BGEE-Hold2Turbo.ahk`:

```ahk
XButton1::
XButton1 Up::
```

Change them to:

```ahk
XButton2::
XButton2 Up::
```

## Change the turbo speed

The default recommended setup is:

```text
Ctrl + Alt + Shift + 1 → turbo speed
Ctrl + Alt + Shift + 2 → normal speed
```

To use `1.5x` instead of `2.0x`, change the Speedhack value assigned to `Ctrl + Alt + Shift + 1` inside Cheat Engine.

## Notes

- This is an external automation utility, not a WeiDU mod.
- Cheat Engine may ask for confirmation before running Lua from the table.
- If BGEE or Steam is running as administrator, AutoHotkey and Cheat Engine may need matching permissions.
- Avoid using this in multiplayer or online environments.
