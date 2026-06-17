# BGEE-Hold2Turbo

**BGEE-Hold2Turbo** is a small utility for *Baldur's Gate: Enhanced Edition* that lets you temporarily speed up the game while holding a mouse side button.

It does not patch BGEE game files directly. Instead, it combines **AutoHotkey v2** and **Cheat Engine Speedhack**:

- Hold `XButton1` while the BGEE window is active → enable turbo speed.
- Release `XButton1` → Cheat Engine stops the turbo hotkey automatically.
- The AutoHotkey script watches for the BGEE process and opens the included Cheat Engine table after a short startup delay.
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

### 1. Configure Cheat Engine Speedhack

Open Cheat Engine and configure one Speedhack hotkey like this:

```text
Hotkey: F9
Speed: 2.0x
Stop on release: enabled
```

The AutoHotkey script holds `F9` down while you hold the mouse side button, then releases `F9` when you release the button. Cheat Engine handles the return to normal speed through `Stop on release`.

If Cheat Engine shows a prompt saying that the table contains Lua code and asks when to run it, choose **Always** and click **OK**. This allows the table's auto-attach script to run automatically, and the prompt should not appear again for this table.

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

Then start BGEE. The script waits until the BGEE process and game window exist, waits a short delay, and then opens the Cheat Engine table.

Expected behavior:

```text
AHK starts
→ BGEE process is detected
→ BGEE window appears
→ AHK waits briefly to avoid BGEE's startup phase
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

## Change the turbo key

The default virtual key sent to Cheat Engine is `F9`.

To use a different key, change this line in `BGEE-Hold2Turbo.ahk`:

```ahk
turboKey := "F9"
```

Then configure the same key as the Speedhack hotkey in Cheat Engine with `Stop on release` enabled.

## Change the turbo speed

The recommended setup is `2.0x`.

To use `1.5x` or another value, change the Speedhack value assigned to the hotkey inside Cheat Engine.

## Stability options

If BGEE closes when the Cheat Engine table opens automatically, open `BGEE-Hold2Turbo.ahk` and increase the startup delay:

```ahk
openTableDelayMs := 12000
```

For example, try `20000` to wait 20 seconds before opening the table.

If BGEE still closes, disable automatic table opening:

```ahk
autoOpenCheatTable := false
```

Then open `BGEE-Hold2Turbo.ct` manually after BGEE reaches the main menu or after a save has loaded.

## Notes

- This is an external automation utility, not a WeiDU mod.
- The table registers Cheat Engine auto-attach entries but does not directly call `openProcess()` during Lua startup.
- Cheat Engine may ask for confirmation before running Lua from the table. Choose **Always** if you want the auto-attach setup to run without asking again.
- If BGEE or Steam is running as administrator, AutoHotkey and Cheat Engine may need matching permissions.
- Avoid using this in multiplayer or online environments.
