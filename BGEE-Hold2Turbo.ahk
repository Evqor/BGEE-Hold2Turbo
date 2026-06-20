#Requires AutoHotkey v2.0
#SingleInstance Force

; BGEE-Hold2Turbo
; Watches for Baldur's Gate: Enhanced Edition and opens the included
; Cheat Engine table when the game window is available.
;
; This script does not remap input keys or control Speedhack directly.
; Configure the hold key and turbo speed inside Cheat Engine's hotkey settings.
;
; User settings are stored in settings.ini. If settings.ini does not exist,
; this script creates it with safe defaults.

; =========================
; Paths
; =========================

settingsPath := A_ScriptDir "\settings.ini"

; =========================
; Default settings
; =========================

defaultGameExeCandidates := "Baldur.exe,Baldur64.exe"
defaultCtPath := "BGEE-Hold2Turbo.ct"
defaultCeExe := ""
defaultAutoOpenCheatTable := true
defaultUseOpenTableDelay := false
defaultOpenTableDelayMs := 3000
defaultRequireGameWindowBeforeOpen := true
defaultWatchIntervalMs := 1000
defaultCloseCheatEngineOnGameExit := true
defaultAttachNotify := false
defaultExitNotify := false
defaultStartupWarningNotify := true
defaultNormalNotifyOptions := "Iconi"
defaultWarningNotifyOptions := "Icon!"
defaultEnableLog := true
defaultLogPath := "logs\BGEE-Hold2Turbo.log"
defaultMaxLogSizeKB := 512

if !FileExist(settingsPath) {
    CreateDefaultSettings(settingsPath)
}

; =========================
; User settings
; =========================

gameExeCandidates := ReadCsvSetting("General", "GameExeCandidates", defaultGameExeCandidates)
ctPath := ResolveScriptPath(ReadTextSetting("Paths", "CheatTablePath", defaultCtPath))

; Set this manually in settings.ini if auto-detection fails.
ceExe := ReadTextSetting("Paths", "CheatEngineExe", defaultCeExe)

; Controls automatic CT loading. Normally leave this enabled.
autoOpenCheatTable := ReadBoolSetting("General", "AutoOpenCheatTable", defaultAutoOpenCheatTable)

; Optional wait before opening the CT after the BGEE process appears.
; Normally this can stay disabled because the script waits for the BGEE window first.
useOpenTableDelay := ReadBoolSetting("General", "UseOpenTableDelay", defaultUseOpenTableDelay)
openTableDelayMs := ReadIntSetting("General", "OpenTableDelayMs", defaultOpenTableDelayMs, 0, 60000)

; Only open the CT after a BGEE window exists, not immediately after the process appears.
requireGameWindowBeforeOpen := ReadBoolSetting("General", "RequireGameWindowBeforeOpen", defaultRequireGameWindowBeforeOpen)

watchIntervalMs := ReadIntSetting("General", "WatchIntervalMs", defaultWatchIntervalMs, 250, 60000)

; Notifications.
attachNotify := ReadBoolSetting("Notifications", "AttachNotify", defaultAttachNotify)
exitNotify := ReadBoolSetting("Notifications", "ExitNotify", defaultExitNotify)
startupWarningNotify := ReadBoolSetting("Notifications", "StartupWarningNotify", defaultStartupWarningNotify)

; Notification icon options.
normalNotifyOptions := ReadTextSetting("Notifications", "NormalNotifyOptions", defaultNormalNotifyOptions)
warningNotifyOptions := ReadTextSetting("Notifications", "WarningNotifyOptions", defaultWarningNotifyOptions)

; Close the Cheat Engine process launched by this script when BGEE exits.
closeCheatEngineOnGameExit := ReadBoolSetting("General", "CloseCheatEngineOnGameExit", defaultCloseCheatEngineOnGameExit)

; Logging.
enableLog := ReadBoolSetting("Logging", "EnableLog", defaultEnableLog)
logPath := ResolveScriptPath(ReadTextSetting("Logging", "LogPath", defaultLogPath))
maxLogSizeKB := ReadIntSetting("Logging", "MaxLogSizeKB", defaultMaxLogSizeKB, 64, 10240)

; =========================
; Internal state
; =========================

ctLaunchedForCurrentRun := false
lastGamePid := 0
gameDetectedTick := 0
launchedCePid := 0
resolvedCeExe := ResolveCheatEnginePath(ceExe)

LogMessage("Helper started.")
LogMessage("Settings loaded from: " settingsPath)

if !FileExist(ctPath) {
    LogMessage("CT file not found: " ctPath)
    if startupWarningNotify {
        ShowNotify("CT file not found:`n" ctPath, warningNotifyOptions)
    }
}

if resolvedCeExe = "" {
    LogMessage("Cheat Engine executable was not found.")
    if startupWarningNotify {
        ShowNotify("Cheat Engine was not found. Edit CheatEngineExe in settings.ini.", warningNotifyOptions)
    }
} else {
    LogMessage("Cheat Engine path resolved: " resolvedCeExe)
}

SetTimer WatchBGEE, watchIntervalMs

WatchBGEE() {
    global gameExeCandidates, ctPath, resolvedCeExe
    global ctLaunchedForCurrentRun, lastGamePid, gameDetectedTick, launchedCePid
    global closeCheatEngineOnGameExit, attachNotify, normalNotifyOptions

    pid := FindProcess(gameExeCandidates)

    if pid {
        if pid != lastGamePid {
            lastGamePid := pid
            gameDetectedTick := A_TickCount
            ctLaunchedForCurrentRun := false
            LogMessage("BGEE process detected. PID: " pid)
        }

        if ShouldOpenCheatTable() {
            try {
                Run '"' resolvedCeExe '" "' ctPath '"', , "Min", &newCePid
                launchedCePid := newCePid
                ctLaunchedForCurrentRun := true
                LogMessage("Cheat Engine table opened. CE PID: " launchedCePid)
                if attachNotify {
                    ShowNotify("BGEE detected. Cheat Engine table opened.", normalNotifyOptions)
                }
            } catch as err {
                LogMessage("Failed to open Cheat Engine table: " err.Message)
            }
        }
    } else {
        if lastGamePid != 0 {
            LogMessage("BGEE process exited. Previous PID: " lastGamePid)
            if closeCheatEngineOnGameExit {
                CloseLaunchedCheatEngine()
            }
        }
        lastGamePid := 0
        gameDetectedTick := 0
        ctLaunchedForCurrentRun := false
    }
}

CloseLaunchedCheatEngine() {
    global launchedCePid, exitNotify, normalNotifyOptions

    if launchedCePid && ProcessExist(launchedCePid) {
        try {
            ProcessClose launchedCePid
            LogMessage("Cheat Engine process closed by helper. PID: " launchedCePid)
            if exitNotify {
                ShowNotify("BGEE closed. Cheat Engine process closed.", normalNotifyOptions)
            }
        } catch as err {
            LogMessage("Failed to close Cheat Engine process: " err.Message)
        }
    } else if launchedCePid {
        LogMessage("Cheat Engine process was already closed. PID: " launchedCePid)
    }

    launchedCePid := 0
}

ShouldOpenCheatTable() {
    global ctPath, resolvedCeExe
    global autoOpenCheatTable, useOpenTableDelay, openTableDelayMs, requireGameWindowBeforeOpen
    global ctLaunchedForCurrentRun, gameDetectedTick

    if !autoOpenCheatTable {
        return false
    }

    if ctLaunchedForCurrentRun || !FileExist(ctPath) || resolvedCeExe = "" {
        return false
    }

    if requireGameWindowBeforeOpen && !IsBGEEWindowAvailable() {
        return false
    }

    if useOpenTableDelay && (gameDetectedTick = 0 || A_TickCount - gameDetectedTick < openTableDelayMs) {
        return false
    }

    return true
}

FindProcess(exeNames) {
    for exeName in exeNames {
        pid := ProcessExist(exeName)
        if pid {
            return pid
        }
    }
    return 0
}

IsBGEEWindowAvailable() {
    global gameExeCandidates
    for exeName in gameExeCandidates {
        if WinExist("ahk_exe " exeName) {
            return true
        }
    }
    return false
}

ResolveCheatEnginePath(manualPath) {
    manualPath := Trim(manualPath)
    if manualPath != "" && FileExist(manualPath) {
        return manualPath
    }

    candidates := [
        A_ProgramFiles "\Cheat Engine 7.6\cheatengine-x86_64.exe",
        A_ProgramFiles "\Cheat Engine 7.5\cheatengine-x86_64.exe",
        A_ProgramFiles "\Cheat Engine 7.4\cheatengine-x86_64.exe",
        A_ProgramFiles "\Cheat Engine\cheatengine-x86_64.exe",
        A_ProgramFiles "\Cheat Engine 7.6\cheatengine.exe",
        A_ProgramFiles "\Cheat Engine 7.5\cheatengine.exe",
        A_ProgramFiles "\Cheat Engine 7.4\cheatengine.exe",
        A_ProgramFiles "\Cheat Engine\cheatengine.exe"
    ]

    for path in candidates {
        if FileExist(path) {
            return path
        }
    }

    return ""
}

ReadTextSetting(section, key, defaultValue) {
    global settingsPath
    try {
        value := IniRead(settingsPath, section, key, defaultValue)
        return Trim(value)
    } catch {
        return defaultValue
    }
}

ReadBoolSetting(section, key, defaultValue) {
    value := StrLower(ReadTextSetting(section, key, defaultValue ? "true" : "false"))

    if value = "true" || value = "1" || value = "yes" || value = "on" {
        return true
    }

    if value = "false" || value = "0" || value = "no" || value = "off" {
        return false
    }

    return defaultValue
}

ReadIntSetting(section, key, defaultValue, minValue := "", maxValue := "") {
    value := ReadTextSetting(section, key, String(defaultValue))

    if !RegExMatch(value, "^-?\d+$") {
        return defaultValue
    }

    number := Integer(value)

    if minValue != "" && number < minValue {
        return defaultValue
    }

    if maxValue != "" && number > maxValue {
        return defaultValue
    }

    return number
}

ReadCsvSetting(section, key, defaultValue) {
    value := ReadTextSetting(section, key, defaultValue)
    items := []

    for rawItem in StrSplit(value, ",") {
        item := Trim(rawItem)
        if item != "" {
            items.Push(item)
        }
    }

    if items.Length = 0 {
        for rawItem in StrSplit(defaultValue, ",") {
            item := Trim(rawItem)
            if item != "" {
                items.Push(item)
            }
        }
    }

    return items
}

ResolveScriptPath(pathValue) {
    pathValue := Trim(pathValue)

    if pathValue = "" {
        return ""
    }

    if RegExMatch(pathValue, "i)^[A-Z]:\\") || SubStr(pathValue, 1, 2) = "\\" {
        return pathValue
    }

    return A_ScriptDir "\" pathValue
}

CreateDefaultSettings(path) {
    content := ""
    content .= "; BGEE-Hold2Turbo settings`n"
    content .= "; Edit this file to change local helper behavior.`n`n"
    content .= "[Paths]`n"
    content .= "CheatTablePath=BGEE-Hold2Turbo.ct`n"
    content .= "CheatEngineExe=`n`n"
    content .= "[General]`n"
    content .= "GameExeCandidates=Baldur.exe,Baldur64.exe`n"
    content .= "AutoOpenCheatTable=true`n"
    content .= "UseOpenTableDelay=false`n"
    content .= "OpenTableDelayMs=3000`n"
    content .= "RequireGameWindowBeforeOpen=true`n"
    content .= "WatchIntervalMs=1000`n"
    content .= "CloseCheatEngineOnGameExit=true`n`n"
    content .= "[Notifications]`n"
    content .= "AttachNotify=false`n"
    content .= "ExitNotify=false`n"
    content .= "StartupWarningNotify=true`n"
    content .= "NormalNotifyOptions=Iconi`n"
    content .= "WarningNotifyOptions=Icon!`n`n"
    content .= "[Logging]`n"
    content .= "EnableLog=true`n"
    content .= "LogPath=logs\BGEE-Hold2Turbo.log`n"
    content .= "MaxLogSizeKB=512`n"

    try {
        FileAppend content, path, "UTF-8"
    }
}

LogMessage(message) {
    global enableLog, logPath, maxLogSizeKB

    if !enableLog || logPath = "" {
        return
    }

    try {
        SplitPath logPath, , &logDir
        if logDir != "" && !DirExist(logDir) {
            DirCreate logDir
        }

        if FileExist(logPath) {
            sizeKB := FileGetSize(logPath, "K")
            if sizeKB > maxLogSizeKB {
                backupPath := logPath ".old"
                if FileExist(backupPath) {
                    FileDelete backupPath
                }
                FileMove logPath, backupPath
            }
        }

        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        FileAppend "[" timestamp "] " message "`n", logPath, "UTF-8"
    } catch {
        ; Logging should never stop the helper.
    }
}

ShowNotify(message, options := "Iconi") {
    TrayTip message, "BGEE-Hold2Turbo", options
}
