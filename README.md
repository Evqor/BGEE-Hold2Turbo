# BGEE-Hold2Turbo

[한국어 README](README.ko.md)

**BGEE-Hold2Turbo** is a small helper utility for *Baldur's Gate: Enhanced Edition* that detects when Baldur's Gate starts, automatically opens the included Cheat Engine table, and closes the Cheat Engine process launched by the script when the game exits.

It does not patch BGEE game files directly. Instead, it combines **AutoHotkey v2** and **Cheat Engine**:

- AutoHotkey detects `Baldur.exe` / `Baldur64.exe` and opens the included Cheat Engine table when the game window is available.
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

Place these files in the same folder:

```text
BGEE-Hold2Turbo.ahk
BGEE-Hold2Turbo.ct
settings.ini.example
```

`settings.ini` is created automatically on first run. It is not included as a release file so your local settings are not overwritten during updates.

### 3. Check the Cheat Engine path

The script automatically checks common Cheat Engine install paths, including:

```text
C:\Program Files\Cheat Engine 7.6\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine 7.5\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine 7.4\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine\cheatengine-x86_64.exe
```

If auto-detection fails, open `settings.ini` and set `CheatEngineExe` manually.

Example:

```ini
[Paths]
CheatEngineExe=C:\Program Files\Cheat Engine 7.5\cheatengine-x86_64.exe
```

### 4. Optional settings

Configuration is stored in `settings.ini`.

By default, BGEE-Hold2Turbo opens the Cheat Engine table as soon as the BGEE process and game window are detected.

If an error occurs during automatic table loading, try enabling the startup delay:

```ini
[General]
UseOpenTableDelay=true
OpenTableDelayMs=3000
```

If you want an easy way to check whether the table is being opened automatically, enable the attach notification:

```ini
[Notifications]
AttachNotify=true
```

Normal table-open and Cheat Engine-exit notifications are disabled by default. Startup warnings are enabled by default.

### 5. Run the script

Run:

```text
BGEE-Hold2Turbo.ahk
```

Then start BGEE. The script waits until the BGEE process and game window exist, then opens the Cheat Engine table.

Expected behavior:

```text
AHK starts
→ settings.ini is created if it does not exist
→ BGEE process is detected
→ BGEE window appears
→ BGEE-Hold2Turbo.ct opens through Cheat Engine
→ Cheat Engine attaches to BGEE
→ You use the Speedhack hold key configured in Cheat Engine
→ When BGEE closes, the Cheat Engine process launched by this script closes too
```

## Logs

BGEE-Hold2Turbo writes a small runtime log by default:

```text
logs\BGEE-Hold2Turbo.log
```

The log records helper startup, BGEE detection, Cheat Engine table opening, Cheat Engine shutdown, and common path errors.

If the log grows past the configured size, the old log is moved to:

```text
logs\BGEE-Hold2Turbo.log.old
```

You can change logging behavior in `settings.ini`:

```ini
[Logging]
EnableLog=true
LogPath=logs\BGEE-Hold2Turbo.log
MaxLogSizeKB=512
```

## Start with Windows

To run the script automatically when Windows starts:

1. Press `Win + R`.
2. Enter:

```text
shell:startup
```

3. Place a shortcut to `BGEE-Hold2Turbo.ahk` in that folder.

## Updating

Download the latest release archive and overwrite the old helper files.

Your local `settings.ini` and `logs` folder are not included in release archives, so updating should not overwrite your settings or logs.

## Notes

- If BGEE or Steam is running as administrator, AutoHotkey and Cheat Engine may need matching permissions.
- Higher Speedhack values may make input timing or scripted events feel less stable.
- If it does not work even with startup delay enabled, please open an issue with your BGEE executable name, Cheat Engine version, AutoHotkey version, and the relevant log file.
