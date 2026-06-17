#Requires AutoHotkey v2.0
#SingleInstance Force

; BGEE-Hold2Turbo
; Watches for Baldur's Gate: Enhanced Edition and opens the included
; Cheat Engine table after a short startup delay.
;
; This script does not remap input keys or control Speedhack directly.
; Configure the hold key and turbo speed inside Cheat Engine's hotkey settings.
;
; Place BGEE-Hold2Turbo.ct in the same folder as this script.

; =========================
; User settings
; =========================

gameExeCandidates := [
    "Baldur.exe",
    "Baldur64.exe"
]

ctPath := A_ScriptDir "\BGEE-Hold2Turbo.ct"

; Set this manually if auto-detection fails.
; Example:
; ceExe := "C:\Program Files\Cheat Engine 7.5\cheatengine-x86_64.exe"
ceExe := ""

; If BGEE closes when the CT is opened automatically, set this to false.
; You can then open BGEE-Hold2Turbo.ct manually after BGEE reaches the main menu.
autoOpenCheatTable := true

; Wait before opening the CT after the BGEE process appears.
; This avoids attaching while the game is still starting up.
openTableDelayMs := 12000

; Only open the CT after a BGEE window exists, not immediately after the process appears.
requireGameWindowBeforeOpen := true

watchIntervalMs := 1000
showTrayTips := true

; =========================
; Internal state
; =========================

ctLaunchedForCurrentRun := false
lastGamePid := 0
gameDetectedTick := 0
resolvedCeExe := ResolveCheatEnginePath(ceExe)

if !FileExist(ctPath) {
    TrayTip "CT file not found:`n" ctPath, "BGEE-Hold2Turbo", 5
}

if resolvedCeExe = "" {
    TrayTip "Cheat Engine was not found. Edit ceExe in the AHK script.", "BGEE-Hold2Turbo", 7
}

SetTimer WatchBGEE, watchIntervalMs

WatchBGEE() {
    global gameExeCandidates, ctPath, resolvedCeExe
    global autoOpenCheatTable, openTableDelayMs, requireGameWindowBeforeOpen
    global ctLaunchedForCurrentRun, lastGamePid, gameDetectedTick, showTrayTips

    pid := FindProcess(gameExeCandidates)

    if pid {
        if pid != lastGamePid {
            lastGamePid := pid
            gameDetectedTick := A_TickCount
            ctLaunchedForCurrentRun := false
        }

        if ShouldOpenCheatTable() {
            Run '"' resolvedCeExe '" "' ctPath '"', , "Min"
            ctLaunchedForCurrentRun := true
            if showTrayTips {
                TrayTip "BGEE detected. Cheat Engine table opened after startup delay.", "BGEE-Hold2Turbo", 3
            }
        }
    } else {
        lastGamePid := 0
        gameDetectedTick := 0
        ctLaunchedForCurrentRun := false
    }
}

ShouldOpenCheatTable() {
    global ctPath, resolvedCeExe
    global autoOpenCheatTable, openTableDelayMs, requireGameWindowBeforeOpen
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

    if gameDetectedTick = 0 || A_TickCount - gameDetectedTick < openTableDelayMs {
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
