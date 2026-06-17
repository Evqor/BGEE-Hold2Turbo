# BGEE-Hold2Turbo

**BGEE-Hold2Turbo** is a small helper utility for *Baldur's Gate: Enhanced Edition* that detects when Baldur's Gate starts and automatically opens the included Cheat Engine table for easier Speedhack setup.

It does not patch BGEE game files directly. Instead, it combines **AutoHotkey v2** and **Cheat Engine**:

- AutoHotkey detects `Baldur.exe` / `Baldur64.exe` and opens the included Cheat Engine table after a short startup delay.
- The Cheat Engine table prepares auto-attach entries for BGEE.
- Cheat Engine handles the actual Speedhack behavior.

If you want to change the hold key or turbo speed, use Cheat Engine's hotkey settings.

Use this for single-player/offline play. Avoid using it in multiplayer or online environments.

## Requirements

- Baldur's Gate: Enhanced Edition
- AutoHotkey v2
- Cheat Engine

## Setup

### 1. Configure Cheat Engine Speedhack

Open Cheat Engine and configure a Speedhack hotkey.

Example setup:

```text
Hotkey: your preferred hold key, such as XButton1 or F9
Speed: 2.0x
Stop on release: enabled
```

If Cheat Engine cannot attach to BGEE automatically the first time, you may need to select the BGEE process manually once in Cheat Engine.

If Cheat Engine shows a prompt saying that the table contains Lua code and asks when to run it, choose **Always** and click **Yes**. This allows the table's auto-attach script to run automatically, and the prompt should not appear again for this table.

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

### 4. Optional notifications

The script has separate notification settings for table loading and Cheat Engine exit behavior.

```ahk
attachNotify := true
cheatEngineExitNotify := true
```

Set either value to `false` if you do not want that notification.

Normal notifications use an information icon instead of the default error-looking icon.

### 5. Run the script

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
→ Cheat Engine attaches to BGEE
→ You use the Speedhack hold key configured in Cheat Engine
→ When BGEE closes, the Cheat Engine process launched by this script closes too
```

## Start with Windows

To run the script automatically when Windows starts:

1. Press `Win + R`.
2. Enter:

```text
shell:startup
```

3. Place a shortcut to `BGEE-Hold2Turbo.ahk` in that folder.

## Stability options

If BGEE closes when the Cheat Engine table opens automatically, open `BGEE-Hold2Turbo.ahk` and increase the startup delay:

```ahk
openTableDelayMs := 12000
```

For example, try `20000` to wait 20 seconds before opening the table.

If it still does not work, please open an issue with your BGEE executable name, Cheat Engine version, and AutoHotkey version.

## Notes

- If BGEE or Steam is running as administrator, AutoHotkey and Cheat Engine may need matching permissions.
- Higher Speedhack values may make input timing or scripted events feel less stable.
