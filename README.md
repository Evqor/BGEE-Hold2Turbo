# BGEE-Hold2Turbo

**BGEE-Hold2Turbo** is a small helper utility for *Baldur's Gate: Enhanced Edition* that makes it easier to use Cheat Engine Speedhack as a temporary hold-to-turbo button.

It does not patch BGEE game files directly. Instead, it combines **AutoHotkey v2** and **Cheat Engine**:

- AutoHotkey detects the BGEE process and opens the included Cheat Engine table after a short startup delay.
- The Cheat Engine table registers BGEE process names for auto-attach.
- Cheat Engine handles the actual Speedhack hotkey, hold key, speed value, and `Stop on release` behavior.

AutoHotkey is only used to detect `Baldur.exe` / `Baldur64.exe` and load the Cheat Engine table. If you want to change the key or turbo speed, use Cheat Engine's hotkey settings.

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

Open Cheat Engine and configure a Speedhack hotkey.

Recommended setup:

```text
Hotkey: your preferred hold key, such as XButton1 or F9
Speed: 2.0x
Stop on release: enabled
```

With `Stop on release` enabled, Cheat Engine applies turbo speed only while the hotkey is being held. When the key is released, Cheat Engine stops the temporary speed change.

The AutoHotkey script does not translate mouse buttons or keyboard keys. It only opens the Cheat Engine table automatically. Key binding and speed changes should be handled inside Cheat Engine.

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
→ You use the Speedhack hold key configured in Cheat Engine
```

## Start with Windows

To run the script automatically when Windows starts:

1. Press `Win + R`.
2. Enter:

```text
shell:startup
```

3. Place a shortcut to `BGEE-Hold2Turbo.ahk` in that folder.

## Change the hold key

Change the Speedhack hotkey inside Cheat Engine.

For example, you can set the hotkey to:

```text
XButton1
```

or:

```text
F9
```

Keep `Stop on release` enabled if you want turbo speed only while holding the key.

## Change the turbo speed

Change the Speedhack value assigned to the hotkey inside Cheat Engine.

Examples:

```text
1.5x
2.0x
3.0x
```

`2.0x` is a reasonable starting point. Higher values may make input timing or scripted events feel less stable.

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
- AutoHotkey is used only for detecting BGEE and opening the Cheat Engine table.
- Key binding, Speedhack speed, and `Stop on release` should be configured in Cheat Engine.
- The table registers Cheat Engine auto-attach entries but does not directly call `openProcess()` during Lua startup.
- Cheat Engine may ask for confirmation before running Lua from the table. Choose **Always** if you want the auto-attach setup to run without asking again.
- If BGEE or Steam is running as administrator, AutoHotkey and Cheat Engine may need matching permissions.
- Avoid using this in multiplayer or online environments.
